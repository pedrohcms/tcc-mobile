import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mobile/src/DTOs/AlertBoxDTO.dart';
import 'package:mobile/src/services/ApiService.dart';
import 'package:mobile/src/services/TokenService.dart';

class LoginBloc extends ChangeNotifier {
  bool passwordFieldVisibility = true;

  final StreamController<bool> _passwordFieldVisibilityController =
      StreamController<bool>();
  Sink<bool> get passwordFieldVisibilityInput =>
      _passwordFieldVisibilityController.sink;
  Stream<bool> get passwordFieldVisibilityOutput =>
      _passwordFieldVisibilityController.stream;

  // STREAM PARA CONTROLLAR O LOADING
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Sink<bool> get isLoadingInput => _isLoadingController.sink;
  Stream<bool> get isLoadingOutput => _isLoadingController.stream;

  Future<AlertBoxDTO> login(String email, String password) async {
    // SINALIZA PARA A TELA MOSTRAR O CARREGAMENTO
    isLoadingInput.add(true);

    ApiService apiService = new ApiService();

    Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };

    AlertBoxDTO alertBoxDTO = new AlertBoxDTO();

    Response response;

    try {
      response = await apiService.makeRequest(
          method: "POST", uri: "sessions", body: jsonEncode(body));

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 400) {
        alertBoxDTO.message = responseBody['error'];
      } else {
        TokenService tokenService = new TokenService();

        tokenService.setToken(responseBody["token"]);

        alertBoxDTO.title = "Sucesso";
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
    _passwordFieldVisibilityController.close();
    _isLoadingController.close();

    super.dispose();
  }

  void changePasswordFieldVisibility() {
    passwordFieldVisibility = !passwordFieldVisibility;
    passwordFieldVisibilityInput.add(passwordFieldVisibility);

    notifyListeners();
  }
}
