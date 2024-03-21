from sqlalchemy import Column, DECIMAL, String
from base import Base


class Item(Base):
    __tablename__ = "item"
    item_id = Column(String(100), primary_key=True, nullable=False)
    item_code = Column(String(255), nullable=False)
    item_name = Column(String(255), default=None)
    item_type = Column(String(255), default=None)
    series = Column(String(255), default=None)
    price = Column(DECIMAL(10, 0), default=None)
