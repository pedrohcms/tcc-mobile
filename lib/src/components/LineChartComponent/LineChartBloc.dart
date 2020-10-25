import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/src/models/Measure.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartBloc {
  List<Measure> measures;

  List<ChartSeries> makeGraphicSeries() {
    DateFormat format = getDateTimeFormat();

    return [
      LineSeries<Measure, String>(
        name: "Quantidade de água",
        animationDuration: 3000,
        color: Colors.blue,
        dataSource: measures,
        markerSettings: MarkerSettings(isVisible: true),
        xValueMapper: (Measure measure, _) => format.format(
          DateTime.parse(measure.startDate),
        ),
        yValueMapper: (Measure measure, _) => measure.sum,
      ),
    ];
  }

  /// MÉTODO RESPONSÁVEL POR RETORNAR O FORMATO DA DATA DO GRÁFICO
  DateFormat getDateTimeFormat() {
    DateTime startDate = DateTime.parse(measures.first.startDate);
    DateTime endDate = DateTime.parse(measures.last.startDate);

    if ((endDate.day - startDate.day > 0) &&
        (endDate.month - startDate.month == 0) &&
        (endDate.year - startDate.year == 0)) return DateFormat('dd', 'pt_BR');

    if ((endDate.month - startDate.month > 0) &&
        (endDate.year - startDate.year == 0))
      return DateFormat('dd/MM', 'pt_BR');

    if (endDate.year - startDate.year > 0) return DateFormat.yMd('pt_BR');

    return DateFormat('dd', 'pt_BR').add_Hm();
  }
}
