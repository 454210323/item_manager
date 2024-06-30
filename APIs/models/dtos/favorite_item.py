from sqlalchemy import PrimaryKeyConstraint
from database import db


class FavoriteItem(db.Model):
    __tablename__ = "favorite_item"

    item_code = db.Column(db.String, primary_key=True)
    check_datetime = db.Column(db.DateTime, primary_key=True)
    stock_quantity = db.Column(db.Integer)

    __table_args__ = (
        PrimaryKeyConstraint("item_code", "check_datetime", name="favorite_item_pk"),
    )

    def __repr__(self):
        return f"<FavoriteItem(item_code='{self.item_code}', check_datetime='{self.check_datetime}', stock_quantity={self.stock_quantity})>"

    def to_dict(self):
        return {
            "item_code": self.item_code,
            "check_datetime": self.check_datetime.isoformat(),
            "stock_quantity": self.stock_quantity,
        }
