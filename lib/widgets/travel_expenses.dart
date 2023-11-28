import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/drop_down.dart';
import 'package:flutter_application_1/widgets/show_snack_bar.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class TravelExpenses extends StatefulWidget {
  const TravelExpenses({super.key});

  @override
  _TravelExpensesState createState() => _TravelExpensesState();
}

class _TravelExpensesState extends State<TravelExpenses> {
  final _formKey = GlobalKey<FormState>();
  String _fromStation = '';
  String _toStation = '';
  String _selectedType = '';
  int _expense = 0;

  void _setSelectedType(String value) {
    setState(() {
      _selectedType = value;
    });
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    try {
      final response = await http.post(
        Uri.parse(API.EXTRA_EXPENSE),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'expenseType': 'travel',
          'content': "$_fromStation-$_selectedType-$_toStation",
          'expense': _expense,
        }),
      );

      if (response.statusCode == 200) {
        showSnackBar(context, 'Registration successful');
      } else {
        showSnackBar(context, 'Registration failed');
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'From'),
                onSaved: (value) => _fromStation = value!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: CustomDropdownButton(
                  options: const ['one way', 'round'],
                  onSelected: _setSelectedType),
            ),
            Expanded(
              child: TextFormField(
                  decoration: const InputDecoration(labelText: 'To'),
                  onSaved: (value) => _toStation = value!),
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Expense'),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                onSaved: (value) => _expense = int.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an expense value';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: _submitForm, child: const Text("register")),
        )
      ]),
    );
  }
}
