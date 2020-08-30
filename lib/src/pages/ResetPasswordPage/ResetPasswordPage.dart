import 'package:flutter/material.dart';
import 'package:mobile/src/pages/ResetPasswordPage/ResetPasswordBloc.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final ResetPasswordBloc _resetPasswordBloc = new ResetPasswordBloc();

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 45,
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
                    ),
                    hintText: "E-mail",
                    filled: true,
                    fillColor: Colors.white54,
                  ),
                ),
              ), //campo email
              SizedBox(
                height: 20,
              ),
              Container(
                height: 45,
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
                          ),
                          hintText: "Senha",
                          filled: true,
                          fillColor: Colors.white54,
                        ),
                      );
                    }),
              ), //campo senha
              SizedBox(
                height: 20,
              ),
              Container(
                height: 45,
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
                          ),
                          hintText: "Confirmar Senha",
                          filled: true,
                          fillColor: Colors.white54,
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 35,
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
                      child: Text(
                        "Salvar",
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
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
