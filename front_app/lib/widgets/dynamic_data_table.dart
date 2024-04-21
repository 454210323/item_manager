import 'package:flutter/material.dart';

import '../models/table_item.dart';
import '../pages/update_item_page.dart';

class DynamicDataTable extends StatefulWidget {
  final List<TableItem> data;
  final int interactiveColumnIndex;
  final List<String> visibleColumns;
  final int imageColumnIndex;

  const DynamicDataTable(
      {super.key,
      required this.data,
      this.visibleColumns = const [],
      this.interactiveColumnIndex = -1,
      this.imageColumnIndex = -1});

  @override
  State<DynamicDataTable> createState() => _DynamicDataTableState();
}

class _DynamicDataTableState extends State<DynamicDataTable> {
  int _currentSortColumn = 0;

  bool _isSortAsc = true;

  void _sort<T>(Comparable<T> Function(TableItem item) getField) {
    widget.data.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return _isSortAsc
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
  }

  List<DataColumn> _itemTableColumns() {
    if (widget.data.isEmpty) {
      return [];
    }
    var keys = widget.data[0]
        .toTableData()
        .keys
        .where((key) =>
            widget.visibleColumns.isEmpty ||
            widget.visibleColumns.contains(key))
        .toList();
    return List.generate(keys.length, (index) {
      String columnName = keys[index];

      return DataColumn(
        label: Text(columnName),
        onSort: (columnIndex, _) {
          setState(() {
            if (_currentSortColumn == columnIndex) {
              _isSortAsc = !_isSortAsc;
            } else {
              _isSortAsc = true;
              _currentSortColumn = columnIndex;
            }

            _sort((item) => item.toTableData()[columnName]);
          });
        },
      );
    });
  }

  List<DataRow> _itemTableRows() {
    return widget.data.map((item) {
      var data = item.toTableData();
      var filterdData = data.keys
          .where((key) =>
              widget.visibleColumns.isEmpty ||
              widget.visibleColumns.contains(key))
          .map((key) => data[key])
          .toList();

      var cells = filterdData.asMap().entries.map((e) {
        if (e.key == widget.interactiveColumnIndex) {
          // return DataCell(
          //   Text(e.value.toString()),
          //   onTap: () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           title: const Text('Detail'),
          //           content: const Text('For detail'),
          //           actions: <Widget>[
          //             TextButton(
          //               child: const Text('close'),
          //               onPressed: () {
          //                 Navigator.of(context).pop();
          //               },
          //             ),
          //           ],
          //         );
          //       },
          //     );
          //   },
          // );
          return DataCell(
            Text(e.value.toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateItemPage(
                          itemCode: e.value.toString(),
                        )),
              );
            },
          );
        } else if (widget.imageColumnIndex != -1 &&
            e.key == widget.imageColumnIndex) {
          return DataCell(
              Container(
                alignment: Alignment.centerLeft,
                // 使用Image.network来加载并显示网络图片
                child: Image.network(
                  e.value.toString(),
                  // 你可以根据需要设置宽度和高度
                  width: 40,
                  height: 40,
                  // 设置图片加载过程中的占位符
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
              ), onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Image.network(
                      e.value.toString(),
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 2,
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
                    ),
                  );
                });
          });
        } else {
          return DataCell(Text(e.value.toString()));
        }
      }).toList();
      return DataRow(cells: cells);
    }).toList();
  }

  DataTable _itemTable() {
    return DataTable(
      columnSpacing: 5,
      columns: _itemTableColumns(),
      rows: _itemTableRows(),
      sortColumnIndex: _currentSortColumn,
      sortAscending: _isSortAsc,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Text('No data');
    } else {
      return _itemTable();
    }
  }
}
