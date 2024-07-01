import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/favorite_item.dart';
import 'package:http/http.dart' as http;

import '../widgets/dynamic_data_table.dart';
import '../widgets/show_snack_bar.dart';

class StockMonitoringPage extends StatefulWidget {
  const StockMonitoringPage({super.key});

  @override
  State<StockMonitoringPage> createState() => _StockMonitoringPageState();
}

class _StockMonitoringPageState extends State<StockMonitoringPage> {
  final TextEditingController _itemCodeController = TextEditingController();
  List<FavoriteItem> _favoriteItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStock();
  }

  Future<void> _addFavoriteItem() async {
    try {
      _isLoading = true;
      final response = await http.post(
        Uri.parse(API.FAVORITE_ITEM),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, dynamic>{
          'itemCode': _itemCodeController.text,
        }),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        FavoriteItem favoriteItem = FavoriteItem.fromJson(data);
        setState(() {
          _favoriteItems.add(favoriteItem);
        });
        _itemCodeController.clear();
        showSnackBar(context, '添加成功', 'success');
      } else {
        showSnackBar(context, '添加失败', 'error');
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred: $e', 'error');
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _fetchStock() async {
    try {
      _isLoading = true;
      final response = await http.get(Uri.parse(API.STOCK_MONITORING));
      if (response.statusCode == 200) {
        List data = json.decode(response.body)["items"];
        setState(() {
          _favoriteItems = data
              .map<FavoriteItem>((json) => FavoriteItem.fromJson(json))
              .toList();
        });
        showSnackBar(context, '获取成功', 'success');
      } else {
        showSnackBar(context, '获取失败', 'error');
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred: $e', 'error');
    } finally {
      _isLoading = false;
    }
  }

  List<String> getVisiableColumns(double screenWidth) {
    if (screenWidth < 800) {
      return FavoriteItem.columnsForSmallScreen;
    } else if (screenWidth < 1600) {
      return FavoriteItem.columnsForMediumScreen;
    } else {
      return FavoriteItem.columnsForLargeScreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ScreenConst.STOCK_MONITORING),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    decoration: const InputDecoration(labelText: '商品编码'),
                    controller: _itemCodeController,
                  )),
                  ElevatedButton(
                      onPressed: _addFavoriteItem, child: const Text("add")),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _fetchStock, child: const Text("刷新")),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DynamicDataTable(
                              data: _favoriteItems,
                              visibleColumns: getVisiableColumns(
                                  MediaQuery.of(context).size.width),
                              imageColumnIndex: 0),
                        ),
                ),
              ),
            ],
          )),
    );
  }
}
