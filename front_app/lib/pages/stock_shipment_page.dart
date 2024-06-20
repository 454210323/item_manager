import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/search_form.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/stock_shipment.dart';
import '../widgets/dynamic_data_table.dart';

class StockShipmentPage extends StatefulWidget {
  const StockShipmentPage({super.key});

  @override
  _StockShipmentPageState createState() => _StockShipmentPageState();
}

class _StockShipmentPageState extends State<StockShipmentPage> {
  List<StockShipment> _StockShipments = [];
  DateTime _startDay = DateTime.now();
  DateTime _endDay = DateTime.now();

  Future<void> _onSearch(String itemCode, String itemName, String itemType,
      String itemSerise) async {
    var url = Uri.parse(API.STOCK_SHIPMENT_INFOS).replace(queryParameters: {
      'itemCode': itemCode,
      'itemName': itemName,
      'itemType': itemType,
      'itemSeries': itemSerise,
      'startDay': _startDay.toIso8601String(),
      'endDay': _endDay.toIso8601String()
    });

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['stock_shipment_infos'];

      setState(() {
        _StockShipments = data
            .map<StockShipment>((json) => StockShipment.fromJson(json))
            .toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stock and Shipment")),
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
              onSearch: _onSearch,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: _StockShipments.isEmpty
                    ? const Text("no data")
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DynamicDataTable(
                          data: _StockShipments,
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
