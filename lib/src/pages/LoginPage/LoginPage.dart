import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mobile/src/models/User.dart';
import 'package:provider/provider.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/components/AlertBoxComponent.dart';
import 'package:mobile/src/pages/LoginPage/LoginBloc.dart';
import 'package:mobile/src/providers/UserProvider.dart';

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
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

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
                        if (value.isEmpty || !EmailValidator.validate(value)) {
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
                    child: StreamBuilder<bool>(
                        stream: _loginBloc.passwordFieldVisibilityOutput,
                        initialData: true,
                        builder: (context, snapshot) {
                          return TextFormField(
                            // campo senha
                            obscureText: snapshot.data,
                            decoration: new InputDecoration(
                              suffixIcon: IconButton(
                                icon: (snapshot.data
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off)),
                                onPressed: () {
                                  _loginBloc.changePasswordFieldVisibility();
                                },
                              ),
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
                          );
                        }),
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
                        child: StreamBuilder<bool>(
                          stream: _loginBloc.isLoadingOutput,
                          initialData: false,
                          builder: (context, snapshot) {
                            if (!snapshot.data) {
                              return Text(
                                "Entrar",
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
                            ApiResponseDTO result = await _loginBloc.login(
                              _emailFieldController.text,
                              _passwordFieldController.text,
                            );

                            if (result.statusCode != 200) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertBoxComponent(data: result),
                              );
                            } else {
                              context.read<UserProvider>().user =
                                  User.fromJson(result.data);

                              Navigator.popAndPushNamed(context, '/farm_list');
                            }
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
