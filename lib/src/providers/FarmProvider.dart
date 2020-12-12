import 'package:flutter/material.dart';
import 'package:mobile/src/models/Farm.dart';

class FarmProvider extends ChangeNotifier {
  Farm farm;

  FarmProvider({this.farm});
}
