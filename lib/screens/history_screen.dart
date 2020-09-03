import 'package:flutter/material.dart';
import 'package:qrgx/sqflite/sqflite_db.dart';

import '../base_to_timage.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  bool listpresent = true;

  void checkQrlist() async
  {
    var list = await viewQR();
    if (list[0] == null){
      if(!mounted) return;
      setState(() {
        listpresent = true;
      });
    }else {
      if(!mounted) return;
      setState(() {
        listpresent = false;
      });
    }
  }

  changetoImage(String base){
    Image qrImage = base64toImage(base);
    return qrImage;
    
  }



  @override
  Widget build(BuildContext context) {
    checkQrlist();
    return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    
                    children: <Widget>[
                      Container(
                        width: 270,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Text("HISTORY",
                            style: TextStyle(
                              color: Color(0xff021032),
                              fontSize: 16,
                              fontFamily: "SF_PRO_DISPLAY"
                            ),),
                          ),
                        ),
                      ),
                      listpresent?Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Text("No any history to Show.",
                          style: TextStyle(
                            color: Color(0xffc7d1d9),
                            fontSize: 12,
                            fontFamily: "SF_PRO_DISPLAY"
                          ),),
                        ),
                      ):
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: FutureBuilder(
                          future: viewQR(),
                          builder: (context, snapshot){
                            if (snapshot.hasData){
                              return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext buildcontext,int index){
                                return Container(
                                  height: 100,
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        changetoImage(snapshot.data[index]["base64"].toString()),
                                        Text(snapshot.data[index]["id"].toString()),
                                      ],
                                    )));

                            });
                            }else{
                              return CircularProgressIndicator();
                            }
                            

                          })
                        ),
                      )
                      
                      
                      
                      
          
                    ],
                  ),
                );
  }
}
