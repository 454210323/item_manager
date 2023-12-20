from database import db


class Recipient(db.Model):
    __tablename__ = "recipient"

    id = db.Column(db.Integer, primary_key=True)
    recipient = db.Column(db.String(100), nullable=False)

    def __repr__(self):
        return f"<Recipient {self.id}: {self.recipient}>"
