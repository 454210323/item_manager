import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/item.dart';
import 'package:flutter_application_1/widgets/show_snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/stock.dart';
import '../widgets/barcode_scanner.dart';

class RegisterStockPage extends StatefulWidget {
  const RegisterStockPage({super.key});

  @override
  State<RegisterStockPage> createState() => _RegisterStockPageState();
}

class _RegisterStockPageState extends State<RegisterStockPage> {
  TextEditingController _itemCodeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  List<Stock> _preStocks = [];

  void _setData(List<Stock> stocks) {
    setState(() {
      _preStocks = stocks;
    });
  }

  void _submitData() async {}

  Future<void> _fetchItem() async {
    var url = Uri.parse(API.ITEM).replace(queryParameters: {
      'itemCode': _itemCodeController.text,
    });
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Item item = json.decode(response.body)['item'];
        if (_preStocks.any((element) => element.itemCode == item.itemCode)) {
          setState(() {
            _preStocks = _preStocks.map((e) {
              if (e.itemCode == item.itemCode) {
                return Stock(
                    itemCode: e.itemCode,
                    price: e.price,
                    quantity: e.quantity + 1,
                    purchaseDate: _selectedDate);
              } else {
                return e;
              }
            }).toList();
          });
        } else {
          setState(() {
            _preStocks.add(Stock(
                itemCode: item.itemCode,
                price: item.price,
                quantity: 1,
                purchaseDate: _selectedDate));
          });
        }
      } else {
        showSnackBar(context, 'Cant find any item');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register Stock"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _itemCodeController,
                      decoration: const InputDecoration(labelText: "Item Code"),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[a-z]|[0-9]")),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: _fetchItem, child: const Text('Search')),
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
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Purchase Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
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
        ));
  }
}
