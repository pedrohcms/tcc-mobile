import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:mobile/src/components/LineChartComponent/LineChartBloc.dart';

class LineChartComponent extends StatelessWidget {
  final LineChartBloc _lineChartBloc = new LineChartBloc();

  @override
  Widget build(BuildContext context) {
    return TimeSeriesChart(
      _lineChartBloc.makeGraphicSeries(),
      animationDuration: Duration(seconds: 3),
      animate: true,
      dateTimeFactory: LocalDateTimeFactory(),
      domainAxis: DateTimeAxisSpec(
        tickFormatterSpec: AutoDateTimeTickFormatterSpec(
          day: TimeFormatterSpec(format: 'd', transitionFormat: 'dd/MM/yyyy'),
        ),
      ),
      defaultRenderer: LineRendererConfig(includePoints: true),
      behaviors: [
        SeriesLegend(),
      ],
    );
  }
}
