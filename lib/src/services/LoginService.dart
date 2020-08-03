import 'dart:convert';
import 'package:mobile/src/models/User.dart';
import 'package:mobile/src/services/ApiService.dart';
import 'package:dio/dio.dart';

class LoginService extends ApiService {
  String get resource => '/login';

  LoginService() : super();

  Future<Response> store(User user) async {
    return await this.getDio().post(
          resource,
          data: jsonEncode(user),
        );
  }
}
