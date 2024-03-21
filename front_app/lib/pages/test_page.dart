import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../widgets/barcode_scanner.dart';
import '../widgets/drop_down.dart';
import '../widgets/show_snack_bar.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController _janCodeController = TextEditingController();

  String _selectedItemCode = "";
  List<String> _itemCodes = [];

  void _setSelectedItemCode(String value) {
    setState(() {
      _selectedItemCode = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      var url = Uri.parse(API.ITEMS);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['items'];
        setState(() {
          _itemCodes =
              data.map<String>((json) => json["item_code"] as String).toList();
        });
      } else {
        // Handle the error
      }
    } catch (e) {
      e.toString();
    }
  }

  Future<void> _submitData() async {
    try {
      final response = await http.put(
        Uri.parse(API.Item_JANCODE),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'itemCode': _selectedItemCode,
          'janCode': _janCodeController.text
        }),
      );

      if (response.statusCode == 200) {
        showSnackBar(context, 'Update successful', 'success');
      } else {
        showSnackBar(context, 'Update failed', 'error');
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred: $e', 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Test Page")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(children: [
                CustomDropdownButton(
                    hint: "code",
                    options: _itemCodes,
                    onSelected: _setSelectedItemCode),
                Expanded(
                  child: TextField(
                    controller: _janCodeController,
                    decoration: const InputDecoration(labelText: 'Jan Code'),
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
                      _janCodeController.text = result;
                    });
                  },
                  child: const Text('Scan'),
                )
              ]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('update'),
                ),
              ),
            ],
          ),
        ));
  }
}
