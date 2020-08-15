import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool passwordFieldVisibility = true;
  bool passwordConfirmationFieldVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
          child: Column(
            children: [
              Text("Esqueceu sua senha?"),
              Container(
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
                      fillColor: Colors.white54),
                ),
              ), //campo email
              SizedBox(
                height: 10,
              ),
              Container(
                height: 45,
                alignment: Alignment.center,
                child: TextFormField(
                  // campo senha
                  obscureText: passwordFieldVisibility,
                  decoration: new InputDecoration(
                      suffixIcon: IconButton(
                        icon: (passwordFieldVisibility
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility)),
                        onPressed: () {
                          setState(() {
                            passwordFieldVisibility = !passwordFieldVisibility;
                          });
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
                      fillColor: Colors.white54),
                ),
              ), //campo senha
              SizedBox(
                height: 10,
              ),
              Container(
                height: 45,
                alignment: Alignment.center,
                child: TextFormField(
                  // campo senha
                  obscureText: passwordConfirmationFieldVisibility,
                  decoration: new InputDecoration(
                      suffixIcon: IconButton(
                        icon: (passwordConfirmationFieldVisibility
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility)),
                        onPressed: () {
                          setState(() {
                            passwordConfirmationFieldVisibility =
                                !passwordConfirmationFieldVisibility;
                          });
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
                      fillColor: Colors.white54),
                ),
              ),
              SizedBox(
                height: 10,
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
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
