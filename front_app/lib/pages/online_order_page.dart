import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/drop_down.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/online_order.dart';
import '../widgets/dynamic_data_table.dart';
import '../widgets/page_button.dart';
import '../widgets/responsive_sized_box.dart';
import '../widgets/show_snack_bar.dart';

class OnlineOrderPage extends StatefulWidget {
  const OnlineOrderPage({super.key});

  @override
  State<OnlineOrderPage> createState() => _OnlineOrderPageState();
}

class _OnlineOrderPageState extends State<OnlineOrderPage> {
  final TextEditingController _itemNameController = TextEditingController();
  String _selectedOrderStatus = "";

  List<OnlineOrder> _orders = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _pageSize = 20;
  int _totalPage = 10;

  DateTime _startDay = DateTime(2023);
  DateTime _endDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchEarliestUnshippedOrderDate();
  }

  void _setSelectedOrderStatus(String value) {
    setState(() {
      _selectedOrderStatus = value;
    });
  }

  Future<void> _fetchEarliestUnshippedOrderDate() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var url = Uri.parse(API.EARLIEST_UNSHIPPED_ORDER_DATE);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        String earliestDate = jsonData['earliest_date'];
        if (earliestDate.isNotEmpty) {
          setState(() {
            _startDay = DateTime.parse(earliestDate);
          });
        }
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var url = Uri.parse(API.ONLINE_ORDER).replace(queryParameters: {
        'itemName': _itemNameController.text,
        'orderStatus': _selectedOrderStatus,
        'startDay': _startDay.toIso8601String(),
        'endDay': _endDay.toIso8601String(),
        'page': _currentPage.toString(),
        'pageSize': _pageSize.toString()
      });
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var orderData = jsonData['online_orders'];
        var totalCount = jsonData['total_count'];

        setState(() {
          _orders = orderData
              .map<OnlineOrder>((json) => OnlineOrder.fromJson(json))
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

  List<String> getVisiableColumns(double screenWidth) {
    if (screenWidth < 800) {
      return OnlineOrder.columnsForSmallScreen;
    } else if (screenWidth < 1600) {
      return OnlineOrder.columnsForMediumScreen;
    } else {
      return OnlineOrder.columnsForLargeScreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("官网订单"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ResponsiveSizedBox(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Item Name'),
                    controller: _itemNameController,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomDropdownButton(
                    hint: "订单状态",
                    options: const ["全部", "未発送", "出荷済み"],
                    onSelected: _setSelectedOrderStatus),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: _fetchData, child: const Text("Search")),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _orders.isNotEmpty
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
                          data: _orders,
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
