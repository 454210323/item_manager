from database import db


class User(db.Model):
    __tablename__ = "users"

    username = db.Column(db.String(50), primary_key=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)

    def __repr__(self):
        return f"<User {self.username}>"

    def to_dict(self):
        return {"username": self.username, "password": self.password}
