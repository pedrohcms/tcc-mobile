import 'package:flutter/material.dart';

class Button {
  String title;
  IconData icon;
  Function onPress;
  String route;

  Button({this.title, this.icon, this.onPress, this.route});
}
