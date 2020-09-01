import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mobile/src/services/ApiService.dart';
import 'package:mobile/src/services/TokenService.dart';

class LoginBloc extends ChangeNotifier {
  Future<Map<String, String>> login(String email, String password) async {
    ApiService apiService = new ApiService();

    Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };

    Map<String, String> result = {'title': 'Erro', 'message': ''};

    Response response;

    try {
      response = await apiService.makeRequest(
          method: "POST", uri: "sessions", body: jsonEncode(body));
    } on SocketException {
      result['message'] = 'O dispositivo está sem internet';

      return result;
    } on TimeoutException {
      result['message'] = 'O tempo de conexão foi excedido';

      return result;
    } on HttpException {
      result['message'] = 'Erro no servidor';

      return result;
    }

    Map<String, dynamic> responseBody = jsonDecode(response.body);

    if (response.statusCode == 400) {
      result['message'] = responseBody['error'];

      return result;
    }

    TokenService tokenService = new TokenService();

    tokenService.setToken(responseBody["token"]);

    result['title'] = 'Sucesso';
    return result;
  }
}
