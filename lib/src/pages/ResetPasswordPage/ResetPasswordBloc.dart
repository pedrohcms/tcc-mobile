import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mobile/src/services/ApiService.dart';

class ResetPasswordBloc extends ChangeNotifier {
  bool passwordFieldVisibility = true;

  final StreamController<bool> _passwordFieldVisibilityController =
      StreamController<bool>();
  Sink<bool> get passwordFieldVisibilityInput =>
      _passwordFieldVisibilityController.sink;
  Stream<bool> get passwordFieldVisibilityOutput =>
      _passwordFieldVisibilityController.stream;

  bool passwordConfirmationFieldVisibility = true;

  final StreamController<bool> _passwordConfirmationFieldVisibilityController =
      StreamController<bool>();
  Sink<bool> get passwordConfirmationFieldVisibilityInput =>
      _passwordConfirmationFieldVisibilityController.sink;
  Stream<bool> get passwordConfirmationFieldVisibilityOutput =>
      _passwordConfirmationFieldVisibilityController.stream;

  // STREAM PARA CONTROLLAR O LOADING
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Sink<bool> get isLoadingInput => _isLoadingController.sink;
  Stream<bool> get isLoadingOutput => _isLoadingController.stream;

  void changePasswordFieldVisibility() {
    passwordFieldVisibility = !passwordFieldVisibility;
    passwordFieldVisibilityInput.add(passwordFieldVisibility);

    notifyListeners();
  }

  void changePasswordConfirmationFieldVisibility() {
    passwordConfirmationFieldVisibility = !passwordConfirmationFieldVisibility;
    passwordConfirmationFieldVisibilityInput
        .add(passwordConfirmationFieldVisibility);

    notifyListeners();
  }

  Future<Map<String, String>> resetPassword(
      email, String password, String confirmPassword) async {
    // SINALIZA PARA A TELA MOSTRAR O CARREGAMENTO
    isLoadingInput.add(true);

    ApiService apiService = new ApiService();

    Map<String, dynamic> body = {
      "password": password,
      "confirm_password": confirmPassword
    };

    Map<String, String> result = {'title': 'Erro', 'message': ''};

    Response response;

    try {
      response = await apiService.makeRequest(
        method: "POST",
        uri: "reset_passwords/$email",
        body: jsonEncode(body),
      );

      switch (response.statusCode) {
        case 200:
          result['title'] = 'Sucesso';
          result['message'] = 'Senha atualizada com sucesso';
          break;
        case 400:
          result['message'] = jsonDecode(response.body)['error'];
          break;
      }
    } on SocketException {
      result["message"] = 'O dispositivo está sem internet';
    } on TimeoutException {
      result['message'] = 'O tempo de conexão foi excedido';
    } on HttpException {
      result['message'] = 'Erro no servidor';
    }

    // SINALIZA PARA A TELA MOSTRAR O CARREGAMENTO
    isLoadingInput.add(false);
    return result;
  }

  @override
  void dispose() {
    _passwordFieldVisibilityController.close();
    _passwordConfirmationFieldVisibilityController.close();
    _isLoadingController.close();
    super.dispose();
  }
}
