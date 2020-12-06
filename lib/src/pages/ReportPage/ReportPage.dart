import 'package:flutter/material.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/components/LineChartComponent/LineChartComponent.dart';
import 'package:mobile/src/models/Farm.dart';
import 'package:mobile/src/models/SectorMeasure.dart';
import 'package:mobile/src/pages/ReportPage/ReportBloc.dart';
import 'package:mobile/src/providers/FarmProvider.dart';
import 'package:mobile/src/services/TokenService.dart';
import 'package:mobile/src/utils/Format.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Farm _farm;
  ReportBloc _reportBloc = ReportBloc();

  /// MÉTODO RESPONSÁVEL POR RETORNA A FAZENDA ATUAL ATRAVÉS DO PROVIDER
  void getFarmFromContext(BuildContext context) {
    _farm = context.watch<FarmProvider>().farm;
  }

  @override
  void dispose() {
    _reportBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // NO INICIO DA PÁGINA CHAMAMOS A API PARA MOSTRAR OS DADOS
    getFarmFromContext(context);

    _reportBloc.getMeasures(
      DateTimeRange(
        start: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day - 1,
        ),
        end: DateTime.now(),
      ),
      _farm.id,
    );

    return Scaffold(
      body: StreamBuilder<bool>(
        stream: _reportBloc.isLoadingOutput,
        initialData: false,
        builder: (context, snapshot) {
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
                        _reportBloc.getMeasures(
                          DateTimeRange(
                            start: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day - 1,
                            ),
                            end: DateTime.now(),
                          ),
                          _farm.id,
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          }

          // CASO ESTEJA CARREGANDO MOSTRAMOS O LOADING
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

          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: false,
                expandedHeight: 175.0,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    'images/relatorio.png',
                    height: 210,
                    width: 210,
                  ),
                ),
              ),
              SliverAppBar(
                pinned: true,
                floating: false,
                expandedHeight: 20.0,
                backgroundColor: Colors.blue,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text("Medições da Fazenda"),
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
                        child: FlatButton(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.assignment,
                                color: Colors.white,
                                size: 70,
                              ),
                              StreamBuilder<double>(
                                stream: _reportBloc.summedMeasuresOutput,
                                initialData: 0.0,
                                builder: (context, snapshot) {
                                  return Text(
                                    "Quantidade de Litros: ${Format.formatNumber(snapshot.data)} L",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          onPressed: null,
                        ),
                      ),
                    ),
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
                        child: FlatButton(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.assignment,
                                color: Colors.white,
                                size: 70,
                              ),
                              StreamBuilder<double>(
                                stream: _reportBloc.summedMeasuresOutput,
                                initialData: 0.0,
                                builder: (context, snapshot) {
                                  return Text(
                                    "Gastos Alimentação Bomba: ${Format.formatNumber(snapshot.data)} W ou L",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          onPressed: null,
                        ),
                      ),
                    ),
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
                        child: FlatButton(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.assignment,
                                color: Colors.white,
                                size: 70,
                              ),
                              StreamBuilder<double>(
                                stream: _reportBloc.summedMeasuresOutput,
                                initialData: 0.0,
                                builder: (context, snapshot) {
                                  return Text(
                                    "Total Gasto: ${Format.formatCurrency(snapshot.data)}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          onPressed: null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: FlatButton(
                        color: Colors.blue[900],
                        onPressed: () async {
                          DateTimeRange pickedDateTimeRange =
                              await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 10),
                            lastDate: DateTime.now(),
                            currentDate: DateTime.now(),
                            initialDateRange: _reportBloc.dateTimeRange,
                            saveText: "Confirmar",
                            confirmText: "Confirmar",
                            helpText:
                                "Escolha o intervalo de datas para a busca",
                            cancelText: "Cancelar",
                          );

                          if (pickedDateTimeRange != null &&
                              pickedDateTimeRange != _reportBloc.dateTimeRange)
                            await _reportBloc.getMeasures(
                              pickedDateTimeRange,
                              _farm.id,
                            );
                        },
                        child: StreamBuilder<DateTimeRange>(
                          stream: _reportBloc.dateTimeRangeOutput,
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data != null
                                  ? "${Format.formatDate(snapshot.data.start)} - ${Format.formatDate(snapshot.data.end)}"
                                  : "Escolha o intervalo para a busca",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 400,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                bottom: 10.0,
                              ),
                              child: StreamBuilder<List<SectorMeasure>>(
                                stream: _reportBloc.measuresOutput,
                                initialData: [],
                                builder: (context, snapshot) {
                                  return LineChartComponent(snapshot.data);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SETORES
                    StreamBuilder<List<SectorMeasure>>(
                        stream: _reportBloc.measuresOutput,
                        initialData: [],
                        builder: (context, snapshot) {
                          return ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.blue[400],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Setor: ${snapshot.data[index].sector}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                        ),
                                      ),
                                      Text(
                                        "Cultura: ${snapshot.data[index].culture}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        "Umidade Atual: ${Format.formatNumber(_reportBloc.sumMoisture(snapshot.data[index].measures))}%",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        "Umidade Ideal: ${Format.formatNumber(snapshot.data[index].idealMoisture)}%",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                            itemCount: snapshot.data.length,
                          );
                        }),
                  ],
                ),
              ),
            ],
          );
        },
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/report');
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
                        "Vincular Conta",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/link_customer");
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
                        Icons.exposure,
                        color: Colors.white,
                      ),
                      Text(
                        "Calculos",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/farm_configuration");
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

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (Route<dynamic> route) => false,
                    );
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
