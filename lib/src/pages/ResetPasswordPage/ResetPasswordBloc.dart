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
    ApiService apiService = new ApiService();
    Map<String, dynamic> body = {
      "password": password,
      "confirm_password": confirmPassword
    };
    Map<String, String> result = {'tittle': 'Mensagem', 'message': ''};

    Response response;

    try {
      response = await apiService.makeRequest(
          method: "POST",
          uri: "reset_passwords/$email",
          body: jsonEncode(body));
      print(response.statusCode);
      print(response.body);
      result["message"] = 'deu certo';
    } on SocketException {
      result["message"] = 'O dispositivo está sem internet';
      return result;
    } on TimeoutException {
      result['message'] = 'O tempo de conexão foi excedido';

      return result;
    } on HttpException {
      result['message'] = 'Erro no servidor';

      return result;
    }
  }

  @override
  void dispose() {
    _passwordFieldVisibilityController.close();
    _passwordConfirmationFieldVisibilityController.close();
    super.dispose();
  }
}
