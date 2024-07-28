from sqlalchemy import PrimaryKeyConstraint
from sqlalchemy import Column, DECIMAL, String, Integer, Date
from base import Base


class ChiikawaOnlineOrder(Base):
    __tablename__ = "chiikawa_online_order"
    order_no = Column(String, primary_key=True)
    order_url = Column(String)
    order_date = Column(Date)
    order_status = Column(String)
    orderer = Column(String)
    __table_args__ = (
        PrimaryKeyConstraint("order_no", name="chiikawa_online_order_pk"),
    )

    def to_dict(self):
        return {
            "order_no": self.order_no,
            "order_url": self.order_url,
            "order_date": self.order_date.isoformat(),
            "order_status": self.order_status,
            "orderer": self.orderer,
        }
