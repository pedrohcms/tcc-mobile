import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/models/UserProfile.dart';
import 'package:mobile/src/services/ApiService.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc extends ChangeNotifier {
  int _userId;
  int _profileId;

  // Stream to control loading
  BehaviorSubject<bool> _isLoadingController = new BehaviorSubject<bool>();
  Sink<bool> get isLoadingInput => _isLoadingController.sink;
  Stream<bool> get isLoadingOutput => _isLoadingController.stream;

  // Stream to control user
  BehaviorSubject<UserProfile> _userProfileController =
      new BehaviorSubject<UserProfile>();
  Sink<UserProfile> get userProfileInput => _userProfileController.sink;
  Stream<UserProfile> get userProfileOutput => _userProfileController.stream;

  //Stream to control profile
  BehaviorSubject<int> _profileController = new BehaviorSubject<int>();
  Sink<int> get profileInput => _profileController.sink;
  Stream<int> get profileOutput => _profileController.stream;

  getUserProfile(String email) async {
    _userProfileController.add(null);

    ApiResponseDTO apiResponseDTO = ApiResponseDTO();

    Response response;

    Map<String, dynamic> queries = {
      "email": email,
    };

    try {
      response = await ApiService.makeRequest(
        method: "GET",
        uri: "/profiles",
        queries: queries,
        sendToken: true,
      );

      apiResponseDTO.statusCode = response.statusCode;

      switch (response.statusCode) {
        case 200:
          UserProfile userProfile =
              UserProfile.fromJson(jsonDecode(response.body));
          _userId = userProfile.user.id;
          _profileId = userProfile.user.profile;
          userProfileInput.add(userProfile);
          profileInput.add(userProfile.user.profile);
          break;

        case 401:
          apiResponseDTO.sendToLogin = true;
          apiResponseDTO.message =
              'Sua sessão expirou.\nPor favor, faça o login novamente.';

          _userProfileController.addError(apiResponseDTO);
          break;
      }
    } on SocketException {
      apiResponseDTO.message =
          'O dispositivo está sem internet, por favor tente novamente';
      _userProfileController.addError(apiResponseDTO);
    } on TimeoutException {
      apiResponseDTO.message =
          'Tempo de conexão excedido, por favor tente novamente';
      _userProfileController.addError(apiResponseDTO);
    } on HttpException {
      apiResponseDTO.message = 'Erro no servidor.';
      _userProfileController.addError(apiResponseDTO);
    }
  }

  Future<ApiResponseDTO> updateUserProfile() async {
    // Emite o sinal para mostrar carregamento
    isLoadingInput.add(true);

    ApiResponseDTO apiResponseDTO = new ApiResponseDTO();

    Map<String, dynamic> body = {
      "userId": _userId,
      "profileId": _profileId,
    };

    try {
      Response response = await ApiService.makeRequest(
        method: "UPDATE",
        body: jsonEncode(body),
        uri: "/profiles",
        sendToken: true,
      );

      apiResponseDTO.statusCode = response.statusCode;

      switch (response.statusCode) {
        case 200:
          apiResponseDTO.title = 'Sucesso';
          apiResponseDTO.message = 'Permissão alterada.';
          break;

        case 400:
          apiResponseDTO.message = jsonDecode(response.body)['error'];
          break;

        case 401:
          apiResponseDTO.sendToLogin = true;
          apiResponseDTO.message =
              'Sua sessão expirou.\nPor favor, faça o login novamente.';
          break;

        case 403:
          apiResponseDTO.message = "Você não possui permissão para fazer isso.";
          break;
      }
    } on SocketException {
      apiResponseDTO.message = 'O dispositivo está sem internet';
    } on TimeoutException {
      apiResponseDTO.message = 'Tempo de conexão excedido.';
    } on HttpException {
      apiResponseDTO.message = 'Erro no servidor.';
    }

    // Emite o sinal para não mostrar carregamento
    isLoadingInput.add(false);

    return apiResponseDTO;
  }

  changeProfileId(int profileId) {
    _profileId = profileId;
    profileInput.add(profileId);
  }

  @override
  void dispose() {
    _isLoadingController.close();
    _userProfileController.close();
    _profileController.close();
    super.dispose();
  }
}
