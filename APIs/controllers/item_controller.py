from importlib.metadata import requires
from flask import Blueprint, jsonify, request
from sqlalchemy import false, true
from sqlalchemy.orm.exc import NoResultFound
from models.dtos.item import Item
from database import db
import logging
import requests
import os
from azure.storage.blob import ContainerClient

bp_item = Blueprint("item", __name__, url_prefix="/Item")

AZURE_STORAGE_BLOB_URL = os.getenv("AZURE_STORAGE_BLOB_URL")


@bp_item.route("/Item/all")
def _get_all_item():
    items = Item.query.all()
    logging.debug(items)
    return jsonify({"items": [item.to_dict() for item in items]}), 200


@bp_item.route("/Item")
def _get_item_by_item_code():
    item_code = request.args.get("itemCode", default=None, type=str)
    item: Item = Item.query.get(item_code)
    if item:
        logging.debug(item)
        return jsonify({"item": item.to_dict(), "status": True}), 200
    else:
        return jsonify({"item": "", "status": False}), 200


@bp_item.route("/Item", methods=["POST"])
def _register_item():
    data = request.form

    file = request.files.get("image")

    try:
        new_item = Item(
            item_code=data["itemCode"],
            item_name=data["itemName"],
            item_type=data["itemType"],
            series=data["series"],
            price=data["price"],
        )

        if file:
            container_client = ContainerClient(
                account_url=AZURE_STORAGE_BLOB_URL,
                container_name="chiikawa-item-images",
            )

            container_client.upload_blob(
                name=file.filename,
                data=file.stream,
                blob_type="BlockBlob",
                overwrite=True,
            )

        db.session.add(new_item)
        db.session.commit()
        return jsonify({"message": "Item added successfully"}), 200
    except Exception as e:
        logging.info(e)
        return jsonify({"error": str(e)}), 500


@bp_item.route("/Item", methods=["PUT"])
def _update_item():
    data = request.form

    file = request.files.get("image")

    try:
        item_code = data["itemCode"]
        item_name = data["itemName"]
        item_type = data["itemType"]
        series = data["series"]
        price = data["price"]

        item: Item = Item.query.get(item_code)
        if item:
            item.item_name = item_name
            item.item_type = item_type
            item.series = series
            item.price = price

            db.session.commit()
        if file:
            container_client = ContainerClient(
                account_url=AZURE_STORAGE_BLOB_URL,
                container_name="chiikawa-item-images",
            )

            container_client.upload_blob(
                name=file.filename,
                data=file.stream,
                blob_type="BlockBlob",
                overwrite=True,
            )
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


@bp_item.route("/JanCode", methods=["PUT"])
def _update_item_jan_code():
    data = request.json
    item_code = data["itemCode"]
    jan_code = data["janCode"]
    try:
        item: Item = db.session.query(Item).filter(item_code == item_code).first()
        if item:
            item.jan_code = jan_code
            db.session.commit()
            return jsonify({"message": "Update successfully"}), 200
        else:
            raise NoResultFound()
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@bp_item.route("/Conditions")
def _get_item_by_conditions():
    item_code = request.args.get("itemCode", default=None, type=str)
    item_name = request.args.get("itemName", None)
    series = request.args.get("itemSeries", default=None, type=str)
    item_type = request.args.get("itemType", default=None, type=str)
    page = request.args.get("page", 1, type=int)
    page_size = request.args.get("pageSize", 20, type=int)
    query = db.session.query(Item)

    def is_not_empty(s):
        return s is not None and s != ""

    if is_not_empty(item_code):
        query = query.filter(Item.item_code == item_code)
    if is_not_empty(item_name):
        query = query.filter(Item.item_name.like(f"%{item_name}%"))
    if is_not_empty(series):
        query = query.filter(Item.series == series)
    if is_not_empty(item_type):
        query = query.filter(Item.item_type == item_type)

    total_count = query.count()

    pagination = query.paginate(page=page, per_page=page_size, error_out=False)
    items = pagination.items
    return (
        jsonify(
            {"total_count": total_count, "items": [item.to_dict() for item in items]}
        ),
        200,
    )
