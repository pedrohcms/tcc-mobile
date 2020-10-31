import 'package:mobile/src/models/SectorMeasure.dart';

class Home {
  List<SectorMeasure> todayMeasures;
  List<SectorMeasure> lastTwelveHoursMeasures;
  List<SectorMeasure> yesterdayMeasures;

  Home({
    this.todayMeasures,
    this.lastTwelveHoursMeasures,
    this.yesterdayMeasures,
  });

  Home.fromJson(Map<String, dynamic> json) {
    if (json['todayMeasures'] != null) {
      print(json['todayMeasures']);
      todayMeasures = new List<SectorMeasure>();
      json['todayMeasures'].forEach((v) {
        todayMeasures.add(new SectorMeasure.fromJson(v));
      });
    }
    if (json['lastTwelveHoursMeasures'] != null) {
      lastTwelveHoursMeasures = new List<SectorMeasure>();
      json['lastTwelveHoursMeasures'].forEach((v) {
        lastTwelveHoursMeasures.add(new SectorMeasure.fromJson(v));
      });
    }
    if (json['yesterdayMeasures'] != null) {
      yesterdayMeasures = new List<SectorMeasure>();
      json['yesterdayMeasures'].forEach((v) {
        yesterdayMeasures.add(new SectorMeasure.fromJson(v));
      });
    }
  }
}
