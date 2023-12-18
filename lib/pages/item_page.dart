import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/dynamic_data_table.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/item.dart';
import 'register_item_page.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  List<Item> _items = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var url = Uri.parse(API.ITEM);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['items'];
        setState(() {
          _items = data.map<Item>((json) => Item.fromJson(json)).toList();
        });
      } else {
        // Handle the error
      }
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> getVisiableColumns(double screenWidth) {
    if (screenWidth < 800) {
      return Item.columnsForSmallScreen;
    } else if (screenWidth < 1600) {
      return Item.columnsForMediumScreen;
    } else {
      return Item.columnsForLargeScreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const RegisterItemPage()),
                    );
                  },
                  child: const Text('Register New Item'),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DynamicDataTable(
                            data: _items,
                            visibleColumns: getVisiableColumns(
                                MediaQuery.of(context).size.width),
                          ),
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
