import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/src/models/Farm.dart';
import 'package:mobile/src/pages/FarmListPage/FarmListBloc.dart';

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
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        "Adicionar Usuário",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.white),
                      Text(
                        "Logout",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {},
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

            return ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[200],
                  child: ListTile(
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
