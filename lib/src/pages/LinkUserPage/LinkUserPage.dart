import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/components/AlertBoxComponent.dart';
import 'package:mobile/src/models/Farm.dart';
import 'package:mobile/src/models/User.dart';
import 'package:mobile/src/pages/LinkUserPage/LinkUserBloc.dart';
import 'package:mobile/src/providers/FarmProvider.dart';
import 'package:mobile/src/services/TokenService.dart';
import 'package:provider/provider.dart';

class LinkUserPage extends StatefulWidget {
  @override
  _LinkUserPageState createState() => _LinkUserPageState();
}

class _LinkUserPageState extends State<LinkUserPage> {
  LinkUserBloc _linkUserBloc = LinkUserBloc();
  Farm _farm;
  final _formKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController();

  void getLinkedUsers() {
    _linkUserBloc.getLinkedUsers(_farm.id);
  }

  void getFarmFromContext(BuildContext context) {
    this._farm = context.watch<FarmProvider>().farm;
  }

  @override
  void dispose() {
    _linkUserBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getFarmFromContext(context);
    getLinkedUsers();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Vincular novo usuário",
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: TextFormField(
                      validator: (value) {
                        if (!EmailValidator.validate(value))
                          return 'Por favor insira um e-mail válido';

                        return null;
                      },
                      controller: _emailFieldController,
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
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            ApiResponseDTO result =
                                await _linkUserBloc.linkUserFarm(
                              this._farm.address,
                              _emailFieldController.text,
                            );

                            showDialog(
                              context: context,
                              builder: (_) => AlertBoxComponent(data: result),
                            );

                            if (result.statusCode == 201) getLinkedUsers();
                          }
                        },
                        child: StreamBuilder<bool>(
                          stream: _linkUserBloc.isLoadingOutput,
                          initialData: false,
                          builder: (context, snapshot) {
                            if (!snapshot.data) {
                              return Text(
                                "Vincular",
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<List<User>>(
                stream: _linkUserBloc.linkedUsersOutput,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    ApiResponseDTO apiResponseDTO = ApiResponseDTO.fromJson(
                      snapshot.error,
                    );

                    // NESSE CASO VAMOS MANDAR O USUÁRIO PARA O LOGIN
                    if (apiResponseDTO.sendToLogin) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            Text(
                              "${apiResponseDTO.message}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                              ),
                              child: FlatButton(
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () {
                                  TokenService.deleteToken();

                                  Navigator.popAndPushNamed(context, '/');
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            Text(
                              "${apiResponseDTO.message}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                              ),
                              child: FlatButton(
                                child: Text(
                                  'Tentar novamente',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () {
                                  _linkUserBloc.getLinkedUsers(this._farm.id);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }

                  if (!snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    );
                  }

                  // CASO TUDO DÊ CERTO
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(snapshot.data[index].name),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              ApiResponseDTO result = new ApiResponseDTO();

                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) {
                                  return CupertinoAlertDialog(
                                    title: Text(
                                      "Tem certeza que deseja desvincular o usuário?",
                                    ),
                                    actions: [
                                      FlatButton(
                                        child: Text('Sim'),
                                        onPressed: () async {
                                          result = await _linkUserBloc
                                              .deleteUserFarmLink(
                                            this._farm.address,
                                            snapshot.data[index].email,
                                          );

                                          Navigator.of(context).pop();

                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                AlertBoxComponent(data: result),
                                          );

                                          if (result.statusCode == 200)
                                            getLinkedUsers();
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        thickness: 2.0,
                        color: Colors.grey[300],
                        height: 0,
                      );
                    },
                    itemCount: snapshot.data.length,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
