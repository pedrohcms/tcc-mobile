import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/models/FarmConfiguration.dart';
import 'package:mobile/src/pages/FarmConfiguration/FarmConfigurationPage.dart';
import 'package:mobile/src/services/ApiService.dart';
import 'package:rxdart/rxdart.dart';

class FarmConfigurationBloc extends ChangeNotifier {
  TipoAlimentacao _tipoAlimentacao = TipoAlimentacao.energia;

  /// Stream to controll loading
  StreamController<bool> _isLoadingStream = new StreamController<bool>();
  Sink<bool> get isLoadingInput => _isLoadingStream.sink;
  Stream<bool> get isLoadingOutput => _isLoadingStream.stream;

  /// Stream to controll TipoAlimentacao
  StreamController<TipoAlimentacao> _tipoAlimentacaoStream =
      new StreamController<TipoAlimentacao>();
  Sink<TipoAlimentacao> get tipoAlimentacaoInput => _tipoAlimentacaoStream.sink;
  Stream<TipoAlimentacao> get tipoAlimentacaoOutput =>
      _tipoAlimentacaoStream.stream;

  /// Stream for farm configuration
  BehaviorSubject<FarmConfiguration> _farmConfigurationStream =
      new BehaviorSubject<FarmConfiguration>();
  Sink<FarmConfiguration> get farmConfigurarionInput =>
      _farmConfigurationStream.sink;
  Stream<FarmConfiguration> get farmConfigurarionOutput =>
      _farmConfigurationStream.stream;

  /// Method responsible to save the configuration values of the farm.
  Future<ApiResponseDTO> saveConfiguration(
    int farmId,
    double amount,
    double price,
  ) async {
    isLoadingInput.add(true);

    Map<String, dynamic> body = {
      'engineType':
          this._tipoAlimentacao.index == 0 ? 'eletrico' : 'combustivel',
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

  void getFarmConfiguration(int farmId) async {
    ApiResponseDTO apiResponseDTO = new ApiResponseDTO();

    try {
      Response response = await ApiService.makeRequest(
        method: 'GET',
        uri: 'farm_configuration/$farmId',
        sendToken: true,
      );

      apiResponseDTO.statusCode = response.statusCode;

      switch (apiResponseDTO.statusCode) {
        case 200:
          FarmConfiguration farmConfiguration =
              FarmConfiguration.fromJson(jsonDecode(response.body));

          farmConfigurarionInput.add(farmConfiguration);

          farmConfiguration.engineType == 'eletrico'
              ? changeTipoAlimentacao(TipoAlimentacao.energia)
              : changeTipoAlimentacao(TipoAlimentacao.combustivel);
          break;
        case 400:
          apiResponseDTO.message = jsonDecode(response.body)['error'];
          _farmConfigurationStream.addError(apiResponseDTO);
          break;
        case 401:
          apiResponseDTO.message =
              "Sua sessão expirou por favor faça o login novamente";
          apiResponseDTO.sendToLogin = true;
          _farmConfigurationStream.addError(apiResponseDTO);
          break;
      }
    } on SocketException {
      apiResponseDTO.message = 'O dispositivo está sem internet';
      _farmConfigurationStream.addError(apiResponseDTO);
    } on TimeoutException {
      apiResponseDTO.message = 'O tempo de conexão foi excedido';
      _farmConfigurationStream.addError(apiResponseDTO);
    } on HttpException {
      apiResponseDTO.message = 'Erro no servidor';
      _farmConfigurationStream.addError(apiResponseDTO);
    }
  }

  /// Method responsible for handling the change on the tipoAlimentacao attribute
  void changeTipoAlimentacao(TipoAlimentacao tipoAlimentacao) {
    this._tipoAlimentacao = tipoAlimentacao;
    tipoAlimentacaoInput.add(tipoAlimentacao);
  }

  @override
  void dispose() {
    _isLoadingStream.close();
    _tipoAlimentacaoStream.close();
    _farmConfigurationStream.close();
    super.dispose();
  }
}
