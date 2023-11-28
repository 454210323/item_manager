from typing import List, Dict, Optional, Union, Any
from flask import Blueprint, jsonify, request
from models.dtos.extra_expense import ExtraExpense

bp_extra_expense = Blueprint("extra_expense", __name__, url_prefix="/extra_expense")


@bp_extra_expense.route("/getAllStoreInPark")
def _get_extra_expense():
    extra_expenses = ExtraExpense.query.all()
    return jsonify(extra_expenses), 200
