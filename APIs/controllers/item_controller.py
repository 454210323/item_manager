from flask import Blueprint, jsonify, request
from sqlalchemy import false, true
from models.dtos.item import Item
from database import db
import logging

bp_item = Blueprint("item", __name__, url_prefix="/Item")


@bp_item.route("/Item/all")
def _get_all_item():
    items = Item.query.all()
    logging.debug(items)
    return jsonify({"items": [item.to_dict() for item in items]}), 200


@bp_item.route("/Item")
def _get_item_by_item_code():
    itemCode = request.args.get("itemCode", default=None, type=str)
    item: Item = Item.query.get(itemCode)
    if item:
        logging.debug(item)
        return jsonify({"item": item.to_dict(), "status": True}), 200
    else:
        return jsonify({"item": "", "status": False}), 200


@bp_item.route("/Item", methods=["POST"])
def _register_item():
    data = request.json
    try:
        new_item = Item(
            item_code=data["itemCode"],
            item_name=data["itemName"],
            item_type=data["itemType"],
            series=data["series"],
            price=data["price"],
        )
        db.session.add(new_item)
        db.session.commit()
        return jsonify({"message": "Item added successfully"}), 200
    except Exception as e:
        logging.info(e)
        return jsonify({"error": str(e)}), 500


@bp_item.route("/Type/all")
def _get_all_types():
    item_types = [
        item_type_set[0]
        for item_type_set in db.session.query(Item.item_type).distinct().all()
    ]
    return jsonify({"item_types": item_types}), 200


@bp_item.route("/Series/all")
def _get_all_series():
    series = [
        series_set[0] for series_set in db.session.query(Item.series).distinct().all()
    ]
    return jsonify({"series": series}), 200
