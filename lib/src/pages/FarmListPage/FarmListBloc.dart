import 'package:flutter/foundation.dart';
import 'package:mobile/src/models/Farm.dart';
import 'package:mobile/src/services/ApiService.dart';
import 'package:http/http.dart';

class FarmListBloc extends ChangeNotifier {
  index() async {
    ApiService apiService = new ApiService();
    Response response = await apiService.makeRequest(
        method: "GET", uri: "/farms", sendToken: true);
    print(response.body);

    List<Farm> farms = new List<Farm>();
  }
}
