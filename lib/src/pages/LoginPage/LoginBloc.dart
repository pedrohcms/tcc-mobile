import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mobile/src/services/ApiService.dart';
import 'package:mobile/src/services/TokenService.dart';

class LoginBloc extends ChangeNotifier {
  login(String email, String password) async {
    ApiService apiService = new ApiService();
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };
    Response response = await apiService.makeRequest(
        method: "POST", uri: "sessions", body: jsonEncode(body));
    if (response.statusCode == 200) {
      TokenService tokenService = new TokenService();
      Map<String, dynamic> token = jsonDecode(response.body);
      tokenService.setToken(token["token"]);
    }
  }
}
