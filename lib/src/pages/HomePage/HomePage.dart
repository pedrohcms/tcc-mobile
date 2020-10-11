import 'package:flutter/material.dart';
import 'package:mobile/src/components/WaterAmountComponent.dart';
import 'package:mobile/src/services/TokenService.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              background: Image.asset(
                'images/home.png',
                height: 210,
                width: 210,
              ),
            ),
          ),
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 50.0,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Bem vindo a sua Propriedade",
              ),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 150.0,
            delegate: SliverChildListDelegate(
              [
                WaterAmountComponent(
                  text: "QUANTIDADE DE ÁGUA USADA HOJE",
                  amount: 90000.25,
                  color: Colors.blue[200],
                ),
                WaterAmountComponent(
                  text: "QUANTIDADE DE ÁGUA USADA NAS ÚLTIMAS 12 HORAS",
                  amount: 100000,
                  color: Colors.blue,
                ),
                WaterAmountComponent(
                  text: "QUANTIDADE DE ÁGUA USADA NAS UĹTIMAS 24 HORAS",
                  amount: 250000,
                  color: Colors.blue[700],
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
                    TokenService.deleteToken();

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
