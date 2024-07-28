import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/dynamic_data_table.dart';
import 'package:flutter_application_1/widgets/search_form.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/item.dart';
import '../models/search_condition.dart';
import '../widgets/page_button.dart';
import '../widgets/show_snack_bar.dart';
import 'register_item_page.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  List<Item> _items = [];
  SearchCondition _searchCondition =
      SearchCondition(itemCode: '', itemName: '', type: '', series: '');

  bool _isLoading = false;
  int _currentPage = 1;
  int _pageSize = 20;
  int _totalPage = 10;

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var url = Uri.parse(API.ITEM_CONDITIONS).replace(queryParameters: {
        'itemCode': _searchCondition.itemCode,
        'itemName': _searchCondition.itemName,
        'itemType': _searchCondition.type,
        'itemSeries': _searchCondition.series,
        'page': _currentPage.toString(),
        'pageSize': _pageSize.toString()
      });
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var data = jsonData['items'];
        var totalCount = jsonData['total_count'];

        setState(() {
          _items = data.map<Item>((json) => Item.fromJson(json)).toList();
          _totalPage = (totalCount / _pageSize).ceil();
        });
        showSnackBar(context, '取得成功', 'success');
      } else {
        showSnackBar(context, '取得失败', 'error');
      }
    } catch (e) {
      showSnackBar(context, 'An error occurred: $e', 'error');
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

  void _onCurrentPageChange(int currentPage) {
    setState(() {
      _currentPage = currentPage;
    });
    _fetchData();
  }

  void _onPageSizeChange(int pageSize) {
    setState(() {
      _pageSize = pageSize;
    });
    _fetchData();
  }

  void _onSearchConditionChange(SearchCondition searchCondition) {
    setState(() {
      _searchCondition = searchCondition;
    });
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
              onSearchConditionChange: _onSearchConditionChange,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: _fetchData, child: const Text("Search")),
            const SizedBox(
              height: 10,
            ),
            _items.isNotEmpty
                ? PageButton(
                    totalPages: _totalPage,
                    onCurrentPageChange: _onCurrentPageChange,
                    onPageSizeChange: _onPageSizeChange,
                  )
                : Container(),
            const SizedBox(
              height: 10,
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
