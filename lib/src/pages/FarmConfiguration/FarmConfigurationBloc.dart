import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/pages/FarmConfiguration/FarmConfigurationPage.dart';
import 'package:mobile/src/services/ApiService.dart';

class FarmConfigurationBloc extends ChangeNotifier {
  StreamController<bool> _isLoadingStream = new StreamController<bool>();
  Sink<bool> get isLoadingInput => _isLoadingStream.sink;
  Stream<bool> get isLoadingOutput => _isLoadingStream.stream;

  /// Method responsible to save the configuration values of the farm.
  Future<ApiResponseDTO> saveConfiguration(
    int farmId,
    TipoAlimentacao tipoAlimentacao,
    double amount,
    double price,
  ) async {
    isLoadingInput.add(true);

    Map<String, dynamic> body = {
      'engineType': tipoAlimentacao.index == 0 ? 'eletrico' : 'combustivel',
      'unityAmount': amount,
      'unityPrice': price,
    };

    ApiResponseDTO apiResponseDTO = new ApiResponseDTO();

    try {
      Response response = await ApiService.makeRequest(
        method: 'UPDATE',
        uri: 'farm_configuration/$farmId',
        body: jsonEncode(body),
        sendToken: true,
      );

      apiResponseDTO.statusCode = response.statusCode;

      switch (apiResponseDTO.statusCode) {
        case 200:
          apiResponseDTO.title = 'Sucesso';
          apiResponseDTO.message = 'Informações atualizados com sucesso';
          break;
        case 400:
          apiResponseDTO.message = jsonDecode(response.body)['error'];
          break;
        case 401:
          apiResponseDTO.message =
              "Sua sessão expirou por favor faça o login novamente";
          apiResponseDTO.sendToLogin = true;
          break;
      }
    } on SocketException {
      apiResponseDTO.message = 'O dispositivo está sem internet';
    } on TimeoutException {
      apiResponseDTO.message = 'O tempo de conexão foi excedido';
    } on HttpException {
      apiResponseDTO.message = 'Erro no servidor';
    }

    isLoadingInput.add(false);

    return apiResponseDTO;
  }

  @override
  void dispose() {
    _isLoadingStream.close();
    super.dispose();
  }
}
