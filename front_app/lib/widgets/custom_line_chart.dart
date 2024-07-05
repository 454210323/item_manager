import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CustomLineChart({required this.data, Key? key}) : super(key: key);

  List<FlSpot> createDataPoints(List<Map<String, dynamic>> data) {
    return data.map((point) {
      return FlSpot(point['time'].millisecondsSinceEpoch.toDouble(),
          point['value'].toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: createDataPoints(data),
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
              leftTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, titleMeta) {
                    DateTime date =
                        DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    return Text(DateFormat('MM-dd').format(date));
                  },
                ),
              )),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}
