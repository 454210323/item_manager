from sqlalchemy import PrimaryKeyConstraint, Column, String, DateTime, Integer
from base import Base


class FavoriteItem(Base):
    __tablename__ = "favorite_item"

    item_code = Column(String, primary_key=True)
    check_datetime = Column(DateTime, primary_key=True)
    stock_quantity = Column(Integer)

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
