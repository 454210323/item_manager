import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/stock.dart';

class StockDataTable extends StatefulWidget {
  final List<Stock> data;
  final void Function(List<Stock>) onChanged;
  final int imageColumnIndex;

  const StockDataTable(
      {super.key,
      required this.data,
      required this.onChanged,
      this.imageColumnIndex = 0});

  @override
  State<StockDataTable> createState() => _StockDataTableState();
}

class _StockDataTableState extends State<StockDataTable> {
  List<DataColumn> _itemTableColumns() {
    if (widget.data.isEmpty) {
      return [];
    }
    var keys = widget.data[0].toTableData().keys.toList();
    return List.generate(keys.length, (index) {
      String columnName = keys[index];

      return DataColumn(
        label: Text(columnName),
      );
    });
  }

  List<DataRow> _itemTableRows() {
    return widget.data.map((item) {
      var data = item.toTableData();
      var cells = data.entries.map((entry) {
        var key = entry.key;
        var value = entry.value;
        if ('price' == key || 'quantity' == key) {
          var controller = TextEditingController(text: value.toString());
          return DataCell(TextField(
            controller: controller,
            decoration: InputDecoration(
              errorText:
                  controller.text.isEmpty ? "Field cannot be empty" : null,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (newValue) {
              if ('price' == key) {
                item.price = Decimal.tryParse(newValue)!;
              }
              if ('quantity' == key) {
                item.quantity = int.tryParse(newValue)!;
              }
              widget.onChanged(widget.data);
            },
          ));
        } else if ('image' == key) {
          return DataCell(Container(
            alignment: Alignment.centerLeft,
            child: Image.network(
              value,
              width: 40,
              height: 40,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  alignment: Alignment.centerLeft,
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              // 设置图片加载失败时的占位图
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const Text('加载失败');
              },
            ),
          ));
        } else {
          return DataCell(Text(value.toString()));
        }
      }).toList();
      return DataRow(cells: cells);
    }).toList();
  }

  DataTable _itemTable() {
    return DataTable(
      columnSpacing: 30,
      columns: _itemTableColumns(),
      rows: _itemTableRows(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.data.isEmpty
        ? const Text('no item')
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            child: _itemTable(),
          );
  }
}
