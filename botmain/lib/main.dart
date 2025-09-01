import 'package:app2/screens/dialog_flow.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:app2/screens/graphs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'Home': (context) => Dashboard(),
        'Graphs': (context) => Graphs(),
        'Bot': (context) => FlutterFactsChatBot(),
      },
      debugShowCheckedModeBanner: false,
      title: 'BLOOM',
      home: SplashScreenView(
        navigateRoute: const Dashboard(),
        duration: 3000,
        imageSize: 130,
        imageSrc: "assets/plant.png",
        text: "BLOOM",
        textType: TextType.TyperAnimatedText,
        textStyle: TextStyle(
          fontSize: 30.0,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  num moisture = 0;
  num temperature = 0;
  num humidity = 0 ;


  final databaseRef = FirebaseDatabase.instance.ref('test/');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseRef.onValue.listen((event){
      if(event.snapshot.exists){
        Map<String, dynamic> _post = Map<String, dynamic>.from(event.snapshot.value as Map);
        print(_post);
        moisture = _post["moisure"];
        temperature = _post["temp"];
        humidity = _post['humidity'];
        setState(() {});
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    topPanel(size),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// TOP Panel
  Container topPanel(Size size) {
    return Container(
      width: size.width,
      height: size.height *0.7,
      decoration: const BoxDecoration(
          color: Color(0xff032e65),
          borderRadius:
          BorderRadius.only(bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              SizedBox(height: 20,),
              const Text(
                "Data",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
              Lottie.asset('assets/78999-data-scanning.json' , height: 300 , width: 300),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
    Column(
    children: [
    Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Text( "Soil moisture",
    style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20)),
    ),
    Container(
    margin: EdgeInsets.all(5),
    child: ImageIcon(
      AssetImage("assets/icons8-moisture-50.png"),
    color: Colors.white,
    size: 72,
    ),
    ),
    Text("$moisture%",
    style: const TextStyle(color: Colors.white, fontSize: 18))
    ],
    ),
              Container(
                height: 50,
                width: 1,
                color: Colors.white30,
              ),
    Column(
    children: [
    Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Text( "Temperature",
    style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20)),
    ),
      Lottie.asset('assets/9793-thermometer.json', height: 80, width: 80),
    Text("$temperature°C",
    style: const TextStyle(color: Colors.white, fontSize: 18))
    ],
    ),
              Container(
                height: 50,
                width: 1,
                color: Colors.white30,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text( "Humidity",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                  Lottie.asset('assets/62765-weather-icon.json', height: 80, width: 80),
                  Text("$humidity%",
                      style: const TextStyle(color: Colors.white, fontSize: 18))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
