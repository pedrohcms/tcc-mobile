import 'dart:convert';
import 'package:mobile/src/models/User.dart';
import 'package:mobile/src/services/ApiService.dart';
import 'package:dio/dio.dart';

class SessionService extends ApiService {
  String get resource => '/sessions';

  SessionService() : super();

  Future<Response> store(User user) async {
    return await this.getDio().post(
          resource,
          data: jsonEncode(user),
        );
  }
}
