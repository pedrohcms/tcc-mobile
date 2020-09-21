import 'package:flutter/material.dart';
import 'package:mobile/src/pages/FarmListPage/FarmListPage.dart';
import 'package:mobile/src/pages/RegisterFarmPage/RegisterFarmPage.dart';
import 'package:mobile/src/pages/LoginPage/LoginPage.dart';
import 'package:mobile/src/pages/ResetPasswordPage/ResetPasswordPage.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Irrigação Simplificado',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context) => LoginPage(),
        "/reset_password": (context) => ResetPasswordPage(),
        "/register_farm": (context) => RegisterFarmPage()
      },
    );
  }
}
