import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/dynamic_data_table.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/item.dart';
import '../widgets/drop_down.dart';
import 'register_item_page.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  List<Item> _items = [];
  bool _isLoading = false;

  String _selectedSeries = "";
  List<String> _itemSeries = [];

  void _setSelectedSeries(String value) {
    setState(() {
      _selectedSeries = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData(_selectedSeries);
    _fetchSeries();
  }

  Future<void> _fetchSeries() async {
    var seriesResponse = await http.get(Uri.parse(API.ITEM_SERIES));
    if (seriesResponse.statusCode == 200) {
      setState(() {
        _itemSeries =
            List<String>.from(json.decode(seriesResponse.body)["series"]);
        _itemSeries.insert(0, '');
      });
    }
  }

  Future<void> _fetchData(String _selectedSeries) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var url = Uri.parse(API.ITEM_CONDITIONS).replace(queryParameters: {
        'itemSeries': _selectedSeries,
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

  List<Item> shortenJanCode(List<Item> items) {
    return items.map<Item>((item) {
      if (item.janCode.length <= 4) {
        return item;
      } else {
        item = Item(
            itemCode: item.itemCode,
            itemName: item.itemName,
            type: item.type,
            series: item.series,
            price: item.price,
            janCode: item.janCode.substring(item.janCode.length - 4),
            imagePath: item.imagePath);
        return item;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("商品一览"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  const Text("系列"),
                  CustomDropdownButton(
                      hint: "",
                      options: _itemSeries,
                      onSelected: _setSelectedSeries),
                ],
              ),
              Row(
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
                      child: const Text('登录新商品'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _fetchData(_selectedSeries);
                      },
                      child: const Text('刷新'),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DynamicDataTable(
                            data: shortenJanCode(_items),
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
      ),
    );
  }
}
