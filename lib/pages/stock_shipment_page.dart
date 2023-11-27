import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/search_form.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/stock_info.dart';
import '../widgets/dynamic_data_table.dart';

class StockShipmentPage extends StatefulWidget {
  const StockShipmentPage({super.key});

  @override
  _StockShipmentPageState createState() => _StockShipmentPageState();
}

class _StockShipmentPageState extends State<StockShipmentPage> {
  List<StockShipmentInfo> _stockShipmentInfos = [];

  Future<void> _onSearch(
      String itemCode, String itemType, String itemSerise) async {
    var url = Uri.parse(API.STOCK_SHIPMENT_INFOS).replace(queryParameters: {
      'itemCode': itemCode,
      'itemType': itemType,
      'itemSerise': itemSerise,
    });

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['stock_shipment_infos'];

      setState(() {
        _stockShipmentInfos = data
            .map<StockShipmentInfo>((json) => StockShipmentInfo.fromJson(json))
            .toList();
      });
    }
  }

  List<String> getVisiableColumns(double screenWidth) {
    if (screenWidth < 800) {
      return StockShipmentInfo.columnsForSmallScreen;
    } else if (screenWidth < 1600) {
      return StockShipmentInfo.columnsForMediumScreen;
    } else {
      return StockShipmentInfo.columnsForLargeScreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          SearchForm(
            onSearch: _onSearch,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _stockShipmentInfos.isEmpty
                  ? const Text("no data")
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DynamicDataTable(
                        data: _stockShipmentInfos,
                        visibleColumns: getVisiableColumns(
                            MediaQuery.of(context).size.width),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
