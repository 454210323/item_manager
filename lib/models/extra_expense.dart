import 'package:decimal/decimal.dart';
import 'table_item.dart';
import 'package:intl/intl.dart';

class ExtraExpense extends TableItem {
  int id;
  String expenseType;
  Decimal expense;
  String expenseContent;
  DateTime expenseDate;

  ExtraExpense(
      {required this.id,
      required this.expenseType,
      required this.expense,
      required this.expenseContent,
      required this.expenseDate});

  factory ExtraExpense.fromJson(Map<String, dynamic> json) {
    return ExtraExpense(
        id: json['id'],
        expenseType: json['expense_type'],
        expense: Decimal.fromJson(json['expense']),
        expenseContent: json['expense_content'],
        expenseDate: DateTime.parse(json['expense_date']));
  }

  @override
  Map<String, dynamic> toTableData() {
    return {
      'id': id,
      'type': expenseType,
      'expense': expense,
      'content': expenseContent,
      'date': DateFormat('yyyy-MM-dd').format(expenseDate),
    };
  }
}
