import 'package:flutter/material.dart';

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
            pinned: true,
            floating: false,
            expandedHeight: 175.0,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              //title: Text("Sistema de Irrigação Simplificado"),
              background:
                  Image.asset('images/home2.png', height: 200, width: 200),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 150.0,
            delegate: SliverChildListDelegate(
              [
                Container(color: Colors.blue[100]),
                Container(color: Colors.blue[400]),
                Container(color: Colors.blue[700]),
                Container(color: Colors.blue[900]),
                Container(color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
