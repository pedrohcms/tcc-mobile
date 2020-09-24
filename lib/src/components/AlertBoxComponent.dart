import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/services/TokenService.dart';

class AlertBoxComponent extends StatelessWidget {
  final ApiResponseDTO data;

  AlertBoxComponent({this.data});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: new Text(this.data.title),
      content: new Text(this.data.message),
      actions: <Widget>[
        Builder(
          builder: (context) {
            if (this.data.sendToLogin) {
              return FlatButton(
                child: Text('OK'),
                onPressed: () {
                  TokenService.deleteToken();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (Route<dynamic> route) => false,
                  );
                },
              );
            }

            return FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ],
    );
  }
}
