import 'package:mobile/src/models/Measure.dart';

class Home {
  Measure todayMeasures;
  Measure lastTwelveHoursMeasures;
  Measure yesterdayMeasures;

  Home(
      {this.todayMeasures,
      this.lastTwelveHoursMeasures,
      this.yesterdayMeasures});

  Home.fromJson(Map<String, dynamic> json) {
    todayMeasures = json['todayMeasures'] != null
        ? new Measure.fromJson(json['todayMeasures'])
        : null;
    lastTwelveHoursMeasures = json['lastTwelveHoursMeasures'] != null
        ? new Measure.fromJson(json['lastTwelveHoursMeasures'])
        : null;
    yesterdayMeasures = json['yesterdayMeasures'] != null
        ? new Measure.fromJson(json['yesterdayMeasures'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.todayMeasures != null) {
      data['todayMeasures'] = this.todayMeasures.toJson();
    }
    if (this.lastTwelveHoursMeasures != null) {
      data['lastTwelveHoursMeasures'] = this.lastTwelveHoursMeasures.toJson();
    }
    if (this.yesterdayMeasures != null) {
      data['yesterdayMeasures'] = this.yesterdayMeasures.toJson();
    }
    return data;
  }
}
