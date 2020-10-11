import 'package:flutter/material.dart';
import 'package:mobile/src/components/WaterAmountComponent.dart';
import 'package:mobile/src/models/Farm.dart';
import 'package:mobile/src/models/Home.dart';
import 'package:mobile/src/models/User.dart';
import 'package:mobile/src/pages/HomePage/HomeBloc.dart';
import 'package:mobile/src/providers/FarmProvider.dart';
import 'package:mobile/src/providers/UserProvider.dart';
import 'package:mobile/src/services/TokenService.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _homeBloc = new HomeBloc();
  Farm farm;
  User user;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  void getFarmFromContext(BuildContext context) {
    this.farm = context.watch<FarmProvider>().farm;
  }

  void getUserFromContext(BuildContext context) {
    this.user = context.watch<UserProvider>().user;
  }

  @override
  Widget build(BuildContext context) {
    getFarmFromContext(context);
    getUserFromContext(context);
    _homeBloc.getHomeDate(this.farm.id);

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
                "Bem vindo(a) ${this.user.name} a Fazenda ${this.farm.name}",
              ),
            ),
          ),
          StreamBuilder<Home>(
            stream: _homeBloc.homeOutput,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SliverFixedExtentList(
                  delegate: SliverChildListDelegate(
                    [
                      Center(
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
                      )
                    ],
                  ),
                  itemExtent: 150.0,
                );
              }

              return SliverFixedExtentList(
                itemExtent: 150.0,
                delegate: SliverChildListDelegate(
                  [
                    WaterAmountComponent(
                      text: "QUANTIDADE DE ÁGUA USADA HOJE",
                      amount: snapshot.data.todayMeasures.sum,
                      color: Colors.blue[200],
                    ),
                    WaterAmountComponent(
                      text: "QUANTIDADE DE ÁGUA USADA NAS ÚLTIMAS 12 HORAS",
                      amount: snapshot.data.lastTwelveHoursMeasures.sum,
                      color: Colors.blue,
                    ),
                    WaterAmountComponent(
                      text: "QUANTIDADE DE ÁGUA USADA NAS UĹTIMAS 24 HORAS",
                      amount: snapshot.data.yesterdayMeasures.sum,
                      color: Colors.blue[700],
                    ),
                  ],
                ),
              );
            },
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
