class ApiResponseDTO {
  /// TÍTULO PARA A CAIXA DE TEXTO
  String title;

  /// MENSAGEM DE ERRO
  String message;

  /// O CÓDIGO DA RESPOSTA HTTP
  int statusCode;

  /// SE DEVO RETORNAR O USUÁRIO PARA A TELA DE LOGIN
  bool sendToLogin;

  Map<String, dynamic> data;

  ApiResponseDTO({
    this.title = 'Erro',
    this.message = '',
    this.statusCode = 0,
    this.sendToLogin = false,
    this.data,
  });

  ApiResponseDTO.fromJson(dynamic json) {
    title = json['title'];
    message = json['message'];
    statusCode = json['statusCode'];
    sendToLogin = json['sendToLogin'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    data['sendToLogin'] = this.sendToLogin;
    data['data'] = this.data;
    return data;
  }
}
