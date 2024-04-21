from typing import List
from flask import Blueprint, request, jsonify
from models.dtos.recipient import Recipient
from models.dtos.shipment import Shipment
from database import db
import logging
from datetime import datetime


shipment_blueprint = Blueprint("shipment_blueprint", __name__, url_prefix="/Shipment")


@shipment_blueprint.route("/Recipient/all", methods=["GET"])
def get_recipients():
    try:
        recipients: List[Recipient] = Recipient.query.all()
        recipients_data = [recipient.recipient for recipient in recipients]

        return jsonify({"recipients": recipients_data}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@shipment_blueprint.route("/Shipment", methods=["POST"])
def create_shipments():
    data = request.json

    ship_date = data["date"]
    shipments = data["data"]
    recipient = data["recipient"]
    if not ship_date or not shipments or not recipient:
        return jsonify("Invalid data"), 400

    try:
        new_shipments = []
        for shipment in shipments:
            if not all(key in shipment for key in ["itemCode", "price", "quantity"]):
                return jsonify({"error": "Missing data in one or more shipments"}), 400

            new_shipment = Shipment(
                item_code=shipment["itemCode"],
                price=shipment["price"],
                quantity=shipment["quantity"],
                shipment_date=datetime.fromisoformat(ship_date),
                recipient=recipient,
            )
            new_shipments.append(new_shipment)

        db.session.add_all(new_shipments)
        db.session.commit()

        return jsonify({"message": "Shipments added successfully"}), 200

    except Exception as e:
        print(str(e))
        return jsonify({"error": str(e)}), 500


@shipment_blueprint.route("ShipmentDate", methods=["GET"])
def _get_shipment_date():
    # shipment_dates = [
    #     shipment_date.strftime("%Y-%m-%d")
    #     for shipment_date in db.session.query(Shipment.shipment_date).distinct().all()
    # ]
    shipment_dates = list(
        set(
            [
                shipment_date_set[0].strftime("%Y-%m-%d")
                for shipment_date_set in db.session.query(Shipment.shipment_date)
                .distinct()
                .all()
            ]
        )
    )
    shipment_dates.sort()

    return (
        jsonify(shipment_dates=shipment_dates),
        200,
    )
