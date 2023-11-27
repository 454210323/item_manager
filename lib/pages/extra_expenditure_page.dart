import 'package:flutter/material.dart';

import '../widgets/travel_expenses.dart';

class ExtraExpenditurePage extends StatefulWidget {
  const ExtraExpenditurePage({super.key});

  @override
  _ExtraExpenditurePageState createState() => _ExtraExpenditurePageState();
}

class _ExtraExpenditurePageState extends State<ExtraExpenditurePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Extra Expenditure")),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: TravelExpenses(),
      ),
    );
  }
}
