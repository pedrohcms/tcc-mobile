import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/models/Measure.dart';
import 'package:mobile/src/services/ApiService.dart';

class ReportBloc extends ChangeNotifier {
  DateTimeRange dateTimeRange;
  bool _isLoading = false;

  StreamController<bool> _isLoadingStream = new StreamController<bool>();
  Sink<bool> get isLoadingInput => _isLoadingStream.sink;
  Stream<bool> get isLoadingOutput => _isLoadingStream.stream;

  StreamController<DateTimeRange> _dateTimeRange =
      new StreamController<DateTimeRange>();
  Sink<DateTimeRange> get dateTimeRangeInput => _dateTimeRange.sink;
  Stream<DateTimeRange> get dateTimeRangeOutput => _dateTimeRange.stream;

  StreamController<double> _summedMeasures = new StreamController<double>();
  Sink<double> get summedMeasuresInput => _summedMeasures.sink;
  Stream<double> get summedMeasuresOutput => _summedMeasures.stream;

  Future<ApiResponseDTO> getMeasures(
    DateTimeRange pickedDateTimeRange,
    int farmId,
  ) async {
    _isLoading = !_isLoading;
    isLoadingInput.add(_isLoading);

    this.dateTimeRange = pickedDateTimeRange;
    dateTimeRangeInput.add(pickedDateTimeRange);

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

          apiResponseDTO.data = convertBodyToMap(response);

          summedMeasuresInput.add(sumMeasures(response));

          break;
        case 400:
          apiResponseDTO.data = jsonDecode(response.body)["error"];
          break;
      }
    } on SocketException {
      apiResponseDTO.message = 'O dispositivo está sem internet';
    } on TimeoutException {
      apiResponseDTO.message = 'O tempo de conexão foi excedido';
    } on HttpException {
      apiResponseDTO.message = 'Erro no servidor';
    }

    isLoadingInput.add(!_isLoading);

    return apiResponseDTO;
  }

  Map<String, dynamic> convertBodyToMap(Response response) {
    List<dynamic> reponseBody = jsonDecode(response.body);

    Map<String, dynamic> convertedBody = {};

    reponseBody.forEach((item) {
      Measure measure = Measure.fromJson(item);
      convertedBody[measure.startDate] = measure.sum;
    });

    return convertedBody;
  }

  double sumMeasures(Response response) {
    List<dynamic> reponseBody = jsonDecode(response.body);

    double result = 0.0;

    reponseBody.forEach((item) {
      result += Measure.fromJson(item).sum;
    });

    return result;
  }

  @override
  void dispose() {
    _isLoadingStream.close();
    _dateTimeRange.close();
    _summedMeasures.close();
    super.dispose();
  }
}
