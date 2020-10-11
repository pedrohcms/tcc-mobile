import 'package:flutter/material.dart';
import 'package:mobile/src/models/User.dart';

class UserProvider extends ChangeNotifier {
  User user;

  UserProvider({this.user});
}
