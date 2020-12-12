import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/src/models/Measure.dart';
import 'package:mobile/src/models/SectorMeasure.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartBloc {
  List<SectorMeasure> sectorMeasures;

  /// Método responsável por preparar os dados que serão exibidos no gráfico.
  List<Measure> makeGraphicData() {
    List<Measure> measures = [];

    sectorMeasures.forEach((sectorMeasures) {
      sectorMeasures.measures.forEach((measure) => measures.add(measure));
    });

    return measures;
  }

  /// Método responsável por prepara as Series de dados para o gráfico.
  List<ChartSeries> makeGraphicSeries() {
    List<Measure> measures = makeGraphicData();

    DateFormat format;

    if(measures.isNotEmpty) {
      format = getDateTimeFormat(measures);
    }
  
    return [
      LineSeries<Measure, String>(
        name: "Quantidade de água",
        animationDuration: 3000,
        color: Colors.blue,
        dataSource: measures,
        markerSettings: MarkerSettings(isVisible: true),
        xValueMapper: (Measure measure, _) => format != null
            ? format.format(
                DateTime.parse(measure.createdAt).toLocal(),
              )
            : measure.createdAt,
        yValueMapper: (Measure measure, _) => measure.waterAmount,
      ),
    ];
  }

  /// MÉTODO RESPONSÁVEL POR RETORNAR O FORMATO DA DATA DO GRÁFICO
  DateFormat getDateTimeFormat(List<Measure> measures) {
    DateTime startDate =
        DateTime.parse(measures.first.createdAt);
    DateTime endDate =
        DateTime.parse(measures.last.createdAt);

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
