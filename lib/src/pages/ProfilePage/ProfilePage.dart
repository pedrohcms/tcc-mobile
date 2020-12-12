import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/components/AlertBoxComponent.dart';
import 'package:mobile/src/components/CustomBottomAppBarComponent/CustomBottomAppBarComponent.dart';
import 'package:mobile/src/models/Profile.dart';
import 'package:mobile/src/models/User.dart';
import 'package:mobile/src/models/UserProfile.dart';
import 'package:mobile/src/pages/ProfilePage/ProfileBloc.dart';
import 'package:mobile/src/services/TokenService.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileBloc _profileBloc = ProfileBloc();
  final _formKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController();

  @override
  void dispose() {
    _profileBloc.dispose();
    super.dispose();
  }

  List<ListTile> getOptions(List<Profile> profiles) {
    List<ListTile> items = [];

    profiles.forEach((element) {
      items.add(
        ListTile(
          title: Text(
            element.name,
          ),
          leading: Radio(
            value: element.id,
            groupValue: profiles,
            onChanged: (value) {},
          ),
        ),
      );
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Gerenciar permissões",
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
                            _profileBloc
                                .getUserProfile(_emailFieldController.text);

                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        },
                        child: StreamBuilder<bool>(
                          stream: _profileBloc.isLoadingOutput,
                          initialData: false,
                          builder: (context, snapshot) {
                            if (!snapshot.data) {
                              return Text(
                                "Buscar",
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
              child: StreamBuilder<UserProfile>(
                stream: _profileBloc.userProfileOutput,
                initialData: UserProfile(
                  user: User(id: 0),
                ),
                builder: (context, userProfileSnapshot) {
                  if (userProfileSnapshot.hasError) {
                    ApiResponseDTO apiResponseDTO = ApiResponseDTO.fromJson(
                      userProfileSnapshot.error,
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
                          ],
                        ),
                      );
                    }
                  }

                  if (!userProfileSnapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    );
                  }

                  if (userProfileSnapshot.data.user.id == 0) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Primeiro busque por um usuário'),
                      ],
                    );
                  }

                  // CASO TUDO DÊ CERTO
                  return ListView(
                    children: [
                      Column(
                        children: [
                          Text(
                            userProfileSnapshot.data.user.name,
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            userProfileSnapshot.data.user.email,
                            style: TextStyle(fontSize: 15),
                          ),
                          ListTile(
                            title: Text(
                              'Marque a opção desejada',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          StreamBuilder<int>(
                            stream: _profileBloc.profileOutput,
                            builder: (context, snapshot) {
                              List<ListTile> items = [];

                              userProfileSnapshot.data.profiles.forEach(
                                (element) {
                                  items.add(
                                    ListTile(
                                      title: Text(
                                        element.name,
                                      ),
                                      leading: Radio<int>(
                                        value: element.id,
                                        groupValue: snapshot.data,
                                        onChanged: (int value) {
                                          _profileBloc.changeProfileId(value);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );

                              return Column(
                                children: items,
                              );
                            },
                          ),
                          SizedBox(
                            height: 6,
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
                                        await _profileBloc.updateUserProfile();

                                    showDialog(
                                      context: context,
                                      builder: (_) =>
                                          AlertBoxComponent(data: result),
                                    );
                                  }

                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                child: StreamBuilder<bool>(
                                  stream: _profileBloc.isLoadingOutput,
                                  initialData: false,
                                  builder: (context, snapshot) {
                                    if (!snapshot.data) {
                                      return Text(
                                        "Confirmar",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      );
                                    }

                                    return CircularProgressIndicator(
                                      backgroundColor: Colors.grey,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomAppBarComponent(),
    );
  }
}
