import 'package:http/http.dart';

class ApiService {
  final Client _client = new Client();
  final String _baseUrl = 'http://10.0.0.167:3333';

  Future<Response> makeRequest(
      {String method,
      String uri,
      String body,
      Map<String, dynamic> headers,
      Map<String, dynamic> queries}) async {
    // Setting up the URL
    String url = '$_baseUrl/$uri' + makeQuery(queries);

    // Setting request type
    if (headers == null) {
      headers = new Map<String, String>();
    }

    headers['Content-Type'] = 'application/json; charset=utf-8';

    // Sending the request
    switch (method) {
      case 'GET':
        return await _client.get(url, headers: headers);
        break;

      case 'POST':
        return await _client.post(url, body: body, headers: headers);
        break;

      case 'UPDATE':
        return await _client.put(url, body: body, headers: headers);
        break;

      case 'DELETE':
        return await _client.delete(url, headers: headers);
        break;
      default:
        throw new FormatException('Method not found');
    }
  }

  String makeQuery(Map<String, dynamic> queries) {
    if (queries == null) {
      return '';
    }

    String query = '?';

    queries.forEach((key, value) {
      query += '$key=$value&';
    });

    return query;
  }

  void closeClient() {
    _client.close();
  }
}
