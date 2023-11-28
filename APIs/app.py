from flask import Flask
from config import DevelopmentConfig
from database import db
from flask_cors import CORS

from controllers import extra_expense_controller

app = Flask(__name__)
CORS(app)
app.config.from_object(DevelopmentConfig)
db.init_app(app)

app.register_blueprint(extra_expense_controller.bp_extra_expense)
if __name__ == "__main__":
    app.run(host="0.0.0.0")
