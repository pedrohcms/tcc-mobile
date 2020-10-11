import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/models/Home.dart';
import 'package:mobile/src/services/ApiService.dart';

class HomeBloc extends ChangeNotifier {
  StreamController<Home> _homeController = new StreamController<Home>();
  Sink<Home> get homeInput => _homeController.sink;
  Stream<Home> get homeOutput => _homeController.stream;

  Future<void> getHomeDate(int farmId) async {
    ApiResponseDTO apiResponseDTO = new ApiResponseDTO();

    try {
      Response response = await ApiService.makeRequest(
        uri: '/home/$farmId',
        method: "GET",
        sendToken: true,
      );

      apiResponseDTO.statusCode = response.statusCode;

      switch (response.statusCode) {
        case 200:
          Home home = Home.fromJson(jsonDecode(response.body));

          homeInput.add(home);
          break;
        case 401:
          apiResponseDTO.message =
              "Sua sessão expirou por favor faça o login novamente";
          apiResponseDTO.sendToLogin = true;

          _homeController.addError(apiResponseDTO);
          break;
      }
    } on SocketException {
      apiResponseDTO.message = 'O dispositivo está sem internet';
      _homeController.addError(apiResponseDTO);
    } on TimeoutException {
      apiResponseDTO.message = 'O tempo de conexão foi excedido';
      _homeController.addError(apiResponseDTO);
    } on HttpException {
      apiResponseDTO.message = 'Erro no servidor';
      _homeController.addError(apiResponseDTO);
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _homeController.close();
    super.dispose();
  }
}
