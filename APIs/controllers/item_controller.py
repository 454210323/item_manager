from flask import Blueprint, jsonify, request
from models.dtos.item import Item
from database import db

bp_item = Blueprint("item", __name__, url_prefix="Item")


@bp_item.route("/Item/all")
def _get_all_item():
    items = Item.query.all()
    return jsonify({"items": [item.to_dict() for item in items]}), 200


@bp_item.route("/Item")
def _get_item_by_item_code():
    itemCode = request.args.get("itemCode", default=None, type=str)

    item: Item = Item.query.get(itemCode)
    if item:
        return jsonify({"item": item.to_dict()}), 200
    else:
        return jsonify({"item": ""}), 400
