import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:qrgx/screens/generate_screen.dart';
import 'package:qrgx/screens/history_screen.dart';
import 'package:qrgx/screens/scan_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR GENERATOR AND SCANNER',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Widget currenttab;
  List colors;

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-7280152329525075~9789127169");
    currenttab = ScanScreen();
    
    tabcolor("scan");
    super.initState();
  }

  void tabcolor(colored_tab){
    switch (colored_tab) {
      case "scan":
      setState(() {
        colors = [0xff021032,0xffc7d1d9,0xffc7d1d9];
      });
        break;

      case "generate":
      setState(() {
        colors = [0xffc7d1d9,0xff021032,0xffc7d1d9];
      });
        break;

      case "history":
      setState(() {
        colors = [0xffc7d1d9,0xffc7d1d9,0xff021032];
      });
        break;
    }

  }


  void navClick(Widget switchWidget){
    setState(() {
      currenttab = switchWidget;
    });

  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xfff9feff),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: Container(
            height: 50,
            child:Image.asset("assets/images/qrgx_logo.png",fit: BoxFit.fitHeight,)
          ),
            ),
          Container(
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Side navigation
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Column(
                      children: <Widget>[
                        RotatedBox(quarterTurns: 3,
                        child:MaterialButton(
                          child: Text("Scan",
                          style: TextStyle(
                            color: Color(colors[0]),
                            fontFamily: "Poppins",
                            fontSize: 14
                          ),),
                          elevation: 0,
                          splashColor: Colors.white,
                          minWidth: 0,

                          onPressed: (){
                            tabcolor("scan");
                            navClick(ScanScreen());
                          })),
                          RotatedBox(quarterTurns: 3,
                          child:MaterialButton(
                            child: Text("Generate",
                            style: TextStyle(
              color: Color(colors[1]),
              fontFamily: "Poppins",
              fontSize: 14,
                            ),),
                            elevation: 0,
                            splashColor: Colors.white,
                            minWidth: 0,
                            onPressed: (){
              tabcolor("generate");
              navClick(GenerateScreen());
                            })),
                            
                    ],),
                  ),
                  Expanded(
                      child: ListView(
                      
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        currenttab,
                        SizedBox(
                          height:10
                        )
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
          )
          
        ],
          ),
      ),
      
    );
  }
}
