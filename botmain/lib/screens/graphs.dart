import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_database/firebase_database.dart';


class Graphs extends StatefulWidget {
  const Graphs({Key? key}) : super(key: key);

  @override
  State<Graphs> createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  num moisture = 0;
  num temperature = 0;
  num humidity = 0 ;
  late List<LiveData> humiditySoilChartData;
  late List<LiveData> moistureChartData;
  late List<LiveData> temperatureChartData;
  late List<LiveData> temperatureSoilChartData;
  late ChartSeriesController _humiditySoilChartSeriesController;
  late ChartSeriesController _moistureChartSeriesController;
  late ChartSeriesController _temperatureChartSeriesController;
  late ChartSeriesController _temperatureSoilChartSeriesController;
  late var timer;
  final databaseRef = FirebaseDatabase.instance.ref('test/');
  @override
  void initState() {
    humiditySoilChartData = getChartData();
    temperatureSoilChartData = getChartData();
    moistureChartData = getChartData();
    temperatureChartData = getChartData();
    if (mounted) {
      timer = Timer.periodic( Duration(seconds: 1), allGraphs);
    }
    super.initState();
    databaseRef.onValue.listen((event) {
      if(event.snapshot.exists){
        Map<String, dynamic> _post = Map<String, dynamic>.from(event.snapshot.value as Map);
        moisture = _post["moisure"];
        temperature = _post["temp"];
        humidity = _post['humidity'];
      }
    });
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 10,),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () => {Navigator.pushReplacementNamed(context, 'Home')},
                ),
                ListTile(
                  leading: Icon(Icons.show_chart),
                  title: Text('Graphs'),
                  onTap: () => {Navigator.pushReplacementNamed(context, 'Graphs')},
                ),
                ListTile(
                  leading: Icon(Icons.chat),
                  title: Text('Bot'),
                  onTap: () => {Navigator.pushReplacementNamed(context, 'Bot')},
                )
              ],
            ),
          ),
          backgroundColor: const Color(0xffF7F8FA),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            centerTitle: true,
            title: Text("BLOOM"),
            backgroundColor: Color(0xff032e65),
            elevation: 0,
          ),
          body: Column(
    children: <Widget>[
    Expanded(
    child: Container(
    color: Color(0xff032e65),
    child: Card(
    elevation: 10,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(30),
    ),
    ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Container(
                    margin: const EdgeInsets.all(4),
                    height: 280,
                    child: SfCartesianChart(
                        series: <LineSeries<LiveData, num>>[
                          LineSeries<LiveData, num>(
                            onRendererCreated: (ChartSeriesController controller) {
                              _moistureChartSeriesController = controller;
                            },
                            dataSource: moistureChartData,
                            color: Colors.blue,
                            xValueMapper: (LiveData sales, _) => sales.x,
                            yValueMapper: (LiveData sales, _) => sales.y,
                          )
                        ],
                        primaryXAxis: NumericAxis(
                            interval: 1,
                            title: AxisTitle(text: 'Time (seconds)')),
                        primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Moisture (%)'))),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    margin: const EdgeInsets.all(4),
                    height: 280,
                    child: SfCartesianChart(
                        series: <LineSeries<LiveData, num>>[
                          LineSeries<LiveData, num>(
                            onRendererCreated: (ChartSeriesController controller) {
                              _temperatureChartSeriesController = controller;
                            },
                            dataSource: temperatureChartData,
                            color: Colors.blue,
                            xValueMapper: (LiveData sales, _) => sales.x,
                            yValueMapper: (LiveData sales, _) => sales.y,
                          )
                        ],
                        primaryXAxis: NumericAxis(
                            interval: 1,
                            title: AxisTitle(text: 'Time (seconds)')),
                        primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Temperature (°C)'))),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    margin: const EdgeInsets.all(4),
                    height: 280,
                    child: SfCartesianChart(
                        series: <LineSeries<LiveData, num>>[
                          LineSeries<LiveData, num>(
                            onRendererCreated: (ChartSeriesController controller) {
                              _humiditySoilChartSeriesController = controller;
                            },
                            dataSource: humiditySoilChartData,
                            color: Colors.blue,
                            xValueMapper: (LiveData sales, _) => sales.x,
                            yValueMapper: (LiveData sales, _) => sales.y,
                          )
                        ],
                        primaryXAxis: NumericAxis(
                            title: AxisTitle(text: 'Moisture (%)')),
                        primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Humidity (%)'))),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    margin: const EdgeInsets.all(4),
                    height: 280,
                    child: SfCartesianChart(
                        series: <LineSeries<LiveData, num>>[
                          LineSeries<LiveData, num>(
                            onRendererCreated: (ChartSeriesController controller) {
                              _temperatureSoilChartSeriesController = controller;
                            },
                            dataSource: temperatureSoilChartData,
                            color: Colors.blue,
                            xValueMapper: (LiveData sales, _) => sales.x,
                            yValueMapper: (LiveData sales, _) => sales.y,
                          )
                        ],
                        primaryXAxis: NumericAxis(
                            title: AxisTitle(text: 'Moisture (%)')),
                        primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Temperature (°C)'))),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),)))]
          ),
        ));
  }



  int time = 0;

  void updateTemperatureDataSource() {
    if(time > 10){
      temperatureChartData.removeAt(0);
    }
    temperatureChartData.add(LiveData(++time, temperature));
    _temperatureChartSeriesController.updateDataSource(
        addedDataIndex: temperatureChartData.length - 1);
    setState(() {});
  }

  void updateMoistureDataSource() {
    if(time > 10){
      moistureChartData.removeAt(0);
    }
    moistureChartData.add(LiveData(time, moisture));
    _moistureChartSeriesController.updateDataSource(
        addedDataIndex: moistureChartData.length - 1);
    setState(() {});
  }

  void updateHumiditySoilDataSource() {
    if(humiditySoilChartData[humiditySoilChartData.length-1].x != moisture || humiditySoilChartData[humiditySoilChartData.length-1].y != humidity){
      if(humiditySoilChartData.length > 10){
        humiditySoilChartData.removeAt(0);
      }
    }
    humiditySoilChartData.add(LiveData(moisture, humidity));
    _humiditySoilChartSeriesController.updateDataSource(
        addedDataIndex: humiditySoilChartData.length - 1);
    setState(() {});
  }

  void updateTemperatureSoilDataSource() {
    if(temperatureSoilChartData[temperatureSoilChartData.length - 1].x != moisture || temperatureSoilChartData[temperatureSoilChartData.length - 1].y != temperature){
      if(temperatureSoilChartData.length > 10){
        temperatureSoilChartData.removeAt(0);
      }
    }
    temperatureSoilChartData.add(LiveData(moisture, temperature));
    _temperatureSoilChartSeriesController.updateDataSource(
        addedDataIndex: temperatureSoilChartData.length - 1);
    setState(() {});
  }



  void allGraphs(Timer timer){
    updateHumiditySoilDataSource();
    updateMoistureDataSource();
    updateTemperatureDataSource();
    updateTemperatureSoilDataSource();
  }
  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 0),
    ];
  }
}



class LiveData {
  LiveData(this.x, this.y);
  final num x;
  final num y;
}