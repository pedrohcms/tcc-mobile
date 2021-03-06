import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:mobile/src/services/TokenService.dart';

class ApiService {
  static final String _baseUrl = 'http://10.0.0.167:3333/v1';
  static final int _timeOut = 20;

  /// Responsible for making the request to the API
  ///
  /// Can throw the following exceptions:
  ///
  /// [SocketException] in case the device does not have internet connection;
  ///
  /// [TimeoutException] in case the API takes to long to respond;
  ///
  /// [FormatException] in case the method param is diferent then GET, POST, UPDATE or DELETE;
  ///
  /// [HttpException] in case the server responds with 500/Internal Server Error status;
  static Future<Response> makeRequest({
    String method,
    String uri,
    String body,
    Map<String, dynamic> headers,
    Map<String, dynamic> queries,
    bool sendToken = false,
  }) async {
    // Checking for internet connection
    await InternetAddress.lookup('google.com');

    // Setting up the URL
    String url = '$_baseUrl/$uri' + ApiService.makeQuery(queries);

    // Setting request type
    if (headers == null) {
      headers = new Map<String, String>();
    }

    headers['Content-Type'] = 'application/json; charset=utf-8';
    headers['Accept-Language'] = 'pt-BR';

    if (sendToken) {
      String token = await TokenService.getToken() ?? "";

      headers['Authorization'] = "Bearer $token";
    }

    Response response;

    // Sending the request
    switch (method) {
      case 'GET':
        response = await get(url, headers: headers).timeout(
          Duration(seconds: _timeOut),
          onTimeout: () {
            throw TimeoutException('Connection timed out');
          },
        );
        break;

      case 'POST':
        response = await post(url, body: body, headers: headers).timeout(
          Duration(seconds: _timeOut),
          onTimeout: () {
            throw TimeoutException('Connection timed out');
          },
        );
        break;

      case 'UPDATE':
        response = await put(url, body: body, headers: headers).timeout(
          Duration(seconds: _timeOut),
          onTimeout: () {
            throw TimeoutException('Connection timed out');
          },
        );
        break;

      case 'DELETE':
        response = await delete(url, headers: headers).timeout(
          Duration(seconds: _timeOut),
          onTimeout: () {
            throw TimeoutException('Connection timed out');
          },
        );
        break;

      default:
        throw new FormatException('Method not found');
        break;
    }

    if (response.statusCode == 500) {
      throw new HttpException('Internal Server Error');
    }

    return response;
  }

  static String makeQuery(Map<String, dynamic> queries) {
    if (queries == null) {
      return '';
    }

    String query = '?';

    queries.forEach((key, value) {
      query += '$key=$value&';
    });

    return query;
  }
}
