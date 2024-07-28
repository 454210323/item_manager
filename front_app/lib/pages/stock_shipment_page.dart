import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/search_condition.dart';
import 'package:flutter_application_1/widgets/search_form.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/stock_shipment.dart';
import '../widgets/dynamic_data_table.dart';
import '../widgets/page_button.dart';
import '../widgets/show_snack_bar.dart';

class StockShipmentPage extends StatefulWidget {
  const StockShipmentPage({super.key});

  @override
  _StockShipmentPageState createState() => _StockShipmentPageState();
}

class _StockShipmentPageState extends State<StockShipmentPage> {
  List<StockShipment> _stockShipments = [];
  DateTime _startDay = DateTime(2023);
  DateTime _endDay = DateTime.now();
  SearchCondition _searchCondition =
      SearchCondition(itemCode: '', itemName: '', type: '', series: '');

  bool _isLoading = false;
  int _currentPage = 1;
  int _pageSize = 20;
  int _totalPage = 10;

  Future<void> _onSearch() async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse(API.STOCK_SHIPMENT_INFOS_V2).replace(queryParameters: {
      'itemCode': _searchCondition.itemCode,
      'itemName': _searchCondition.itemName,
      'itemType': _searchCondition.type,
      'itemSeries': _searchCondition.series,
      'startDay': _startDay.toIso8601String(),
      'endDay': _endDay.toIso8601String(),
      'page': _currentPage.toString(),
      'pageSize': _pageSize.toString()
    });

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var data = jsonData['stock_shipment_infos'];
        var totalCount = jsonData['total_count'];

        setState(() {
          _stockShipments = data
              .map<StockShipment>((json) => StockShipment.fromJson(json))
              .toList();
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
      return StockShipment.columnsForSmallScreen;
    } else if (screenWidth < 1600) {
      return StockShipment.columnsForMediumScreen;
    } else {
      return StockShipment.columnsForLargeScreen;
    }
  }

  void _onCurrentPageChange(int currentPage) {
    setState(() {
      _currentPage = currentPage;
    });
    _onSearch();
  }

  void _onPageSizeChange(int pageSize) {
    setState(() {
      _pageSize = pageSize;
    });
    _onSearch();
  }

  void _onSearchConditionChange(SearchCondition searchCondition) {
    setState(() {
      _searchCondition = searchCondition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(ScreenConst.STOCK_SHIPMENT)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const Text("选择出货期间"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text(DateFormat('yyyy-MM-dd').format(_startDay)),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null && picked != _startDay) {
                      setState(() {
                        _startDay = picked;
                      });
                    }
                  },
                ),
                const Icon(Icons.arrow_right_outlined),
                ElevatedButton(
                  child: Text(DateFormat('yyyy-MM-dd').format(_endDay)),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null && picked != _endDay) {
                      setState(() {
                        _endDay = picked;
                      });
                    }
                  },
                ),
              ],
            ),
            SearchForm(
              onSearchConditionChange: _onSearchConditionChange,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: _onSearch, child: const Text("Search")),
            const SizedBox(
              height: 10,
            ),
            _stockShipments.isNotEmpty
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
                          data: _stockShipments,
                          visibleColumns: getVisiableColumns(
                              MediaQuery.of(context).size.width),
                          imageColumnIndex: 0,
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
