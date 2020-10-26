import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/src/DTOs/ApiResponseDTO.dart';
import 'package:mobile/src/components/LineChartComponent/LineChartComponent.dart';
import 'package:mobile/src/models/Farm.dart';
import 'package:mobile/src/models/Measure.dart';
import 'package:mobile/src/pages/ReportPage/ReportBloc.dart';
import 'package:mobile/src/providers/FarmProvider.dart';
import 'package:mobile/src/services/TokenService.dart';
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

  /// MÉTODO RESPONSÁVEL POR FORMATAR DA DATA PARA SER MOSTRADA NA TELA
  String formatDate(DateTime date) {
    return DateFormat.yMd('pt_BR').format(date);
  }

  /// MÉTODO RESPONSÁVEL POR FORMATAR A SOMATÓRIA DAS MEDIDAS
  String formatSummedMeasures(double summedMeasures) {
    return NumberFormat("###,###,###.##", 'pt_BR').format(summedMeasures);
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
            if (snapshot.data) {
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
                                      "Quantidade de Litros: ${formatSummedMeasures(snapshot.data)} L",
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
                                pickedDateTimeRange !=
                                    _reportBloc.dateTimeRange)
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
                                    ? "${formatDate(snapshot.data.start)} - ${formatDate(snapshot.data.end)}"
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
                                child: StreamBuilder<List<Measure>>(
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
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
