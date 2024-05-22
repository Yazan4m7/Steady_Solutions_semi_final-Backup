import 'package:flutter/material.dart';
import 'package:steady_solutions/models/dashboard/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CircularChart extends StatefulWidget {
  final List<ChartData> chartData;

  const CircularChart({Key? key, required this.chartData}) : super(key: key);

  @override
  State<CircularChart> createState() => _CircularChartState();
}

class _CircularChartState extends State<CircularChart> {
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(series: <CircularSeries>[
      // Renders doughnut chart
      DoughnutSeries<ChartData, String>(
          dataSource: widget.chartData,
          pointColorMapper: (ChartData data, _) => data.color,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y)
    ]);
  }
}
