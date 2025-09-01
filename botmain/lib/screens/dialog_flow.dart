import 'package:flutter/material.dart';
import 'facts_message.dart';
import 'package:weather/weather.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

class FlutterFactsChatBot extends StatefulWidget {


  @override
  _FlutterFactsChatBotState createState() => new _FlutterFactsChatBotState();
}

class _FlutterFactsChatBotState extends State<FlutterFactsChatBot> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  WeatherFactory wf = new WeatherFactory("1cf1d5b99a3fd6b297ba1e02cfa59383", language: Language.ENGLISH);
  final List<Facts> messageList = <Facts>[];
  final TextEditingController _textController = new TextEditingController();

  Widget _queryInputWidget(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.only(left:8.0, right: 8),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _submitQuery,
                decoration: InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send, color: Color(0xff032e65),),
                  onPressed: () => _submitQuery(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void agentResponse(query) async {
    _textController.clear();
    DialogAuthCredentials credentials = await DialogAuthCredentials.fromFile("assets/app2-ubuk-bb20743dd7e5.json");
    DialogFlowtter instance = DialogFlowtter(
      credentials: credentials,
    );
    DetectIntentResponse response = await instance.detectIntent(queryInput: query,);
    if(response.queryResult!.parameters!.isNotEmpty){
      String city = response.queryResult?.parameters!["geo-city"];
      Weather w = await wf.currentWeatherByCityName(city);
      Facts message = Facts(
        text: w.weatherMain!+" ("+w.temperature!.celsius.toString()+"°C)",
        name: "FlutterBot",
        type: false,
      );
      setState(() {
        messageList.insert(0, message);
      });
    }else {
      Facts message = Facts(
        text: response.text!,
        name: "FlutterBot",
        type: false,
      );
      setState(() {
        messageList.insert(0, message);
      });
    }
  }

  void _submitQuery(String text) {
    _textController.clear();
    Facts message = new Facts(
      text: text,
      name: "User",
      type: true,
    );
    setState(() {
      messageList.insert(0, message);
    });
    agentResponse(QueryInput(text: TextInput(text: text)));
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
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          backgroundColor: Color(0xff032e65),
          centerTitle: true,
          title: Text("BLOOM"),
        ),
        body: Column(children: <Widget>[
          Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true, //To keep the latest messages at the bottom
                itemBuilder: (_, int index) => messageList[index],
                itemCount: messageList.length,
              )),
          _queryInputWidget(context),
        ]),
      ),
    );
  }
}