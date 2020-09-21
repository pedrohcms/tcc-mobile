class AlertBoxDTO {
  String title;
  String message;
  bool sendToLogin;

  AlertBoxDTO(
      {this.title = "Erro", this.message = "", this.sendToLogin = false});
}
