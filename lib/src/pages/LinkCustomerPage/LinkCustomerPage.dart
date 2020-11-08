import 'package:flutter/material.dart';

class LinkCustomerPage extends StatefulWidget {
  @override
  _LinkCustomerPageState createState() => _LinkCustomerPageState();
}

class _LinkCustomerPageState extends State<LinkCustomerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Vincular novo cliente",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 1,
          left: 40,
          right: 40,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              child: TextFormField(
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(60.0),
                    ),
                  ),
                  hintStyle: TextStyle(
                    fontSize: 13,
                    height: 1,
                  ),
                  hintText: "E-mail",
                  filled: true,
                  fillColor: Colors.white54,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [
                    Color.fromRGBO(0, 0, 255, 100),
                    Color.fromRGBO(0, 0, 252, 150),
                  ],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(60.0),
                ),
              ),
              child: SizedBox.expand(
                child: FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Vincular",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      Text("Pedro Henrique Correa Mota da Silva"),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Divider(
                    thickness: 2.0,
                    color: Colors.grey[300],
                    height: 0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
