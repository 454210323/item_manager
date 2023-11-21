import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';
import '../utils/barcode_scanner_util.dart';
import '../utils/show_snack_bar.dart';

class RegisterItemForm extends StatefulWidget {
  const RegisterItemForm({super.key});

  @override
  _RegisterItemFormState createState() => _RegisterItemFormState();
}

class _RegisterItemFormState extends State<RegisterItemForm> {
  final _formKey = GlobalKey<FormState>();
  String _itemCode = '';
  String _itemName = '';
  int _itemPrice = 0;
  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final response = await http.post(
      Uri.parse(API.REGISTER_ITEM),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'itemCode': _itemCode,
        'itemName': _itemName,
        'itemPrice': _itemPrice,
      }),
    );

    if (response.statusCode == 200) {
      showSnackBar(context, 'Registration successful');
    } else {
      showSnackBar(context, 'Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Item'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Item Code'),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-z]|[0-9]")),
                    ],
                    onSaved: (value) {
                      _itemCode = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a item code';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    _itemCode = await BarcodeScannerUtil.scanBarcode();
                  },
                  child: const Text('Scan'),
                )
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Item Name'),
              onSaved: (value) {
                _itemName = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter item name';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Item Price'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onSaved: (value) {
                _itemPrice = int.parse(value!);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter item price';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
