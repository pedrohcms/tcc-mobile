import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/components/AlertBoxComponent.dart';
import 'package:mobile/src/pages/RegisterUserPage/RegisterUserBloc.dart';

class RegisterUserPage extends StatefulWidget {
  @override
  _RegisterUserPageState createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final RegisterUserBloc _registerUserBloc = new RegisterUserBloc();

  final _formKey = GlobalKey<FormState>();
  final _nameFieldController = TextEditingController();
  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _passwordConfimationFieldController = TextEditingController();

  @override
  void dispose() {
    _registerUserBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Cadastro de Usuário",
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
                        hintText: "Email",
                        filled: true,
                        fillColor: Colors.white54,
                      ),
                      validator: (value) {
                        if (!EmailValidator.validate(value)) {
                          return 'Por favor inserir um email válido';
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
                        stream: _registerUserBloc.passwordFieldVisibilityOutput,
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
                                  _registerUserBloc
                                      .changePasswordFieldVisibility();
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
                                return 'Por favor inserir uma senha válida';
                              } else if (value.length < 4) {
                                return 'A senha deve ter no mínimo 4 caracteres';
                              }
                              return null;
                            },
                            controller: _passwordFieldController,
                          );
                        }),
                  ),
                  SizedBox(
                    height: 30,
                  ), //campo senha
                  Container(
                    alignment: Alignment.center,
                    child: StreamBuilder<bool>(
                        stream: _registerUserBloc.passwordFieldVisibilityOutput,
                        initialData: true,
                        builder: (context, snapshot) {
                          return TextFormField(
                            // campo senha
                            obscureText: snapshot.data,
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
                              hintText: "Confirmar Senha",
                              filled: true,
                              fillColor: Colors.white54,
                            ),
                            //campo
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Por favor inserir uma senha válida';
                              } else if (value !=
                                  _passwordFieldController.text) {
                                return 'O valor dos campos de senha devem ser iguais.';
                              }
                              return null;
                            },
                            controller: _passwordConfimationFieldController,
                          );
                        }),
                  ),
                  SizedBox(
                    height: 30,
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
                          stream: _registerUserBloc.isLoadingOutput,
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
                            ApiResponseDTO result =
                                await _registerUserBloc.store(
                                    _nameFieldController.text,
                                    _emailFieldController.text,
                                    _passwordFieldController.text);

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
