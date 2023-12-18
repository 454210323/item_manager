import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';
import '../widgets/barcode_scanner.dart';
import '../widgets/show_snack_bar.dart';

class RegisterItemPage extends StatefulWidget {
  const RegisterItemPage({super.key});

  @override
  _RegisterItemPageState createState() => _RegisterItemPageState();
}

class _RegisterItemPageState extends State<RegisterItemPage> {
  final TextEditingController _itemCodeController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitData() async {
    if (_itemNameController.text.isEmpty || _priceController.text.isEmpty) {
      showSnackBar(context, 'Please fill in all fields', 'error');
      return;
    }
    if (Decimal.tryParse(_priceController.text) == null) {
      showSnackBar(context, 'Please enter a valid price', 'error');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse(API.REGISTER_ITEM),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'itemCode': _itemCodeController.text,
          'itemName': _itemNameController.text,
          'price': Decimal.parse(_priceController.text),
        }),
      );

      if (response.statusCode == 200) {
        showSnackBar(context, 'Registration successful', 'success');
      } else {
        showSnackBar(context, 'Registration failed', 'error');
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred: $e', 'error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register New Item')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemCodeController,
                    decoration: const InputDecoration(labelText: 'Item Code'),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-z]|[0-9]")),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String result = await BarcodeScanner.scanBarcode();
                    if (!mounted) return;
                    setState(() {
                      _itemCodeController.text = result;
                    });
                  },
                  child: const Text('Scan'),
                )
              ],
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Item Name'),
              controller: _itemNameController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Item Price'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              controller: _priceController,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitData,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
