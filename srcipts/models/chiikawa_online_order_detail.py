from sqlalchemy import PrimaryKeyConstraint
from sqlalchemy import Column, DECIMAL, String, Integer, Date
from base import Base


class ChiikawaOnlineOrderDetail(Base):
    __tablename__ = "chiikawa_online_order_detail"
    order_no = Column(String, primary_key=True)
    item_code = Column(String, primary_key=True)
    quantity = Column(Integer)
    __table_args__ = (
        PrimaryKeyConstraint(
            "order_no", "item_code", name="chiikawa_online_order_detail_pk"
        ),
    )

    def to_dict(self):
        return {
            "order_no": self.order_no,
            "item_code": self.item_code,
            "quantity": self.quantity,
        }
