import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mobile/src/pages/LoginPage/LoginBloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final LoginBloc _loginBloc = new LoginBloc();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Sistema de Irrigação Simplificado",
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
            SizedBox(
              width: 250,
              height: 100,
              child: Image(
                image: AssetImage('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 80,
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
                          hintText: "E-mail",
                          filled: true,
                          fillColor: Colors.white54,
                        ),
                        validator: (value) {
                          if (value.isEmpty ||
                              !EmailValidator.validate(value)) {
                            return 'Por favor inserir um campo de E-mail válido';
                          }
                          return null;
                        },
                        controller: _emailFieldController,
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
                          hintText: "Senha",
                          filled: true,
                          fillColor: Colors.white54,
                        ),
                        //campo
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Por favor inserir a senha correta';
                          }
                          return null;
                        },
                        controller: _passwordFieldController,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ), //campo senha
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: FlatButton(
                        child: Text(
                          "Recuperar Senha",
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/reset_password');
                        },
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
                          Radius.circular(60),
                        ),
                      ),
                      child: SizedBox.expand(
                        child: FlatButton(
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => new CupertinoAlertDialog(
                                      title: new Text("Erro"),
                                      content: new Text(
                                          "O tempo de conexão foi excedido"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('Tentar Novamente'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ));
                            if (_formKey.currentState.validate()) {
                              print("deu certo");
                              _loginBloc.login(_emailFieldController.text,
                                  _passwordFieldController.text);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )),

            SizedBox(
              height: 10,
            ),
          ],
        ), //o listView serve para fixar as coisas na página(teclado sobresair)
      ),
    );
  }
}
