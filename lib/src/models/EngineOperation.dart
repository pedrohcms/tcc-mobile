class EngineOperation {
  double totalPrice;
  double totalAmount;
  double hoursAmount;
  String engineType;
  double unityAmount;
  double unityPrice;

  EngineOperation({
    this.totalPrice = 0.0,
    this.totalAmount = 0.0,
    this.hoursAmount = 0.0,
    this.engineType = "",
    this.unityAmount = 0.0,
    this.unityPrice = 0.0,
  });

  EngineOperation.fromJson(Map<String, dynamic> json) {
    totalPrice = double.parse(json['totalPrice'].toString());
    totalAmount = double.parse(json['totalAmount'].toString());
    hoursAmount = double.parse(json['hoursAmount'].toString());
    engineType = json['engineType'];
    unityAmount = double.parse(json['unityAmount'].toString());
    unityPrice = double.parse(json['unityPrice'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalPrice'] = this.totalPrice;
    data['totalAmount'] = this.totalAmount;
    data['engineType'] = this.engineType;
    return data;
  }
}
