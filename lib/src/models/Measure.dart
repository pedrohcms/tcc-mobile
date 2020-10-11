class Measure {
  String startDate;
  String endDate;
  double sum;

  Measure({this.startDate, this.endDate, this.sum = 0});

  Measure.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
    sum = double.parse(json['sum'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['sum'] = this.sum;
    return data;
  }
}
