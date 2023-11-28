from typing import List, Dict, Optional, Union, Any
from flask import Blueprint, jsonify, request
from models.dtos.extra_expense import ExtraExpense


bp_stub = Blueprint("stub", __name__, url_prefix="")


@bp_stub.route("/ItemInfos", methods=["GET"])
def _get_item_list():
    return jsonify(
        {
            "item_infos": [
                {
                    "item_code": "1",
                    "item_name": "包子1",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 1000,
                },
                {
                    "item_code": "2",
                    "item_name": "包子2",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 2000,
                },
                {
                    "item_code": "3",
                    "item_name": "包子3",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 3000,
                },
                {
                    "item_code": "4",
                    "item_name": "包子4",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 4000,
                },
                {
                    "item_code": "5",
                    "item_name": "包子5",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 5000,
                },
                {
                    "item_code": "6",
                    "item_name": "包子6",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 6000,
                },
                {
                    "item_code": "7",
                    "item_name": "包子7",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 7000,
                },
                {
                    "item_code": "8",
                    "item_name": "包子8",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 8000,
                },
                {
                    "item_code": "9",
                    "item_name": "包子9",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 9000,
                },
                {
                    "item_code": "10",
                    "item_name": "包子10",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 10000,
                },
                {
                    "item_code": "11",
                    "item_name": "包子11",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 11000,
                },
                {
                    "item_code": "12",
                    "item_name": "包子12",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 12000,
                },
                {
                    "item_code": "13",
                    "item_name": "包子13",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 13000,
                },
                {
                    "item_code": "14",
                    "item_name": "包子14",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 14000,
                },
                {
                    "item_code": "15",
                    "item_name": "包子15",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 15000,
                },
                {
                    "item_code": "16",
                    "item_name": "包子16",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 16000,
                },
                {
                    "item_code": "17",
                    "item_name": "包子17",
                    "item_type": "AB",
                    "series": "BA",
                    "price": 17000,
                },
            ]
        }
    )


@bp_stub.route("/RegisterItem", methods=["POST"])
def _post_register_item():
    data = request.json

    print("Received data:", data)

    return jsonify({"message": "Data received", "data": data})


@bp_stub.route("/StockShipmentInfos")
def _get_stock_shipment_infos():
    itemCode = request.args.get("itemCode", default=None, type=str)
    itemType = request.args.get("itemType", default=None, type=str)
    itemseries = request.args.get("itemseries", default=None, type=str)

    print("Received parameters:", itemCode, itemType, itemseries)
    return jsonify(
        {
            "stock_shipment_infos": [
                {
                    "item_code": "1000",
                    "item_type": "a1",
                    "series": "a2",
                    "item_name": "a3",
                    "price": 10000,
                    "stock_quantity": 20,
                    "shipment_quantity": 10,
                },
                {
                    "item_code": "1001",
                    "item_type": "b1",
                    "series": "b2",
                    "item_name": "b3",
                    "price": 20000,
                    "stock_quantity": 10,
                    "shipment_quantity": 10,
                },
                {
                    "item_code": "1002",
                    "item_type": "b1",
                    "series": "b2",
                    "item_name": "b3",
                    "price": 30000,
                    "stock_quantity": 100,
                    "shipment_quantity": 10,
                },
            ]
        }
    )


@bp_stub.route("/ItemTypes")
def _get_types():
    return jsonify(
        {"item_types": ["type1", "type2", "type3", "type4", "type5", "type6"]}
    )


@bp_stub.route("/ItemSeries")
def _get_series():
    return jsonify({"series": ["series1", "series2", "series3", "series4", "series5"]})


@bp_stub.route("/RegisterExtraExpense", methods=["POST"])
def _post_register_extra_expense():
    data = request.json

    print("Received data:", data)

    return jsonify({"message": "Data received", "data": data})
