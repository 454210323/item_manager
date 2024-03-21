import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';
import '../models/item.dart';
import '../widgets/barcode_scanner.dart';
import '../widgets/show_snack_bar.dart';

class UpdateItemPage extends StatefulWidget {
  final String itemCode;

  const UpdateItemPage({super.key, this.itemCode = ''});

  @override
  _UpdateItemPageState createState() => _UpdateItemPageState();
}

class _UpdateItemPageState extends State<UpdateItemPage> {
  final TextEditingController _itemCodeController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemTypeController = TextEditingController();
  final TextEditingController _seriesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _janCodeController = TextEditingController();

  bool _isLoading = false;
  bool _enable = true;

  String _imagePath = "";
  @override
  void initState() {
    super.initState();
    _itemCodeController.text = widget.itemCode;
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      var url = Uri.parse(API.ITEM)
          .replace(queryParameters: {'itemCode': widget.itemCode});
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['item'];
        var _item = Item.fromJson(data);
        _itemCodeController.text = _item.itemCode;
        _itemNameController.text = _item.itemName;
        _itemTypeController.text = _item.type;
        _seriesController.text = _item.series;
        _priceController.text = _item.price.toString();
        _janCodeController.text = _item.janCode;
        setState(() {
          _imagePath = _item.image;
        });
      } else {
        // Handle the error
      }
    } catch (e) {
      e.toString();
    }
  }

  Future<void> _submitData() async {
    if (_itemNameController.text.isEmpty || _priceController.text.isEmpty) {
      showSnackBar(context, 'Please fill required fields', 'error');
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
      final response = await http.put(
        Uri.parse(API.ITEM),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'itemCode': _itemCodeController.text,
          'itemName': _itemNameController.text,
          'itemType': _itemTypeController.text,
          'series': _seriesController.text,
          'price': Decimal.parse(_priceController.text),
          'janCode': _janCodeController.text
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _enable = false;
        });
        showSnackBar(context, 'update successful', 'success');
      } else {
        showSnackBar(context, 'update failed', 'error');
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
      appBar: AppBar(title: const Text('登录新商品')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                enabled: widget.itemCode.isEmpty,
                controller: _itemCodeController,
                decoration: const InputDecoration(labelText: '商品编号'),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-z]|[0-9]")),
                ],
              ),
              TextField(
                enabled: _enable,
                decoration: const InputDecoration(labelText: '商品名'),
                controller: _itemNameController,
              ),
              TextField(
                enabled: _enable,
                decoration: const InputDecoration(labelText: '类型'),
                controller: _itemTypeController,
              ),
              TextField(
                enabled: _enable,
                decoration: const InputDecoration(labelText: '系列'),
                controller: _seriesController,
              ),
              TextField(
                enabled: _enable,
                decoration: const InputDecoration(labelText: '价格'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                controller: _priceController,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: _enable,
                      controller: _janCodeController,
                      decoration: const InputDecoration(labelText: 'JanCode'),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[a-z]|[0-9]")),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String result = await BarcodeScanner.scanBarcode();
                      if (!mounted) return;
                      setState(() {
                        _janCodeController.text = result;
                      });
                    },
                    child: const Text('Scan'),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitData,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('更新'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _enable = true;
                              });
                            },
                      child: const Text('修改'),
                    ),
                  ),
                ],
              ),
              Center(
                // 使用Image.network来加载并显示网络图片
                child: Image.network(
                  _imagePath,
                  // 你可以根据需要设置宽度和高度
                  width: 200,
                  height: 200,
                  // 设置图片加载过程中的占位符
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  // 设置图片加载失败时的占位图
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Text('加载失败');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
