import 'package:flutter/material.dart';

import '../widgets/travel_expenses.dart';

class ExtraExpensePage extends StatefulWidget {
  const ExtraExpensePage({super.key});

  @override
  _ExtraExpensePageState createState() => _ExtraExpensePageState();
}

class _ExtraExpensePageState extends State<ExtraExpensePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Extra Expense")),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: TravelExpenses(),
      ),
    );
  }
}
