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

  StreamController<DateTimeRange> _dateTimeRangeStream =
      new StreamController<DateTimeRange>();
  Sink<DateTimeRange> get dateTimeRangeInput => _dateTimeRangeStream.sink;
  Stream<DateTimeRange> get dateTimeRangeOutput => _dateTimeRangeStream.stream;

  StreamController<double> _summedMeasuresStream =
      new StreamController<double>();
  Sink<double> get summedMeasuresInput => _summedMeasuresStream.sink;
  Stream<double> get summedMeasuresOutput => _summedMeasuresStream.stream;

  StreamController<List<Measure>> _measuresListStream =
      new StreamController<List<Measure>>();
  Sink<List<Measure>> get measuresInput => _measuresListStream.sink;
  Stream<List<Measure>> get measuresOutput => _measuresListStream.stream;

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

          List<Measure> measures = convertBodyToMeasures(response);

          measuresInput.add(measures);
          summedMeasuresInput.add(sumMeasures(measures));

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

  List<Measure> convertBodyToMeasures(Response response) {
    List<dynamic> reponseBody = jsonDecode(response.body);

    List<Measure> measures = [];

    reponseBody.forEach((item) {
      Measure measure = Measure.fromJson(item);
      measures.add(measure);
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
