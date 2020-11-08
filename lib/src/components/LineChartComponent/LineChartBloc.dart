import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/src/models/Measure.dart';
import 'package:mobile/src/models/SectorMeasure.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartBloc {
  List<SectorMeasure> sectorMeasures;

  List<Measure> makeGraphicData() {
    List<Measure> measures = [];

    sectorMeasures.forEach((sectorMeasures) {
      sectorMeasures.measures.forEach((measure) => measures.add(measure));
    });

    return measures;
  }

  List<ChartSeries> makeGraphicSeries() {
    DateFormat format;

    if (sectorMeasures.isNotEmpty) {
      format = getDateTimeFormat();
    }

    List<Measure> measures = makeGraphicData();

    return [
      LineSeries<Measure, String>(
        name: "Quantidade de água",
        animationDuration: 3000,
        color: Colors.blue,
        dataSource: measures,
        markerSettings: MarkerSettings(isVisible: true),
        xValueMapper: (Measure measure, _) => format != null
            ? format.format(
                DateTime.parse(measure.createdAt),
              )
            : measure.createdAt,
        yValueMapper: (Measure measure, _) => measure.waterAmount,
      ),
    ];
  }

  /// MÉTODO RESPONSÁVEL POR RETORNAR O FORMATO DA DATA DO GRÁFICO
  DateFormat getDateTimeFormat() {
    DateTime startDate =
        DateTime.parse(sectorMeasures.first.measures.first.createdAt);
    DateTime endDate =
        DateTime.parse(sectorMeasures.first.measures.last.createdAt);

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
