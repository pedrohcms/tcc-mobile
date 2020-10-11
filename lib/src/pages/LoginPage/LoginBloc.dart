import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
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

  /// MÉTODO RESPONSÁVEL POR FAZER A REQUSIÇÃO DE LOGIN
  Future<ApiResponseDTO> login(String email, String password) async {
    // SINALIZA PARA A TELA MOSTRAR O CARREGAMENTO
    isLoadingInput.add(true);

    Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };

    ApiResponseDTO apiResponseDTO = new ApiResponseDTO();

    Response response;

    try {
      response = await ApiService.makeRequest(
        method: "POST",
        uri: "sessions",
        body: jsonEncode(body),
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);

      apiResponseDTO.statusCode = response.statusCode;

      switch (response.statusCode) {
        case 200:
          TokenService.setToken(responseBody["user"]["token"]);
          apiResponseDTO.title = "Sucesso";
          apiResponseDTO.data = responseBody["user"];
          break;

        case 400:
          apiResponseDTO.message = responseBody['error'];
          break;
      }
    } on SocketException {
      apiResponseDTO.message = 'O dispositivo está sem internet';
    } on TimeoutException {
      apiResponseDTO.message = 'O tempo de conexão foi excedido';
    } on HttpException {
      apiResponseDTO.message = 'Erro no servidor';
    }

    // SINALIZA PARA A TELA ESCONDER O CARREGAMENTO
    isLoadingInput.add(false);

    return apiResponseDTO;
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
