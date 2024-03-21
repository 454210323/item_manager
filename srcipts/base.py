from sqlalchemy import create_engine, Column, Integer, String, Sequence
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

Base = declarative_base()

connection_url = "mysql+pymysql://root:admin@localhost:3306/dev"

engine = create_engine(connection_url, echo=True)
Base.metadata.create_all(engine)
Session = sessionmaker(bind=engine)
