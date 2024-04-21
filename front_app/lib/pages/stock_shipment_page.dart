import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/search_form.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/stock_shipment.dart';
import '../widgets/drop_down.dart';
import '../widgets/dynamic_data_table.dart';

class StockShipmentPage extends StatefulWidget {
  const StockShipmentPage({super.key});

  @override
  _StockShipmentPageState createState() => _StockShipmentPageState();
}

class _StockShipmentPageState extends State<StockShipmentPage> {
  List<StockShipment> _StockShipments = [];
  String _shipmentDate = '';
  List<String> _shipmentDates = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var shipmentDateResponse = await http.get(Uri.parse(API.SHIPMENT_DATE));
    if (shipmentDateResponse.statusCode == 200) {
      setState(() {
        _shipmentDates = List<String>.from(
            json.decode(shipmentDateResponse.body)['shipment_dates']);
      });
    }
  }

  Future<void> _onSearch(String itemCode, String itemName, String itemType,
      String itemSerise) async {
    var url = Uri.parse(API.STOCK_SHIPMENT_INFOS).replace(queryParameters: {
      'itemCode': itemCode,
      'itemName': itemName,
      'itemType': itemType,
      'itemSeries': itemSerise,
      'shipmentDate': _shipmentDate
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
            const Text("出货日期/批次"),
            CustomDropdownButton(
                hint: "Date",
                options: _shipmentDates,
                onSelected: (value) {
                  setState(() {
                    _shipmentDate = value;
                  });
                }),
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
