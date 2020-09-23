import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mobile/src/DTOs/AlertBoxDTO.dart';
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
    ApiService apiService = new ApiService();

    AlertBoxDTO alertBoxDTO = new AlertBoxDTO();

    try {
      Response response = await apiService.makeRequest(
        method: "GET",
        uri: "/farms",
        sendToken: true,
      );

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
          alertBoxDTO.message =
              'Sua sessão expirou por favor faça o login novamente';
          _farmListController.addError(alertBoxDTO);
          break;
        case 401:
          alertBoxDTO.message = jsonDecode(response.body)['error'];
          alertBoxDTO.sendToLogin = true;
          _farmListController.addError(alertBoxDTO);
          break;
        default:
      }
    } on SocketException {
      alertBoxDTO.message = 'O dispositivo está sem internet';
      _farmListController.addError(alertBoxDTO);
    } on TimeoutException {
      alertBoxDTO.message = 'O tempo de conexão foi excedido';
      _farmListController.addError(alertBoxDTO);
    } on HttpException {
      alertBoxDTO.message = 'Erro no servidor';
      _farmListController.addError(alertBoxDTO);
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _farmListController.close();
    super.dispose();
  }
}
