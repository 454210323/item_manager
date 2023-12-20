from flask import Blueprint, jsonify, request
from sqlalchemy.sql import func
from models.dtos.item import Item
from database import db
from models.dtos.shipment import Shipment
from models.dtos.stock import Stock
from datetime import datetime
import logging

bp_stock = Blueprint("stock", __name__, url_prefix="/Stock")


@bp_stock.route("/Stock", methods=["POST"])
def _register_stock():
    data = request.json
    purchase_date = data["purchaseDate"]
    stocks = data["stocks"]
    if not purchase_date or not stocks:
        return jsonify("Invalid data"), 400
    try:
        for stock in stocks:
            if "itemCode" not in stock or "quantity" not in stock:
                return jsonify("Invalid stock data"), 400

            new_stock = Stock(
                item_code=stock["itemCode"],
                quantity=stock["quantity"],
                purchase_date=datetime.fromisoformat(purchase_date),
            )
            db.session.add(new_stock)
        db.session.commit()
        return jsonify({"message": "Shipments added successfully"}), 200
    except Exception as e:
        logging.info(e)
        return jsonify({"error": str(e)}), 500


@bp_stock.route("/StockShipment/all", methods=["GET"])
def items_summary():
    results = (
        db.session.query(
            Item.item_code,
            Item.item_name,
            func.coalesce(func.sum(Stock.quantity), 0).label("total_stock"),
            func.coalesce(func.sum(Shipment.quantity), 0).label("total_shipment"),
        )
        .outerjoin(Stock, Item.item_code == Stock.item_code)
        .outerjoin(Shipment, Item.item_code == Shipment.item_code)
        .group_by(Item.item_code)
        .all()
    )

    items_summary = [
        {
            "item_code": item.item_code,
            "item_name": item.item_name,
            "total_stock": item.total_stock,
            "total_shipment": item.total_shipment,
            "remaining_quantity": item.total_stock - item.total_shipment,
        }
        for item in results
    ]
    return jsonify(items_summary), 200
