from flask import Flask
from config import DevelopmentConfig
from database import db
from flask_cors import CORS

from controllers import (
    item_controller,
    extra_expense_controller,
    stock_controller,
    shipment_controller,
    stub_controller,
)

app = Flask(__name__)
CORS(app)
app.config.from_object(DevelopmentConfig)
db.init_app(app)

app.register_blueprint(item_controller.bp_item)
app.register_blueprint(extra_expense_controller.bp_extra_expense)
app.register_blueprint(stock_controller.bp_stock)
app.register_blueprint(shipment_controller.shipment_blueprint)
app.register_blueprint(stub_controller.bp_stub)

if __name__ == "__main__":
    app.run(host="0.0.0.0")
