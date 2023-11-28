from database import db


class Item(db.Model):
    __tablename__ = "item"
    item_code = db.Column(db.String(100), primary_key=True)
    item_name = db.Column(db.String(100))
    item_type = db.Column(db.String(100))
    series = db.Column(db.String(100))
    price = db.Column(db.Numeric(10, 0))
