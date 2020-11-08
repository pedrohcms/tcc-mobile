import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/models/Farm.dart';
import 'package:mobile/src/pages/FarmListPage/FarmListBloc.dart';
import 'package:mobile/src/providers/FarmProvider.dart';
import 'package:mobile/src/services/TokenService.dart';
import 'package:provider/provider.dart';

class FarmListPage extends StatefulWidget {
  @override
  _FarmListPageState createState() => _FarmListPageState();
}

class _FarmListPageState extends State<FarmListPage> {
  final FarmListBloc _farmListBloc = new FarmListBloc();

  @override
  void initState() {
    super.initState();
    _farmListBloc.index();
  }

  @override
  void dispose() {
    _farmListBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        "Adicionar Fazenda",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/register_farm",
                    );
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
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      Text(
                        "Adicionar Usuário",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/register_user",
                    );
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

                    Navigator.popAndPushNamed(context, '/');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Lista de Fazendas",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: StreamBuilder<List<Farm>>(
          stream: _farmListBloc.farmListOutput,
          builder: (context, snapshot) {
            // CASO NÃO TENHA INFORMAÇÕES MOSTRAMOS CARREGAMENTO
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Carregando",
                      style: TextStyle(fontSize: 25.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              ApiResponseDTO apiResponseDTO = ApiResponseDTO.fromJson(
                snapshot.error,
              );

              // NESSE CASO VAMOS MANDAR O USUÁRIO PARA O LOGIN
              if (apiResponseDTO.sendToLogin) {
                return Center(
                  child: Column(
                    children: [
                      Text("${apiResponseDTO.message}"),
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          TokenService.deleteToken();

                          Navigator.popAndPushNamed(context, '/');
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${apiResponseDTO.message}"),
                      FlatButton(
                        child: Text('Tentar novamente'),
                        onPressed: () {
                          _farmListBloc.index();
                        },
                      ),
                    ],
                  ),
                );
              }
            }

            // CASO NÃO VENHA FAZENDAS NA RESPOSTA
            if (snapshot.data.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Você não está vinculado a nenhuma fazenda",
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // CASO TENHA DADO CERTO MONTAMOS O LISTVIEW
            return ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[200],
                  child: ListTile(
                    onTap: () {
                      // MONTAMOS A INSTÂNCIA DO FARM NO PROVIDER
                      context.read<FarmProvider>().farm = snapshot.data[index];

                      Navigator.pushNamed(context, '/home');
                    },
                    title: Text(
                      "${snapshot.data[index].name}",
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      "${snapshot.data[index].address}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 5,
                );
              },
              itemCount: snapshot.data.length,
            );
          },
        ),
      ),
    );
  }
}
