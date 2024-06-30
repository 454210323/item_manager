from operator import methodcaller
from flask import Blueprint, jsonify, request
from database import db
import requests
from bs4 import BeautifulSoup
from models.dtos.favorite_item import FavoriteItem
from datetime import datetime

from models.dtos.item import Item

bp_online_store = Blueprint("online_store", __name__, url_prefix="/OnlineStore")


def fetch_stock(item_code: str):

    item_url = "https://chiikawamarket.jp/collections/newitems/products/{item_code}"
    try:
        html_content = requests.get(item_url.format(item_code=item_code)).text
        soup = BeautifulSoup(html_content, "html.parser")
        div_options = soup.find("div", class_="product-form--options")
        option_tag = div_options.find("option", selected=True)
        stock_quantity = option_tag.get("data-inventory-quantity")
        return int(stock_quantity)
    except:
        return None


@bp_online_store.route("/Favorite", methods=["POST"])
def _add_favorite_item():
    item_code = request.json.get("item_code")
    stock_quantity = fetch_stock(item_code)
    check_time = datetime.now()
    favorite_item = FavoriteItem(
        item_code=item_code, check_datetime=check_time, stock_quantity=stock_quantity
    )
    db.session.add(favorite_item)

    item: Item = Item.query.get(item_code)

    db.session.commit()
    return jsonify(item.to_dict() | favorite_item.to_dict()), 200


@bp_online_store.route("/StockMonitoring", methods=["GET"])
def _stock_monitoring():

    item_codes = [
        result[0]
        for result in db.session.query(FavoriteItem.item_code).distinct().all()
    ]

    items: list[Item] = Item.query.filter(Item.item_code.in_(item_codes)).all()
    check_time = datetime.now()
    return_list = []
    for item in items:
        stock_quantity = fetch_stock(item.item_code)
        favorite_item = FavoriteItem(
            item_code=item.item_code,
            check_datetime=check_time,
            stock_quantity=stock_quantity,
        )
        db.session.add(favorite_item)
        data = item.to_dict() | favorite_item.to_dict()
        return_list.append(data)

    db.session.commit()

    return jsonify({"items": return_list})
