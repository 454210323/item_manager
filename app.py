from time import sleep
from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


@app.route("/ItemInfos", methods=["GET"])
def _get_item_list():
    sleep(2)
    return jsonify(
        {
            "item_infos": [
                {"item_code": "1", "item_name": "包子1", "price": 1000},
                {"item_code": "2", "item_name": "包子2", "price": 2000},
                {"item_code": "3", "item_name": "包子3", "price": 3000},
                {"item_code": "4", "item_name": "包子4", "price": 4000},
                {"item_code": "5", "item_name": "包子5", "price": 5000},
                {"item_code": "6", "item_name": "包子6", "price": 6000},
                {"item_code": "7", "item_name": "包子7", "price": 7000},
                {"item_code": "8", "item_name": "包子8", "price": 8000},
                {"item_code": "9", "item_name": "包子9", "price": 9000},
                {"item_code": "10", "item_name": "包子10", "price": 10000},
                {"item_code": "11", "item_name": "包子11", "price": 11000},
                {"item_code": "12", "item_name": "包子12", "price": 12000},
                {"item_code": "13", "item_name": "包子13", "price": 13000},
                {"item_code": "14", "item_name": "包子14", "price": 14000},
                {"item_code": "15", "item_name": "包子15", "price": 15000},
                {"item_code": "16", "item_name": "包子16", "price": 16000},
                {"item_code": "17", "item_name": "包子17", "price": 17000},
            ]
        }
    )


@app.route("/RegisterItem", methods=["POST"])
def _post_register_item():
    data = request.json

    print("Received data:", data)

    return jsonify({"message": "Data received", "data": data})


@app.route("/StockShipmentInfos")
def _get_stock_shipment_infos():
    itemCode = request.args.get("itemCode", default=None, type=str)
    itemType = request.args.get("itemType", default=None, type=str)
    itemSerise = request.args.get("itemSerise", default=None, type=str)

    print("Received parameters:", itemCode, itemType, itemSerise)
    return jsonify(
        {
            "stock_shipment_infos": [
                {
                    "item_code": "1000",
                    "item_type": "a1",
                    "item_serise": "a2",
                    "item_name": "a3",
                    "price": 10000,
                    "stock_quantity": 20,
                    "shipment_quantity": 10,
                },
                {
                    "item_code": "1001",
                    "item_type": "b1",
                    "item_serise": "b2",
                    "item_name": "b3",
                    "price": 20000,
                    "stock_quantity": 10,
                    "shipment_quantity": 10,
                },
                {
                    "item_code": "1002",
                    "item_type": "b1",
                    "item_serise": "b2",
                    "item_name": "b3",
                    "price": 30000,
                    "stock_quantity": 100,
                    "shipment_quantity": 10,
                },
            ]
        }
    )


@app.route("/ItemTypes")
def _get_item_types():
    return jsonify(
        {"item_types": ["type1", "type2", "type3", "type4", "type5", "type6"]}
    )


@app.route("/ItemSerises")
def _get_item_serises():
    return jsonify(
        {"item_serises": ["serises1", "serises2", "serises3", "serises4", "serises5"]}
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
