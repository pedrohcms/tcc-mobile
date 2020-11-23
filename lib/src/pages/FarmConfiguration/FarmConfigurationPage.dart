import 'package:flutter/material.dart';
import 'package:mobile/src/services/TokenService.dart';

enum SingingCharacter { alimentacao, energia, combustivel }

class FarmConfigurationPage extends StatefulWidget {
  @override
  _FarmConfigurationPageState createState() => _FarmConfigurationPageState();
}

class _FarmConfigurationPageState extends State<FarmConfigurationPage> {
  SingingCharacter _character = SingingCharacter.alimentacao;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Cálculos da Fazenda",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 1,
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
            SizedBox(
              width: 200,
              height: 250,
              child: Image(
                image: AssetImage('images/relatorio.png'),
              ),
            ),
            SizedBox(
              height: 10,
            ), //espaço entre a imagem e o campo de texto

            ListTile(
              title: Text('Alimentação da Bomba', textAlign: TextAlign.center),
            ),
            ListTile(
              title: Text('Energia Elétrica'),
              leading: Radio(
                value: SingingCharacter.energia,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Combustível'),
              leading: Radio(
                value: SingingCharacter.combustivel,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),

            Form(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: TextFormField(
                      // campo email
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
                        hintText:
                            "Quantidade total gasta com a alimentação da bomba",
                        filled: true,
                        fillColor: Colors.white54,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Por favor inserir um valor válido';
                        }
                        return null;
                      },
                    ),
                  ), //campo email
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: TextFormField(
                      // campo senha
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
                        hintText: "Preço da unidade, seja watts ou litros",
                        filled: true,
                        fillColor: Colors.white54,
                      ),
                      //campo
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Por favor inserir um valor correspondente';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ), //campo senha

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
                        Radius.circular(60),
                      ),
                    ),
                    child: SizedBox.expand(
                      child: FlatButton(
                          child: StreamBuilder<bool>(
                            initialData: false,
                            builder: (context, snapshot) {
                              if (!snapshot.data) {
                                return Text(
                                  "Calcular",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }

                              return CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              );
                            },
                          ),
                          onPressed: () async {}),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ), //o listView serve para fixar as coisas na página(teclado sobresair)
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
                child: FlatButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: Colors.white,
                      ),
                      Text(
                        "Relatórios",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/report');
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      Text(
                        "Home",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/home");
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      Text(
                        "Logout",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    TokenService.deleteToken();

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
