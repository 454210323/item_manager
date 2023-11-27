import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'barcode_scanner.dart';
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
  String _selectedItemSeries = '';
  List<String> _itemTypes = [];
  List<String> _itemSeries = [];

  void _onSearchPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSearch(_itemCode, _selectedItemType, _selectedItemSeries);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var typesResponse = await http.get(Uri.parse(API.ITEM_TYPES));
    var seriesResponse = await http.get(Uri.parse(API.ITEM_SERIES));
    if (typesResponse.statusCode == 200) {
      setState(() {
        _itemTypes =
            List<String>.from(json.decode(typesResponse.body)["item_types"]);
        _itemTypes.insert(0, '');
      });
    }
    if (seriesResponse.statusCode == 200) {
      setState(() {
        _itemSeries =
            List<String>.from(json.decode(seriesResponse.body)["series"]);
        _itemSeries.insert(0, '');
      });
    }
  }

  void _setSelectedItemType(String value) {
    setState(() {
      _selectedItemType = value;
    });
  }

  void _setSelectedItemSeries(String value) {
    setState(() {
      _selectedItemSeries = value;
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
                  String barcodeResult = await BarcodeScanner.scanBarcode();
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
              const Text("Item Series"),
              CustomDropdownButton(
                options: _itemSeries,
                onSelected: _setSelectedItemSeries,
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
