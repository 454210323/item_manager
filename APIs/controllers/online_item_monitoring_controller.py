from flask import Blueprint, jsonify, request
import requests
from bs4 import BeautifulSoup

bp_stock_monitoring = Blueprint("stock_monitoring", __name__, url_prefix="")


@bp_stock_monitoring.route("/StockMonitoring", methods=["GET"])
def _stock_monitoring():

    item_code = request.args.get("code")

    item_url = "https://chiikawamarket.jp/collections/newitems/products/{item_code}"

    html_content = requests.get(item_url.format(item_code=item_code)).text
    soup = BeautifulSoup(html_content, "html.parser")
    div_options = soup.find("div", class_="product-form--options")
    option_tag = div_options.find("option", selected=True)
    inventory_quantity = option_tag.get("data-inventory-quantity")
    return inventory_quantity
