from typing import List, Dict, Optional, Union, Any
from flask import Blueprint, jsonify, request
from models.dtos.extra_expense import ExtraExpense, ExtraExpenseSchema
from database import db
import os

from models.dtos.extra_expense_type import ExtraExpenseType


bp_extra_expense = Blueprint("extra_expense", __name__, url_prefix="/ExtraExpense")


@bp_extra_expense.route("/getExtraExpenseTypes")
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


@bp_extra_expense.route("/getAllExtraExpense")
def _get_extra_expense():
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


@bp_extra_expense.route("/registerExtraExpense", methods=["POST"])
def _register_extra_expense():
    data = request.json

    new_expense = ExtraExpense(
        expense_type=data["expenseType"],  # 替换为相应的值
        expense=data["expense"],  # 替换为相应的数值
        expense_content=data["content"],  # 替换为相应的内容，如果有的话
    )
    # 添加到会话并提交
    db.session.add(new_expense)
    db.session.commit()
    return jsonify("success"), 200
