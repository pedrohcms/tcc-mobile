import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/services/ApiService.dart';

class RegisterFarmBloc extends ChangeNotifier {
  // STREAM PARA CONTROLLAR O LOADING
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Sink<bool> get isLoadingInput => _isLoadingController.sink;
  Stream<bool> get isLoadingOutput => _isLoadingController.stream;

  Future<ApiResponseDTO> store(String name, String address) async {
    // SINALIZA PARA A TELA MOSTRAR O CARREGAMENTO
    _isLoadingController.add(true);

    ApiService apiService = new ApiService();

    Map<String, dynamic> body = {"name": name, "address": address};

    ApiResponseDTO apiResponseDTO = new ApiResponseDTO();

    Response response;

    try {
      response = await apiService.makeRequest(
        method: "POST",
        body: jsonEncode(body),
        uri: "/farms",
        sendToken: true,
      );

      switch (response.statusCode) {
        case 201:
          apiResponseDTO.title = 'Sucesso';
          apiResponseDTO.message = 'Fazenda cadastrada com sucesso';
          break;
        case 400:
          apiResponseDTO.message = jsonDecode(response.body)['error'];
          break;
        case 401:
          apiResponseDTO.message =
              'Sua sessão expirou por favor faça o login novamente';
          apiResponseDTO.sendToLogin = true;
          break;
        case 403:
          apiResponseDTO.message = 'O usuário não tem permissão para isso';
          break;
      }
    } on SocketException {
      apiResponseDTO.message = 'O dispositivo está sem internet';
    } on TimeoutException {
      apiResponseDTO.message = 'O tempo de conexão foi excedido';
    } on HttpException {
      apiResponseDTO.message = 'Erro no servidor';
    }

    // SINALIZA PARA A TELA ESCONDER O CARREGAMENTO
    isLoadingInput.add(false);

    return apiResponseDTO;
  }

  @override
  void dispose() {
    _isLoadingController.close();
    super.dispose();
  }
}
