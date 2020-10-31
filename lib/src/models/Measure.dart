class Measure {
  double waterAmount;
  double moisture;
  String createdAt;

  Measure({this.waterAmount, this.moisture, this.createdAt});

  Measure.fromJson(Map<String, dynamic> json) {
    waterAmount = double.parse(json['waterAmount'].toString());
    moisture = double.parse(json['moisture'].toString());
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['waterAmount'] = this.waterAmount;
    data['moisture'] = this.moisture;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
