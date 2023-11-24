import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../utils/barcode_scanner_util.dart';
import 'drop_down.dart';

class SearchForm extends StatefulWidget {
  final void Function(String, String, String) onSearch;

  const SearchForm({super.key, required this.onSearch});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  String _itemCode = '';
  String _selectedItemType = '';
  String _selectedItemSerise = '';
  List<String> _itemTypes = [];
  List<String> _itemSerises = [];

  void _onSearchPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSearch(_itemCode, _selectedItemType, _selectedItemSerise);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var typesResponse = await http.get(Uri.parse(API.ITEM_TYPES));
    var serisesResponse = await http.get(Uri.parse(API.ITEM_SERISES));
    if (typesResponse.statusCode == 200) {
      setState(() {
        _itemTypes =
            List<String>.from(json.decode(typesResponse.body)["item_types"]);
        _itemTypes.insert(0, '');
      });
    }
    if (serisesResponse.statusCode == 200) {
      setState(() {
        _itemSerises = List<String>.from(
            json.decode(serisesResponse.body)["item_serises"]);
        _itemSerises.insert(0, '');
      });
    }
  }

  void _setSelectedItemType(String value) {
    setState(() {
      _selectedItemType = value;
    });
  }

  void _setSelectedItemSerises(String value) {
    setState(() {
      _selectedItemSerise = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Item Code'),
                    onSaved: ((value) => _itemCode = value!)),
              ),
              ElevatedButton(
                onPressed: () async {
                  String barcodeResult = await BarcodeScannerUtil.scanBarcode();
                  setState(() {
                    _itemCode = barcodeResult;
                  });
                },
                child: const Text('Scan'),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Item Type"),
              CustomDropdownButton(
                options: _itemTypes,
                onSelected: _setSelectedItemType,
              ),
              const Text("Item Type"),
              CustomDropdownButton(
                options: _itemSerises,
                onSelected: _setSelectedItemSerises,
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: _onSearchPressed, child: const Text("search"))
            ],
          )
        ],
      ),
    );
  }
}
