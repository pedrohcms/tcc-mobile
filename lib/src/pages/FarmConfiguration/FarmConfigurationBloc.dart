import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/pages/FarmConfiguration/FarmConfigurationPage.dart';
import 'package:mobile/src/services/ApiService.dart';

class FarmConfigurationBloc {
  /// Method responsible to save the configuration values of the farm.
  Future<ApiResponseDTO> saveConfiguration(
    int farmId,
    TipoAlimentacao tipoAlimentacao,
    double amount,
    double price,
  ) async {
    Map body = {
      'engineType': tipoAlimentacao.index == 0 ? 'eletrico' : 'combustivel',
      'unityAmount': amount,
      'unityPrice': price,
    };

    ApiResponseDTO apiResponseDTO = new ApiResponseDTO();

    try {
      Response response = await ApiService.makeRequest(
        method: 'PUT',
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

    return apiResponseDTO;
  }
}
