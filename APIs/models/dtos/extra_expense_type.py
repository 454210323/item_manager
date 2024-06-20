from database import db


class ExtraExpenseType(db.Model):
    __tablename__ = "extra_expense_type"

    id = db.Column(db.Integer, primary_key=True)
    expense_type = db.Column(db.String, nullable=False)

    def to_dict(self):
        return {"id": self.id, "extra_expense_type": self.expense_type}
