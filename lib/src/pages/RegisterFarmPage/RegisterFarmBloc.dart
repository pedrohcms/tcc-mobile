import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mobile/src/DTOs/AlertBoxDTO.dart';
import 'package:mobile/src/services/ApiService.dart';

class RegisterFarmBloc extends ChangeNotifier {
  // STREAM PARA CONTROLLAR O LOADING
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Sink<bool> get isLoadingInput => _isLoadingController.sink;
  Stream<bool> get isLoadingOutput => _isLoadingController.stream;

  Future<AlertBoxDTO> store(String name, String address) async {
    // SINALIZA PARA A TELA MOSTRAR O CARREGAMENTO
    _isLoadingController.add(true);

    ApiService apiService = new ApiService();

    Map<String, dynamic> body = {
      "user_id": 5,
      "name": name,
      "address": address
    };

    AlertBoxDTO alertBoxDTO = new AlertBoxDTO();

    Response response;

    try {
      response = await apiService.makeRequest(
        method: "POST",
        body: jsonEncode(body),
        uri: "/farms",
        sendToken: true,
      );

      switch (response.statusCode) {
        case 201:
          alertBoxDTO.title = 'Sucesso';
          alertBoxDTO.message = 'Fazenda cadastrada com sucesso';
          break;
        case 400:
          alertBoxDTO.message = jsonDecode(response.body)['error'];
          break;
        case 401:
          alertBoxDTO.message =
              'Sua sessão expirou por favor faça o login novamente';
          alertBoxDTO.sendToLogin = true;
          break;
        case 403:
          alertBoxDTO.message = 'O usuário não tem permissão para isso';
          break;
      }
    } on SocketException {
      alertBoxDTO.message = 'O dispositivo está sem internet';
    } on TimeoutException {
      alertBoxDTO.message = 'O tempo de conexão foi excedido';
    } on HttpException {
      alertBoxDTO.message = 'Erro no servidor';
    }

    // SINALIZA PARA A TELA ESCONDER O CARREGAMENTO
    isLoadingInput.add(false);

    return alertBoxDTO;
  }

  @override
  void dispose() {
    _isLoadingController.close();
    super.dispose();
  }
}
