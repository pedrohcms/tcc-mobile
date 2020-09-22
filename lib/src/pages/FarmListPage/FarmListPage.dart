import 'package:flutter/material.dart';
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
          child: ListView(
        children: <Widget>[
          Container(
            color: Colors.grey[200],
            child: ListTile(
              title: Text(
                "Fazenda Campo Verde",
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                "Endereço 01",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: Colors.grey[200],
            child: ListTile(
              title: Text(
                "Fazenda 2 Irmãos",
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                "Endereço 02",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: Colors.grey[200],
            child: ListTile(
              title: Text(
                "Fazenda Cana de Açúcar",
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                "Endereço 03",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: Colors.grey[200],
            child: ListTile(
              title: Text(
                "Fazenda Leiteira",
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                "Endereço 04",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: Colors.grey[200],
            child: ListTile(
              title: Text(
                "Fazenda Paulista",
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                "Endereço 05",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
