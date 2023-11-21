import 'package:flutter/material.dart';

import '../models/stock_info.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List<StockInfo> _results = [];

  void _onSearch(String query) async {
    // 实现检索逻辑，更新 _results
    // 比如调用HTTP请求等

    setState(() {
      // _results = fetchedResults;
      _results = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchFormWidget(onSearch: _onSearch),
        Expanded(
          child: SearchResultsWidget(results: _results),
        ),
      ],
    );
  }
}
