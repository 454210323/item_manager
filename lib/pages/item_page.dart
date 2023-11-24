import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/dynamic_data_table.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/item_info.dart';
import '../widgets/register_new_item_button.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const RegisterNewItemButton(),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _items.isEmpty
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DynamicDataTable(data: _items),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
