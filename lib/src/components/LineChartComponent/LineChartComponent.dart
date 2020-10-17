import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as chart;
import 'package:mobile/src/models/Measure.dart';

class LineChartComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Measure> data = [
      new Measure(startDate: "2020-10-02", sum: 10.0),
      new Measure(startDate: "2020-10-03", sum: 20.0),
      new Measure(startDate: "2020-10-04", sum: 300.0),
      new Measure(startDate: "2020-10-11", sum: 400.0),
      new Measure(startDate: "2020-12-01", sum: 10.0),
      new Measure(startDate: "2020-12-05", sum: 30.0),
      new Measure(startDate: "2020-12-25", sum: 50.0),
      new Measure(startDate: "2020-12-25", sum: 1000.0),
    ];

    var series = [
      new chart.Series<Measure, DateTime>(
        id: 'Medidas',
        data: data,
        domainFn: (Measure measure, _) => DateTime.parse(measure.startDate),
        measureFn: (Measure measure, _) => measure.sum,
        colorFn: (_, __) => chart.MaterialPalette.blue.shadeDefault,
      )
    ];

    return new chart.TimeSeriesChart(
      series,
      animationDuration: Duration(seconds: 2),
      animate: true,
    );
  }
}
