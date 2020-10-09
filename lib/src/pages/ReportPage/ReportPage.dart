import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            expandedHeight: 175.0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              //title: Text("Bem vindo a sua propriedade"),
              background:
                  Image.asset('images/relatorio.png', height: 210, width: 210),
            ),
          ),
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 50.0,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Relatórios"),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 150.0,
            delegate: SliverChildListDelegate(
              [
                //PRIMEIRO CONTAINER
                ClipRRect(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue,
                    ),
                  ),
                ),

                //SEGUNDO CONTAINER
                ClipRRect(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue[200],
                    ),
                  ),
                ),

                //TERCEIRO CONTAINER
                ClipRRect(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue[500],
                    ),
                  ),
                ),

                //QUARTO CONTAINER
                ClipRRect(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue[700],
                    ),
                  ),
                ),

                // QUINTO CONTAINER
                ClipRRect(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                Container(color: Colors.white),
              ],
            ),
          ),
        ],
      ),
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
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                      Text(
                        "Minha Conta",
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
                        Icons.trending_up,
                        color: Colors.white,
                      ),
                      Text(
                        "Relatórios",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
                      Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      Text(
                        "Adicionar Conta",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
                    Navigator.popAndPushNamed(context, '/');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
