import 'dart:async';

import 'package:flutter/foundation.dart';

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

  @override
  void dispose() {
    _passwordFieldVisibilityController.close();
    _passwordConfirmationFieldVisibilityController.close();
    super.dispose();
  }
}
