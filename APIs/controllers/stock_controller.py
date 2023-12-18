from flask import Blueprint, jsonify, request
from models.dtos.item import Item
from database import db

bp_stock = Blueprint("stock", __name__, url_prefix="/Stock")


@bp_stock.route("/Stock", methods=["POST"])
def _register_stock():
    data = request.json
    purchase_date = data["purchaseDate"]
    stocks = data["stocks"]
    print(purchase_date)
    print(stocks)
    return "", 200
