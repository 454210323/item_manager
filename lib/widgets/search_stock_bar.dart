import 'package:flutter/material.dart';

import '../utils/barcode_scanner_util.dart';

class SearchStockBar extends StatefulWidget {
  const SearchStockBar({super.key});

  @override
  State<SearchStockBar> createState() => _SearchStockBarState();
}

class _SearchStockBarState extends State<SearchStockBar> {
  final _formKey = GlobalKey<FormState>();
  String _itemCode = '';
  String _itemType = '';
  String _itemSerise = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
                decoration: const InputDecoration(labelText: 'Item Code'),
                onSaved: ((value) => _itemCode = value!)),
          ),
          ElevatedButton(
            onPressed: () async {
              _itemCode = await BarcodeScannerUtil.scanBarcode();
            },
            child: const Text('Scan'),
          ),
          Expanded(
            child: TextFormField(
                decoration: const InputDecoration(labelText: 'Item Type'),
                onSaved: ((value) => _itemType = value!)),
          ),
          Expanded(
            child: TextFormField(
                decoration: const InputDecoration(labelText: 'Item Serise'),
                onSaved: ((value) => _itemSerise = value!)),
          ),
          ElevatedButton(onPressed: () {}, child: const Text("search"))
        ],
      ),
    );
  }
}
