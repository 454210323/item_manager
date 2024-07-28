from operator import methodcaller
from flask import Blueprint, jsonify, request
from sqlalchemy import asc, case, func, desc, text
from database import db
import requests
from bs4 import BeautifulSoup
from models.dtos import chiikawa_online_order
from models.dtos.chiikawa_online_order import ChiikawaOnlineOrder
from models.dtos.chiikawa_online_order_detail import ChiikawaOnlineOrderDetail
from models.dtos.favorite_item import FavoriteItem
from datetime import datetime, time, timedelta

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
    """
    添加商品到关注列表，以监控在官网的库存情况
    """
    item_code = request.json.get("itemCode")
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
    """
    取得关注商品的最新库存
    """
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

    # subquery = db.session.query(
    #     FavoriteItem.item_code,
    #     FavoriteItem.check_datetime,
    #     FavoriteItem.stock_quantity,
    #     func.row_number()
    #     .over(
    #         partition_by=FavoriteItem.item_code,
    #         order_by=desc(FavoriteItem.check_datetime),
    #     )
    #     .label("rn"),
    # ).subquery()

    # # Query the subquery for the latest rows
    # latest_items = db.session.query(subquery).filter(subquery.c.rn == 1).all()

    return jsonify({"items": return_list})


@bp_online_store.route("/StockHistory")
def _fetch_stock_history():
    """
    按商品编号取得商品的历史库存情况
    """
    item_code = request.args.get("itemCode")
    stock_history: list[FavoriteItem] = FavoriteItem.query.filter(
        FavoriteItem.item_code == item_code
    ).all()
    history_data = [
        {"check_datetime": stock.check_datetime, "stock_quantity": stock.stock_quantity}
        for stock in stock_history
    ]

    return jsonify({"item_code": item_code, "stock_history": history_data}), 200


@bp_online_store.route("/Order")
def _fetch_online_order():

    print(request.args)

    # item_code = request.args.get("itemCode")
    item_name = request.args.get("itemName")
    order_status = request.args.get("orderStatus")
    # item_type = request.args.get("itemType")
    # series = request.args.get("itemSeries")
    start_day = request.args.get("startDay")
    end_day = request.args.get("endDay")

    page = request.args.get("page", 1, type=int)
    page_size = request.args.get("pageSize", 20, type=int)

    query = (
        db.session.query(
            ChiikawaOnlineOrderDetail.item_code,
            Item.item_name,
            func.sum(
                case(
                    (
                        ChiikawaOnlineOrder.order_status == "出荷済み",
                        ChiikawaOnlineOrderDetail.quantity,
                    ),
                    else_=0,
                )
            ).label("shipped_quantity"),
            func.coalesce(func.sum(ChiikawaOnlineOrderDetail.quantity), 0).label(
                "total_quantity"
            ),
            func.min(ChiikawaOnlineOrder.order_date).label("earliest_order_date"),
        )
        .select_from(ChiikawaOnlineOrder)
        .outerjoin(
            ChiikawaOnlineOrderDetail,
            ChiikawaOnlineOrderDetail.order_no == ChiikawaOnlineOrder.order_no,
        )
        .outerjoin(Item, Item.item_code == ChiikawaOnlineOrderDetail.item_code)
        .filter(ChiikawaOnlineOrder.order_date >= datetime.fromisoformat(start_day))
        .filter(
            ChiikawaOnlineOrder.order_date
            <= (datetime.fromisoformat(end_day) + timedelta(days=1))
        )
        .group_by(ChiikawaOnlineOrderDetail.item_code, Item.item_name)
        .order_by(desc("earliest_order_date"))
    )

    if item_name:
        query = query.filter(Item.item_name.like(f"%{item_name}%"))
    if order_status in ["出荷済み", "未発送"]:
        if order_status == "出荷済み":
            query = query.having(
                func.sum(
                    case(
                        (
                            ChiikawaOnlineOrder.order_status == "出荷済み",
                            ChiikawaOnlineOrderDetail.quantity,
                        ),
                        else_=0,
                    )
                )
                == func.coalesce(func.sum(ChiikawaOnlineOrderDetail.quantity), 0)
            )
        else:
            query = query.having(
                func.sum(
                    case(
                        (
                            ChiikawaOnlineOrder.order_status == "出荷済み",
                            ChiikawaOnlineOrderDetail.quantity,
                        ),
                        else_=0,
                    )
                )
                != func.coalesce(func.sum(ChiikawaOnlineOrderDetail.quantity), 0)
            )

    total_count = query.count()

    pagination = query.paginate(page=page, per_page=page_size, error_out=False)
    search_results = pagination.items
    online_orders = [
        {
            "item_code": result.item_code,
            "item_name": result.item_name,
            "shipped_quantity": result.shipped_quantity,
            "total_quantity": result.total_quantity,
            "earliest_order_date": result.earliest_order_date.isoformat(),
        }
        for result in search_results
    ]

    return jsonify({"total_count": total_count, "online_orders": online_orders}), 200


@bp_online_store.route("/EarliestUnshippedOrderDate")
def _fetch_earliest_unshipped_order_date():
    result = (
        db.session.query(ChiikawaOnlineOrder.order_date)
        .filter(ChiikawaOnlineOrder.order_status == "未発送")
        .order_by(asc(ChiikawaOnlineOrder.order_date))
        .first()
    )
    if result:
        earliest_date = result[0]
        return jsonify({"earliest_date": earliest_date.isoformat()}), 200
    else:
        return jsonify({"earliest_date": None}), 200
