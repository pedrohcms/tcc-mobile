import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/src/DTOs/AlertBoxDTO.dart';
import 'package:mobile/src/components/AlertBoxComponent.dart';
import 'package:mobile/src/pages/RegisterFarmPage/RegisterFarmBloc.dart';

class RegisterFarmPage extends StatefulWidget {
  @override
  _RegisterFarmPageState createState() => _RegisterFarmPageState();
}

class _RegisterFarmPageState extends State<RegisterFarmPage> {
  final RegisterFarmBloc _registerFarmBloc = new RegisterFarmBloc();

  final _formKey = GlobalKey<FormState>();
  final _nameFieldController = TextEditingController();
  final _addressFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Cadastro de Fazenda",
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
              width: 300,
              height: 350,
              child: Image(
                image: AssetImage('images/cad_fazenda.png'),
              ),
            ),
            SizedBox(
              height: 10,
            ), //espaço entre a imagem e o campo de texto

            Form(
              key: _formKey,
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
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white54,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Por favor inserir um nome válido';
                        }
                        return null;
                      },
                      controller: _nameFieldController,
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
                        hintText: "Endereço",
                        filled: true,
                        fillColor: Colors.white54,
                      ),
                      //campo
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Por favor inserir um endereço válido';
                        }
                        return null;
                      },
                      controller: _addressFieldController,
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
                          stream: _registerFarmBloc.isLoadingOutput,
                          initialData: false,
                          builder: (context, snapshot) {
                            if (!snapshot.data) {
                              return Text(
                                "Enviar",
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
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            AlertBoxDTO result = await _registerFarmBloc.store(
                              _nameFieldController.text,
                              _addressFieldController.text,
                            );

                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) => AlertBoxComponent(
                                data: result,
                              ),
                            );
                          }
                        },
                      ),
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
    );
  }
}
