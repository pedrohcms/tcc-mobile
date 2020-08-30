import 'dart:async';
import 'dart:convert';

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

  void resetPassword(
      String email, String password, String confirmPassword) async {
    ApiService apiService = new ApiService();
    Map<String, dynamic> body = {
      "password": password,
      "confirm_password": confirmPassword
    };
    Response response = await apiService.makeRequest(
        method: "POST", uri: "reset_passwords/$email", body: jsonEncode(body));
    print(response.statusCode);
    print(response.body);
  }

  @override
  void dispose() {
    _passwordFieldVisibilityController.close();
    _passwordConfirmationFieldVisibilityController.close();
    super.dispose();
  }
}
