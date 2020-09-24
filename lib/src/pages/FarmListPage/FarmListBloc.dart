import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/models/Farm.dart';
import 'package:mobile/src/services/ApiService.dart';
import 'package:http/http.dart';

class FarmListBloc extends ChangeNotifier {
  // DEFININDO STREAM PARA LISTAGEM DE FAZENDAS
  final StreamController<List<Farm>> _farmListController =
      new StreamController<List<Farm>>();
  Sink<List<Farm>> get farmListInput => _farmListController.sink;
  Stream<List<Farm>> get farmListOutput => _farmListController.stream;

  /// Método responsável por buscar as fazendas na API
  Future<void> index() async {
    ApiResponseDTO apiResponseDTO = new ApiResponseDTO();

    try {
      Response response = await ApiService.makeRequest(
        method: "GET",
        uri: "/farms",
        sendToken: true,
      );

      apiResponseDTO.statusCode = response.statusCode;

      switch (response.statusCode) {
        case 200:
          List<dynamic> responseBody = jsonDecode(response.body);

          List<Farm> farms = new List<Farm>();

          // MONTO A LISTA DE FAZENDAS
          responseBody.forEach((farm) {
            farms.add(Farm.fromJson(farm));
          });

          farmListInput.add(farms);
          break;
        case 400:
          apiResponseDTO.message = jsonDecode(response.body)['error'];

          _farmListController.addError(apiResponseDTO);
          break;
        case 401:
          apiResponseDTO.message =
              'Sua sessão expirou por favor faça o login novamente';
          apiResponseDTO.sendToLogin = true;

          _farmListController.addError(apiResponseDTO);
          break;
        default:
      }
    } on SocketException {
      apiResponseDTO.message = 'O dispositivo está sem internet';
      _farmListController.addError(apiResponseDTO);
    } on TimeoutException {
      apiResponseDTO.message = 'O tempo de conexão foi excedido';
      _farmListController.addError(apiResponseDTO);
    } on HttpException {
      apiResponseDTO.message = 'Erro no servidor';
      _farmListController.addError(apiResponseDTO);
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _farmListController.close();
    super.dispose();
  }
}
