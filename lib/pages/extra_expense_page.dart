import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/extra_expense.dart';
import 'package:flutter_application_1/pages/register_extra_expense_page.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../widgets/dynamic_data_table.dart';
import '../widgets/travel_expenses.dart';

class ExtraExpensePage extends StatefulWidget {
  const ExtraExpensePage({super.key});

  @override
  _ExtraExpensePageState createState() => _ExtraExpensePageState();
}

class _ExtraExpensePageState extends State<ExtraExpensePage> {
  // List<bool> _isSelected = [true, false, false];
  int currentIndex = 0;

  List<ExtraExpense> _extraExpenses = [];

  Widget _buildContent() {
    switch (currentIndex) {
      case 0:
        return const Center(child: Text('content 1'));
      case 1:
        return const Center(child: Text('content 2'));
      case 2:
        return const Center(child: TravelExpenses());
      default:
        return const Center(child: Text('content 1'));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var url = Uri.parse(API.GET_EXTRA_EXPENSE);
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
            // ToggleButtons(
            //   isSelected: _isSelected,
            //   children: const <Widget>[
            //     Icon(
            //       Icons.currency_yen,
            //     ),
            //     Icon(
            //       Icons.directions_car,
            //     ),
            //     Icon(
            //       Icons.train,
            //     ),
            //   ],
            //   onPressed: (int index) {
            //     setState(() {
            //       for (int buttonIndex = 0;
            //           buttonIndex < _isSelected.length;
            //           buttonIndex++) {
            //         _isSelected[buttonIndex] = buttonIndex == index;
            //       }
            //       currentIndex = index;
            //     });
            //   },
            // ),
            // Expanded(child: _buildContent()),
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
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: _extraExpenses.isEmpty
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DynamicDataTable(
                          data: _extraExpenses,
                          visibleColumns: const [
                            'expenseType',
                            'expense',
                            'expenseContent',
                            'expenseDate'
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
