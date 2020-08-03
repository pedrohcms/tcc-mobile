import 'package:dio/dio.dart';

class ApiService {
  Dio _dio;

  ApiService() {
    Dio dio = new Dio();
    dio.options.baseUrl = 'http://10.0.0.167:3333';

    this._dio = dio;
  }

  String makeQuery(Map<String, dynamic> queries) {
    String query = '?';

    queries.forEach((key, value) {
      query += '$key=$value&';
    });

    return query;
  }

  Dio getDio() {
    return this._dio;
  }
}
