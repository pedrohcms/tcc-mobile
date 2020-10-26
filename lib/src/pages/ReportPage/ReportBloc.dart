import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/models/Measure.dart';
import 'package:mobile/src/services/ApiService.dart';
import 'package:rxdart/rxdart.dart';

class ReportBloc extends ChangeNotifier {
  DateTimeRange dateTimeRange;
  bool _isLoading = false;

  /// STREAM RESPONSÁVEL POR ANOTAR SE A TELA ESTÁ CARREGANDO
  StreamController<bool> _isLoadingStream = new StreamController<bool>();
  Sink<bool> get isLoadingInput => _isLoadingStream.sink;
  Stream<bool> get isLoadingOutput => _isLoadingStream.stream;

  /// STREAM RESPONSÁVEL POR GRAVAR O INTERVALO DE DATA SELECIONANDO
  BehaviorSubject<DateTimeRange> _dateTimeRangeStream =
      new BehaviorSubject<DateTimeRange>();
  Sink<DateTimeRange> get dateTimeRangeInput => _dateTimeRangeStream.sink;
  Stream<DateTimeRange> get dateTimeRangeOutput => _dateTimeRangeStream.stream;

  /// STREAM RESPONSÁVEL POR GRAVAR A SOMATÓRIA DAS MEDIDAS
  BehaviorSubject<double> _summedMeasuresStream = new BehaviorSubject<double>();
  Sink<double> get summedMeasuresInput => _summedMeasuresStream.sink;
  Stream<double> get summedMeasuresOutput => _summedMeasuresStream.stream;

  /// STREAM RESPONSÁVEL POR GRAVAR A MEDIDAS RETORNADAS DA API
  BehaviorSubject<List<Measure>> _measuresListStream =
      new BehaviorSubject<List<Measure>>();
  Sink<List<Measure>> get measuresInput => _measuresListStream.sink;
  Stream<List<Measure>> get measuresOutput => _measuresListStream.stream;

  /// MÉTODO RESPONSÁVEL POR BUSCAR AS MEDIDAS NA API
  Future<ApiResponseDTO> getMeasures(
    DateTimeRange pickedDateTimeRange,
    int farmId,
  ) async {
    _isLoading = !_isLoading;
    isLoadingInput.add(_isLoading);

    this.dateTimeRange = pickedDateTimeRange;

    // CRIANDO AS QUERIES QUE SÃO ENVIADAS PARA API
    Map<String, dynamic> queries = {
      "farm_id": farmId,
      "startDate": pickedDateTimeRange.start,
      "endDate": pickedDateTimeRange.end,
      "orderBy": "asc",
      "queryType": "GROUP",
    };

    Response response;
    ApiResponseDTO apiResponseDTO = ApiResponseDTO();

    try {
      response = await ApiService.makeRequest(
        method: 'GET',
        uri: 'measurements',
        queries: queries,
      );

      apiResponseDTO.statusCode = response.statusCode;

      switch (response.statusCode) {
        case 200:
          apiResponseDTO.title = "";

          // CONVERTENDO O RESULTADO DA API
          List<Measure> measures = convertBodyToMeasures(response);

          // ALIMENTANDO A STREAM DE MEDIDAS
          measuresInput.add(measures);

          // ALIMENTANDO A STREAM DE SOMAS
          summedMeasuresInput.add(sumMeasures(measures));

          // ALIMENTANDO A STREAM DE DATAS
          dateTimeRangeInput.add(pickedDateTimeRange);
          break;
        case 400:
          apiResponseDTO.data = jsonDecode(response.body);
          _isLoadingStream.addError(apiResponseDTO);
          break;
      }
    } on SocketException {
      apiResponseDTO.message = 'O dispositivo está sem internet';
      _isLoadingStream.addError(apiResponseDTO);
    } on TimeoutException {
      apiResponseDTO.message = 'O tempo de conexão foi excedido';
      _isLoadingStream.addError(apiResponseDTO);
    } on HttpException {
      apiResponseDTO.message = 'Erro no servidor';
      _isLoadingStream.addError(apiResponseDTO);
    }

    _isLoading = !_isLoading;
    isLoadingInput.add(_isLoading);

    return apiResponseDTO;
  }

  List<Measure> convertBodyToMeasures(Response response) {
    List<dynamic> reponseBody = jsonDecode(response.body);

    List<Measure> measures = [];

    reponseBody.forEach((item) {
      measures.add(Measure.fromJson(item));
    });

    return measures;
  }

  double sumMeasures(List<Measure> measures) {
    double result = 0.0;

    measures.forEach((measure) {
      result += measure.sum;
    });

    return result;
  }

  @override
  void dispose() {
    _isLoadingStream.close();
    _dateTimeRangeStream.close();
    _summedMeasuresStream.close();
    _measuresListStream.close();
    super.dispose();
  }
}
