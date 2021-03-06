import 'package:flutter/material.dart';
import 'package:mobile/src/pages/FarmConfiguration/FarmConfigurationPage.dart';
import 'package:mobile/src/pages/HomePage/HomePage.dart';
import 'package:mobile/src/pages/FarmListPage/FarmListPage.dart';
import 'package:mobile/src/pages/LinkUserPage/LinkUserPage.dart';
import 'package:mobile/src/pages/ProfilePage/ProfilePage.dart';
import 'package:mobile/src/pages/RegisterFarmPage/RegisterFarmPage.dart';
import 'package:mobile/src/pages/LoginPage/LoginPage.dart';
import 'package:mobile/src/pages/RegisterUserPage/RegisterUserPage.dart';
import 'package:mobile/src/pages/ReportPage/ReportPage.dart';
import 'package:mobile/src/pages/ResetPasswordPage/ResetPasswordPage.dart';
import 'package:mobile/src/providers/FarmProvider.dart';
import 'package:mobile/src/providers/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FarmProvider>(
          create: (_) => FarmProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Sistema de Irrigação Simplificado',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          "/": (context) => LoginPage(),
          "/reset_password": (context) => ResetPasswordPage(),
          "/register_farm": (context) => RegisterFarmPage(),
          "/farm_list": (context) => FarmListPage(),
          "/home": (context) => HomePage(),
          "/report": (context) => ReportPage(),
          "/register_user": (context) => RegisterUserPage(),
          "/link_customer": (context) => LinkUserPage(),
          "/farm_configuration": (context) => FarmConfigurationPage(),
          "/profile": (context) => ProfilePage(),
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [
          Locale('en', 'US'),
          Locale('pt', 'BR'),
        ],
      ),
    );
  }
}
