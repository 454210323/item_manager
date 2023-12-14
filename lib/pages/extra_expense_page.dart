import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/extra_expense.dart';
import 'package:flutter_application_1/pages/register_extra_expense_page.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../widgets/dynamic_data_table.dart';

class ExtraExpensePage extends StatefulWidget {
  const ExtraExpensePage({super.key});

  @override
  _ExtraExpensePageState createState() => _ExtraExpensePageState();
}

class _ExtraExpensePageState extends State<ExtraExpensePage> {
  int currentIndex = 0;

  List<ExtraExpense> _extraExpenses = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var url = Uri.parse(API.EXTRA_EXPENSE_ALL);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['extra_expenses'];
      setState(() {
        _extraExpenses = data
            .map<ExtraExpense>((json) => ExtraExpense.fromJson(json))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Extra Expense")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const RegisterExtraExpensePage()),
                  );
                },
                child: const Text('Register New ExtraExpense'),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _extraExpenses.isEmpty
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DynamicDataTable(
                        data: _extraExpenses,
                        visibleColumns: const [
                          'type',
                          'expense',
                          'content',
                          'date'
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
