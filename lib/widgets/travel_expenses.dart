import 'package:flutter/material.dart';

class TravelExpenses extends StatefulWidget {
  const TravelExpenses({super.key});

  @override
  _TravelExpensesState createState() => _TravelExpensesState();
}

class _TravelExpensesState extends State<TravelExpenses> {
  String? arrowType;
  List<String> stationList = []; // 存储车站列表

  // 模拟从 API 获取车站数据的函数
  void searchStations(String query) {
    // 假设您的 API 返回一个车站名称列表
    // 这里用一些示例数据来模拟
    setState(() {
      stationList = ['Tokyo', 'Osaka', 'Kyoto'].where((station) {
        return station.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return stationList.where((String option) {
                return option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              debugPrint('You just selected $selection');
            },
          ),
        ),
        DropdownButton<String>(
          value: arrowType,
          onChanged: (String? newValue) {
            setState(() {
              arrowType = newValue;
            });
          },
          items: <String>['one-way', 'round-trip']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Expanded(
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return stationList.where((String option) {
                return option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              debugPrint('You just selected $selection');
            },
          ),
        ),
      ],
    );
  }
}
