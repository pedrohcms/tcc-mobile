class EngineOperation {
  double totalPrice;
  double totalAmount;
  String engineType;
  double hoursAmount;

  EngineOperation({
    this.totalPrice = 0.0,
    this.totalAmount = 0.0,
    this.engineType = "",
    this.hoursAmount = 0.0,
  });

  EngineOperation.fromJson(Map<String, dynamic> json) {
    totalPrice = double.parse(json['totalPrice'].toString());
    totalAmount = double.parse(json['totalAmount'].toString());
    engineType = json['engineType'];
    hoursAmount = double.parse(json['hoursAmount'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalPrice'] = this.totalPrice;
    data['totalAmount'] = this.totalAmount;
    data['engineType'] = this.engineType;
    return data;
  }
}
