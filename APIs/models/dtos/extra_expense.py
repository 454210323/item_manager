from database import db


class ExtraExpense(db.Model):
    __tablename__ = "extra_expense"

    id = db.Column(db.Integer, primary_key=True)
    expense_type = db.Column(db.String, nullable=False)
    expense = db.Column(db.Numeric, nullable=False)
    expense_content = db.Column(db.String, nullable=True)
    expense_date = db.Column(db.Date, nullable=True)

    def __repr__(self):
        return f"<ExtraExpense {self.id} {self.expense_type}>"

    def to_dict(self):
        return {
            "id": self.id,
            "expense_type": self.expense_type,
            "expense": self.expense,
            "expense_content": self.expense_content,
            "expense_date": self.expense_date.isoformat(),
        }
