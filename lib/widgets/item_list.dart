import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/item_info.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<ItemInfo> _items = [];

  int _currentSortColumn = 0;
  bool _isSortAsc = true;

  void _sort<T>(Comparable<T> Function(ItemInfo item) getField, int columnIndex,
      bool ascending) {
    _items.sort((ItemInfo a, ItemInfo b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    setState(() {
      _currentSortColumn = columnIndex;
      _isSortAsc = ascending;
    });
  }

  DataTable _ItemTable() {
    return DataTable(
      columns: _ItemTableColumns(),
      rows: _ItemTableRows(),
      sortColumnIndex: _currentSortColumn,
      sortAscending: _isSortAsc,
    );
  }

  List<DataColumn> _ItemTableColumns() {
    return [
      DataColumn(
        label: Text('Item Code'),
        onSort: (columnIndex, ascending) =>
            _sort((item) => item.itemCode, columnIndex, ascending),
      ),
      DataColumn(
        label: Text('Item Name'),
        onSort: (columnIndex, ascending) =>
            _sort((item) => item.itemName, columnIndex, ascending),
      ),
      DataColumn(
        label: Text('Item Price'),
        onSort: (columnIndex, ascending) =>
            _sort<num>((item) => item.itemPrice, columnIndex, ascending),
      ),
    ];
  }

  List<DataRow> _ItemTableRows() {
    return _items
        .map((item) => DataRow(cells: [
              DataCell(Text(item.itemCode)),
              DataCell(Text(item.itemName)),
              DataCell(Text(item.itemPrice.toString()))
            ]))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = Uri.parse(API.ITEM_LIST);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['item_infos'];
      setState(() {
        _items = data.map<ItemInfo>((json) => ItemInfo.fromJson(json)).toList();
      });
    } else {
      // Handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: _ItemTable(),
            )),
      ),
    );
  }
}
