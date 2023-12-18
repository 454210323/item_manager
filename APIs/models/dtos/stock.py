from database import db


class Stock(db.Model):
    __tablename__ = "stock"

    id = db.Column(db.BigInteger, primary_key=True)
    item_code = db.Column(db.String(100), nullable=False)
    quantity = db.Column(db.Numeric(10, 0), nullable=False)
    purchase_date = db.Column(db.DateTime, nullable=False)

    def __repr__(self):
        return f"<Stock {self.item_code}>"
