import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/dynamic_data_table.dart';
import 'package:flutter_application_1/widgets/search_form.dart';
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

  Future<void> _fetchData(String itemCode, String itemName, String itemType,
      String itemSerise) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var url = Uri.parse(API.ITEM_CONDITIONS).replace(queryParameters: {
        'itemCode': itemCode,
        'itemName': itemName,
        'itemType': itemType,
        'itemSeries': itemSerise,
      });
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
      e.toString();
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
        title: const Text("商品一览"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const RegisterItemPage()),
                );
              },
              child: const Text('登录新商品'),
            ),
            SearchForm(
              onSearch: _fetchData,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DynamicDataTable(
                          data: _items,
                          visibleColumns: getVisiableColumns(
                              MediaQuery.of(context).size.width),
                          imageColumnIndex: getVisiableColumns(
                                      MediaQuery.of(context).size.width)
                                  .length -
                              1,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
