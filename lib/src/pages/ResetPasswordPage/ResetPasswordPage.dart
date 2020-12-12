import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/components/AlertBoxComponent.dart';
import 'package:mobile/src/pages/ResetPasswordPage/ResetPasswordBloc.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final ResetPasswordBloc _resetPasswordBloc = new ResetPasswordBloc();
  final _formkey = GlobalKey<FormState>();

  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _passwordConfirmationFieldController = TextEditingController();

  @override
  void dispose() {
    _resetPasswordBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Esqueceu sua senha?",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 1, left: 40, right: 40),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400,
                  height: 300,
                  child: Image(
                    image: AssetImage('images/recu_senha.png'),
                  ),
                ),
                Container(
                  width: double.infinity,
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
                        return 'Por favor, insira um campo de E-mail válido.';
                      }
                      return null;
                    },
                    controller: _emailFieldController,
                  ),
                ), //campo email
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: StreamBuilder<bool>(
                      stream: _resetPasswordBloc.passwordFieldVisibilityOutput,
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
                                _resetPasswordBloc
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Insira uma senha válida.';
                            }
                            return null;
                          },
                          controller: _passwordFieldController,
                        );
                      }),
                ), //campo senha
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: StreamBuilder<bool>(
                      stream: _resetPasswordBloc
                          .passwordConfirmationFieldVisibilityOutput,
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
                                _resetPasswordBloc
                                    .changePasswordConfirmationFieldVisibility();
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
                            hintText: "Confirmar Senha",
                            filled: true,
                            fillColor: Colors.white54,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor, insira uma senha válida.';
                            } else if (_passwordFieldController.text !=
                                _passwordConfirmationFieldController.text) {
                              return 'O valor dos campos de senha devem ser iguais.';
                            }
                            return null;
                          },
                          controller: _passwordConfirmationFieldController,
                        );
                      }),
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
                        Color.fromRGBO(0, 0, 139, 100),
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(60),
                    ),
                  ),
                  child: SizedBox.expand(
                    child: FlatButton(
                      child: StreamBuilder<bool>(
                        stream: _resetPasswordBloc.isLoadingOutput,
                        initialData: false,
                        builder: (context, snapshot) {
                          if (!snapshot.data) {
                            return Text(
                              "Salvar",
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
                        if (_formkey.currentState.validate()) {
                          ApiResponseDTO result =
                              await _resetPasswordBloc.resetPassword(
                            _emailFieldController.text,
                            _passwordFieldController.text,
                            _passwordConfirmationFieldController.text,
                          );

                          showDialog(
                            context: context,
                            builder: (_) => AlertBoxComponent(data: result),
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
