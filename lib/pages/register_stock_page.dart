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
import '../widgets/stock_data_table.dart';

class RegisterStockPage extends StatefulWidget {
  const RegisterStockPage({super.key});

  @override
  State<RegisterStockPage> createState() => _RegisterStockPageState();
}

class _RegisterStockPageState extends State<RegisterStockPage> {
  TextEditingController _itemCodeController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  List<Stock> _preStocks = [];

  void _onChanged(List<Stock> stocks) {
    setState(() {
      _preStocks = stocks;
    });
  }

  void _submitData() async {
    if (_preStocks.isEmpty) {
      showSnackBar(context, 'Please add List');
    }
    final response = await http.post(
      Uri.parse(API.STOCK),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(<String, dynamic>{
        'purchaseDate': _selectedDate.toIso8601String(),
        'stocks': _preStocks.map((e) => e.toString()).toList(),
      }),
    );
  }

  Future<void> _fetchItem() async {
    var url = Uri.parse(API.ITEM).replace(queryParameters: {
      'itemCode': _itemCodeController.text,
    });
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['item'];
        Item item = Item.fromJson(data);
        if (_preStocks.any((element) => element.itemCode == item.itemCode)) {
          _preStocks = _preStocks.map((e) {
            if (e.itemCode == item.itemCode) {
              return Stock(
                  itemCode: e.itemCode,
                  itemName: e.itemName,
                  price: e.price,
                  quantity: e.quantity + 1);
            } else {
              return e;
            }
          }).toList();
        } else {
          _preStocks.add(Stock(
              itemCode: item.itemCode,
              itemName: item.itemName,
              price: item.price,
              quantity: 1));
        }
        setState(() {
          _preStocks = _preStocks;
        });
      } else {
        showSnackBar(context, 'Cant find any item');
      }
    } catch (e) {
      showSnackBar(context, 'Error occurred: $e');
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
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      String result = await BarcodeScanner.scanBarcode();
                      if (!mounted) return;
                      setState(() {
                        _itemCodeController.text = result;
                      });
                      _fetchItem();
                    },
                    child: const Text('Scan'),
                  )
                ],
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
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _submitData,
                    child: const Text('Register'),
                  ),
                ],
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: _preStocks.isEmpty
                    ? Text('no item')
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: StockDataTable(
                          data: _preStocks,
                          onChanged: _onChanged,
                        ),
                      ),
              ))
            ],
          ),
        ));
  }
}
