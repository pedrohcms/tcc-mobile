class FarmConfiguration {
  String engineType;
  double unityAmount;
  double unityPrice;

  FarmConfiguration({this.engineType, this.unityAmount, this.unityPrice});

  FarmConfiguration.fromJson(Map<String, dynamic> json) {
    engineType = json['engineType'];
    unityAmount = double.parse(json['unityAmount'].toString());
    unityPrice = double.parse(json['unityPrice'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['engineType'] = this.engineType;
    data['unityAmount'] = this.unityAmount;
    data['unityPrice'] = this.unityPrice;
    return data;
  }
}
