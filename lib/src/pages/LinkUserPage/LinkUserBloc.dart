import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/models/User.dart';
import 'package:mobile/src/services/ApiService.dart';

class LinkUserBloc extends ChangeNotifier {
  // Streams para controlar a lista de usuários
  StreamController<List<User>> _linkedUsersController =
      new StreamController<List<User>>();
  Sink<List<User>> get linkedUsersInput => _linkedUsersController.sink;
  Stream<List<User>> get linkedUsersoutput => _linkedUsersController.stream;

  /// MÉTODO RESPONSÁVEL POR RECUPERAR OS USUÁRIOS VINCULADOS A UMA FAZENDA
  Future<void> getLinkedUsers(int farmId) async {
    ApiResponseDTO apiResponseDTO = ApiResponseDTO();

    Response response;

    Map<String, dynamic> queries = {
      "farm_id": farmId,
    };

    try {
      response = await ApiService.makeRequest(
        method: "GET",
        uri: "/link_user_farm",
        queries: queries,
        sendToken: true,
      );

      apiResponseDTO.statusCode = response.statusCode;

      switch (response.statusCode) {
        case 200:
          linkedUsersInput.add(convertResponseToUserList(response));
          break;

        case 401:
          apiResponseDTO.sendToLogin = true;
          apiResponseDTO.message =
              'Sua sessão expirou.\nPor favor, faça o login novamente.';

          _linkedUsersController.addError(apiResponseDTO);
          break;
      }
    } on SocketException {
      apiResponseDTO.message = 'O dispositivo está sem internet';
      _linkedUsersController.addError(apiResponseDTO);
    } on TimeoutException {
      apiResponseDTO.message = 'Tempo de conexão excedido.';
      _linkedUsersController.addError(apiResponseDTO);
    } on HttpException {
      apiResponseDTO.message = 'Erro no servidor.';
      _linkedUsersController.addError(apiResponseDTO);
    }
  }

  /// MÉTODO RESPONSÁVEL POR CONVERTER A RESPOSTA DA API EM UMA LISTA DE USUÁRIOS
  List<User> convertResponseToUserList(Response response) {
    List<dynamic> responseBody = jsonDecode(response.body);

    List<User> users = [];

    responseBody.forEach(
      (user) => users.add(
        User.fromJson(user),
      ),
    );

    return users;
  }

  @override
  void dispose() {
    _linkedUsersController.close();
    super.dispose();
  }
}
