from typing import List
from flask import Blueprint, request, jsonify
from models.dtos.recipient import Recipient
from models.dtos.shipment import Shipment
from database import db
import logging
from datetime import datetime


shipment_blueprint = Blueprint("shipment_blueprint", __name__, url_prefix="/Shipment")


@shipment_blueprint.route("/recipients", methods=["GET"])
def get_recipients():
    try:
        recipients: List[Recipient] = Recipient.query.all()
        recipients_data = [
            {"id": recipient.id, "name": recipient.recipient}
            for recipient in recipients
        ]

        return jsonify({"recipients": recipients_data}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@shipment_blueprint.route("/shipments", methods=["POST"])
def create_shipments():
    data = request.json

    if not isinstance(data, list):
        return jsonify({"error": "Expected a list of shipments"}), 400

    try:
        new_shipments = []
        for shipment_data in data:
            if not all(
                key in shipment_data
                for key in ["item_code", "shipment_date", "recipient_id"]
            ):
                return jsonify({"error": "Missing data in one or more shipments"}), 400

            new_shipment = Shipment(
                item_code=shipment_data["item_code"],
                shipment_date=datetime.strptime(
                    shipment_data["shipment_date"], "%Y-%m-%dT%H:%M:%S"
                ),
                recipient_id=shipment_data["recipient_id"],
            )
            new_shipments.append(new_shipment)

        db.session.add_all(new_shipments)
        db.session.commit()

        return jsonify({"message": "Shipments added successfully"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
