import 'package:flutter/material.dart';

import '../models/table_item.dart';

class DynamicDataTable extends StatefulWidget {
  final List<TableItem> data;

  DynamicDataTable({required this.data});

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
    var keys = widget.data[0].toTableData().keys.toList();
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
      var cells = item.toTableData().values.map((value) {
        return DataCell(Text(value.toString()));
      }).toList();
      return DataRow(cells: cells);
    }).toList();
  }

  DataTable _itemTable() {
    return DataTable(
      columns: _itemTableColumns(),
      rows: _itemTableRows(),
      sortColumnIndex: _currentSortColumn,
      sortAscending: _isSortAsc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _itemTable();
  }
}
