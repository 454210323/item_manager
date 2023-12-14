import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/widgets/drop_down.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../widgets/show_snack_bar.dart';

class RegisterExtraExpensePage extends StatefulWidget {
  const RegisterExtraExpensePage({super.key});

  @override
  State<RegisterExtraExpensePage> createState() =>
      _RegisterExtraExpensePageState();
}

class _RegisterExtraExpensePageState extends State<RegisterExtraExpensePage> {
  String _selectedType = "";
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  List<String> _types = [];

  @override
  void initState() {
    super.initState();
    _fetchTypes();
  }

  Future<void> _fetchTypes() async {
    final response = await http.get(Uri.parse(API.EXTRA_EXPENSE_TYPES));
    if (response.statusCode == 200) {
      var data = json
          .decode(response.body)["extra_expense_types"]
          .map((json) => json["extra_expense_type"]);
      setState(() {
        _types = List.from(data);
      });
    }
  }

  Future<void> _submitData() async {
    if (_expenseController.text.isEmpty || _contentController.text.isEmpty) {
      showSnackBar(context, 'Please fill in all fields');
    }
    if (Decimal.tryParse(_expenseController.text) == null) {
      showSnackBar(context, 'Please enter a valid price');
      return;
    }

    final response = await http.post(
      Uri.parse(API.EXTRA_EXPENSE),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(<String, dynamic>{
        'expenseType': _selectedType,
        'expense': _expenseController.text,
        'content': _contentController.text,
        'expenseDate': _selectedDate.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      showSnackBar(context, 'Registration successful');
    } else {
      showSnackBar(context, 'Registration failed');
    }
  }

  void _setSelectedType(String value) {
    setState(() {
      _selectedType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Extra Expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            CustomDropdownButton(
                hint: "Type", options: _types, onSelected: _setSelectedType),
            TextField(
              controller: _expenseController,
              decoration: const InputDecoration(
                labelText: 'Expense',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Expense Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                ),
                ElevatedButton(
                  child: const Text('Select Date'),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2025),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
