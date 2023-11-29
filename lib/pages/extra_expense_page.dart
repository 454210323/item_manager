import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../widgets/travel_expenses.dart';

class ExtraExpensePage extends StatefulWidget {
  const ExtraExpensePage({super.key});

  @override
  _ExtraExpensePageState createState() => _ExtraExpensePageState();
}

class _ExtraExpensePageState extends State<ExtraExpensePage> {
  List<bool> _isSelected = [true, false, false];
  int currentIndex = 0;

  Widget _buildContent() {
    switch (currentIndex) {
      case 0:
        return Center(child: Text('内容 1'));
      case 1:
        return Center(child: Text('内容 2'));
      case 2:
        return Center(child: TravelExpenses());
      default:
        return Center(child: Text('内容 1'));
    }
  }

  Future<void> _fetchData() async {
    var url = Uri.parse(API.GET_EXTRA_EXPENSE);
    var response = await http.get(url);

    if(response.statusCode==200){
      var data=json.decode(response.body)[]
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Extra Expense")),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: _isSelected,
              children: const <Widget>[
                Icon(
                  Icons.currency_yen,
                ),
                Icon(
                  Icons.directions_car,
                ),
                Icon(
                  Icons.train,
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < _isSelected.length;
                      buttonIndex++) {
                    _isSelected[buttonIndex] = buttonIndex == index;
                  }
                  currentIndex = index;
                });
              },
            ),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }
}
