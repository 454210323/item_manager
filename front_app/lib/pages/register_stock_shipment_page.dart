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
import '../widgets/drop_down.dart';
import '../widgets/dynamic_segment.dart';
import '../widgets/no_item_waring.dart';
import '../widgets/stock_data_table.dart';

class RegisterStockShipmentPage extends StatefulWidget {
  const RegisterStockShipmentPage({super.key});

  @override
  State<RegisterStockShipmentPage> createState() =>
      _RegisterStockShipmentPageState();
}

class _RegisterStockShipmentPageState extends State<RegisterStockShipmentPage> {
  final TextEditingController _itemCodeController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  final List<String> _modes = ["出货", "进货"];

  String _selectedMode = "出货";

  List<Stock> _preStocks = [];

  List<String> _recipients = [];

  String _selectedRecipient = "";

  void _onChanged(List<Stock> stocks) {
    setState(() {
      _preStocks = stocks;
    });
  }

  void _setSelectedMode(String mode) {
    _clear();
    setState(() {
      _selectedMode = mode;
    });
  }

  void _setSelectedRecipient(String recipient) {
    setState(() {
      _selectedRecipient = recipient;
    });
  }

  void _submitData() async {
    if (_preStocks.isEmpty) {
      showSnackBar(context, 'Please add List', 'error');
    }
    try {
      String postUrl = _selectedMode == "进货" ? API.STOCK : API.SHIPMENT;

      final response = await http.post(
        Uri.parse(postUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, dynamic>{
          'date': _selectedDate.toIso8601String(),
          'data': _preStocks.map((e) => e.toJson()).toList(),
          'recipient': _selectedRecipient
        }),
      );
      if (response.statusCode == 200) {
        showSnackBar(context, 'Registration successful', 'success');
        _clear();
      } else {
        showSnackBar(context, 'Registration failed', 'error');
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred: $e', 'error');
    }
  }

  Future<void> _fetchItem() async {
    var url = Uri.parse(API.ITEM).replace(queryParameters: {
      'itemCode': _itemCodeController.text,
    });
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (json.decode(response.body)['status']) {
          var data = json.decode(response.body)['item'];
          Item item = Item.fromJson(data);
          if (_preStocks.any((element) => element.itemCode == item.itemCode)) {
            _preStocks = _preStocks.map((e) {
              if (e.itemCode == item.itemCode) {
                return Stock(
                    itemCode: e.itemCode,
                    itemName: e.itemName,
                    image: "${API.ITEM_IMAGE}${e.itemCode}.jpg",
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
                image: "${API.ITEM_IMAGE}${item.itemCode}.jpg",
                price: item.price,
                quantity: 1));
          }
          setState(() {
            _preStocks = _preStocks;
          });
        } else {
          NoItemWaring.showNoItemWaring(context,
              itemCode: _itemCodeController.text);
        }
      }
    } catch (e) {
      showSnackBar(context, 'Error occurred: $e', 'error');
    }
  }

  Future<void> _fetchRecipients() async {
    try {
      var response = await http.get(Uri.parse(API.Recipients));
      if (response.statusCode == 200) {
        _recipients =
            List<String>.from(json.decode(response.body)["recipients"]);
      }
    } catch (e) {
      showSnackBar(context, 'Error occurred: $e', 'error');
    }
  }

  void _clear() {
    setState(() {
      _selectedDate = DateTime.now();
      _preStocks = [];
      _itemCodeController.clear();
    });
  }

  Widget _RecipientSelector() {
    return CustomDropdownButton(
      hint: "选择客户",
      options: _recipients,
      onSelected: _setSelectedRecipient,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchRecipients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("登录$_selectedMode"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DynamicSegment(
                options: _modes,
                onValueChanged: _setSelectedMode,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _itemCodeController,
                      decoration: const InputDecoration(labelText: "商品编码"),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[a-z]|[0-9]")),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: _fetchItem, child: const Text('检索')),
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
                    child: const Text('扫描'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _selectedMode == "出货" ? _RecipientSelector() : Container(),
                  Text(
                    '$_selectedMode日: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                  ),
                  ElevatedButton(
                    child: const Text('选择日期'),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2030),
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
              const SizedBox(width: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _submitData,
                    child: const Text('登录'),
                  ),
                  ElevatedButton(
                    onPressed: _clear,
                    child: const Text('清空'),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("商品种类"),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(_preStocks.length.toString()),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text("总数量"),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(_preStocks
                      .fold(0, (sum, element) => sum + element.quantity)
                      .toString()),
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
