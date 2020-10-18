import 'package:charts_flutter/flutter.dart';
import 'package:mobile/src/models/Measure.dart';

class LineChartBloc {
  List<Measure> makeGraphicData() {
    return [
      new Measure(startDate: "2020-10-02", sum: 20.0),
      new Measure(startDate: "2020-10-15", sum: 300.0),
      new Measure(startDate: "2020-10-25", sum: 400.0),
      new Measure(startDate: "2020-11-01", sum: 10.0),
      new Measure(startDate: "2020-11-06", sum: 30.0),
      new Measure(startDate: "2020-11-07", sum: 50.0),
      new Measure(startDate: "2020-12-08", sum: 100.0),
    ];
  }

  List<Series<Measure, DateTime>> makeGraphicSeries() {
    return [
      new Series<Measure, DateTime>(
        id: 'Medidas',
        data: makeGraphicData(),
        domainFn: (Measure measure, _) => DateTime.parse(measure.startDate),
        measureFn: (Measure measure, _) => measure.sum,
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
      )
    ];
  }
}
