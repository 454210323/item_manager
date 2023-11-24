import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/item_info.dart';
import '../utils/dynamic_data_table.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<ItemInfo> _items = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = Uri.parse(API.ITEM_INFOS);
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
        child: _items.isEmpty
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: DynamicDataTable(
                    data: _items,
                  ),
                ),
              ),
      ),
    );
  }
}
