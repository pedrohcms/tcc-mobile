import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertBoxComponent extends StatelessWidget {
  final Map<String, String> data;

  AlertBoxComponent({this.data});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: new Text(this.data['title']),
      content: new Text(this.data['message']),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
