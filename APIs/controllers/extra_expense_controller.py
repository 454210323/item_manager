from typing import List, Dict, Optional, Union, Any
from flask import Blueprint, jsonify, request
from models.dtos.extra_expense import ExtraExpense
from database import db
import logging

from models.dtos.extra_expense_type import ExtraExpenseType


bp_extra_expense = Blueprint("extra_expense", __name__, url_prefix="/ExtraExpense")


@bp_extra_expense.route("/ExtraExpenseType")
def _get_extra_expense_type():
    extra_expense_types = ExtraExpenseType.query.all()
    return (
        jsonify(
            {
                "extra_expense_types": [
                    extra_expense_type.to_dict()
                    for extra_expense_type in extra_expense_types
                ]
            },
        ),
        200,
    )


@bp_extra_expense.route("/ExtraExpense/all")
def _get_all_extra_expense():
    extra_expenses = ExtraExpense.query.order_by(ExtraExpense.expense_date).all()

    return (
        jsonify(
            {
                "extra_expenses": [
                    extra_expense.to_dict() for extra_expense in extra_expenses
                ]
            }
        ),
        200,
    )


@bp_extra_expense.route("/ExtraExpense", methods=["POST"])
def _register_extra_expense():
    data = request.json

    try:
        new_expense = ExtraExpense(
            expense_type=data["expenseType"],
            expense=data["expense"],
            expense_content=data["content"],
            expense_date=data["expenseDate"],
        )
        db.session.add(new_expense)
        db.session.commit()
        return jsonify({"message": "Shipments added successfully"}), 200
    except Exception as e:
        logging.info(e)
        return jsonify({"error": str(e)}), 500
