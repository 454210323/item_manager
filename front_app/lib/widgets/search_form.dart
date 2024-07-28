import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/search_condition.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'barcode_scanner.dart';
import 'drop_down.dart';
import 'responsive_sized_box.dart';

class SearchForm extends StatefulWidget {
  final void Function(SearchCondition) onSearchConditionChange;

  const SearchForm({super.key, required this.onSearchConditionChange});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final TextEditingController _itemCodeController = TextEditingController();
  List<String> _itemTypes = [];
  List<String> _itemSeries = [];
  SearchCondition _searchCondition =
      SearchCondition(itemCode: '', itemName: '', type: '', series: '');

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResponsiveSizedBox(
                child: TextField(
              decoration: const InputDecoration(labelText: '商品编号'),
              controller: _itemCodeController,
              onChanged: (value) {
                setState(() {
                  _searchCondition.itemCode = value;
                });
                widget.onSearchConditionChange(_searchCondition);
              },
            )),
            ElevatedButton(
              onPressed: () async {
                String barcodeResult = await BarcodeScanner.scanBarcode();
                if (!mounted) return;
                setState(() {
                  _itemCodeController.text = barcodeResult;
                  _searchCondition.itemCode = barcodeResult;
                });
                widget.onSearchConditionChange(_searchCondition);
              },
              child: const Text('Scan'),
            ),
            const SizedBox(
              width: 10,
            ),
            ResponsiveSizedBox(
                child: TextField(
              decoration: const InputDecoration(labelText: '商品名'),
              onChanged: (value) {
                setState(() {
                  _searchCondition.itemName = value;
                });
                widget.onSearchConditionChange(_searchCondition);
              },
            )),
            const SizedBox(
              width: 10,
            ),
            CustomDropdownButton(
              hint: "类型",
              options: _itemTypes,
              onSelected: (value) {
                setState(() {
                  _searchCondition.type = value;
                });
                widget.onSearchConditionChange(_searchCondition);
              },
            ),
            const SizedBox(
              width: 10,
            ),
            CustomDropdownButton(
              hint: "系列",
              options: _itemSeries,
              onSelected: (value) {
                setState(() {
                  _searchCondition.series = value;
                });
                widget.onSearchConditionChange(_searchCondition);
              },
            ),
          ],
        ),
      ],
    );
  }
}
