import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Recuperação de Senha",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 20,
          left: 40,
          right: 40,
        ),
        //ajuste do padding
        color: Colors.white, //cor de fundo
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),

            Container(
              height: 45,
              alignment: Alignment.center,
              child: TextField(
                // campo email
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(60.0),
                      ),
                    ),
                    hintStyle: TextStyle(
                      fontSize: 13,
                    ),
                    hintText: "E-mail",
                    filled: true,
                    fillColor: Colors.white54),
              ),
            ), //campo email
            SizedBox(
              height: 30,
            ),
            Container(
              height: 45,
              alignment: Alignment.center,
              child: TextField(
                // campo senha
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(60.0),
                      ),
                    ),
                    hintStyle: TextStyle(
                      fontSize: 13,
                    ),
                    hintText: "Senha",
                    filled: true,
                    fillColor: Colors.white54),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 45,
              alignment: Alignment.center,
              child: TextField(
                // campo senha
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(60.0),
                      ),
                    ),
                    hintStyle: TextStyle(
                      fontSize: 13,
                    ),
                    hintText: "Senha",
                    filled: true,
                    fillColor: Colors.white54),
              ),
            ),

            Container(
              height: 30,
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
                  Radius.circular(60),
                ),
              ),
              child: SizedBox.expand(
                child: FlatButton(
                    child: Text(
                      "Recuperar Senha",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {}),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ), //o listView serve para fixar as coisas na página(teclado sobresair)
      ),
    );
  }
}