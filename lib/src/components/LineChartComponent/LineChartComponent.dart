import 'package:flutter/material.dart';
import 'package:mobile/src/components/LineChartComponent/LineChartBloc.dart';
import 'package:mobile/src/models/SectorMeasure.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartComponent extends StatelessWidget {
  final LineChartBloc _lineChartBloc = new LineChartBloc();

  LineChartComponent(List<SectorMeasure> sectorMeasures) {
    _lineChartBloc.sectorMeasures = sectorMeasures;
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      enableAxisAnimation: true,
      tooltipBehavior: TooltipBehavior(
        color: Colors.blue,
        enable: true,
        shouldAlwaysShow: true,
      ),
      title: ChartTitle(
        text: "Consumo de água em Litros",
        textStyle: TextStyle(
          color: Colors.blue,
          fontSize: 23,
          fontWeight: FontWeight.w500,
        ),
      ),
      primaryXAxis: CategoryAxis(
        title: AxisTitle(
          text: "Data",
        ),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: "Medidas (L)",
        ),
      ),
      series: _lineChartBloc.makeGraphicSeries(),
    );
  }
}
