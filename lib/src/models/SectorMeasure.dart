import 'package:mobile/src/models/Measure.dart';

class SectorMeasure {
  String sector;
  double idealMoisture;
  String culture;
  List<Measure> measures;

  SectorMeasure({
    this.sector,
    this.idealMoisture,
    this.culture,
    this.measures,
  });

  SectorMeasure.fromJson(Map<String, dynamic> json) {
    sector = json['sector'];
    if (json['idealMoisture'] == null) {
      idealMoisture = 0.0;
    } else {
      idealMoisture = double.parse(json['idealMoisture'].toString());
    }

    culture = json['culture'];
    if (json['measures'] != null) {
      measures = new List<Measure>();
      json['measures'].forEach((v) {
        measures.add(new Measure.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sector'] = this.sector;
    data['idealMoisture'] = this.idealMoisture;
    data['culture'] = this.culture;
    if (this.measures != null) {
      data['measures'] = this.measures.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
