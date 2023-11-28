from database import db


class ExtraExpense(db.Model):
    __tablename__ = "extra_expense"

    id = db.Column(db.Integer, primary_key=True)  # 对应于表中的 id 字段
    expense_type = db.Column(db.String, nullable=False)  # 对应于表中的 expense_type 字段
    expense = db.Column(db.Numeric, nullable=False)  # 对应于表中的 expense 字段
    expense_content = db.Column(db.String, nullable=True)  # 对应于表中的 expense_content 字段

    def __repr__(self):
        return f"<ExtraExpense {self.id} {self.expense_type}>"
