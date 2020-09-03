import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {


  bottomSheet(String scannedData){

    showModalBottomSheet(

      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      context: context, builder: (BuildContext buildContext){
      return Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  height: 400,
                  width: double.infinity,
                  child: ListView(
                    
                    children: <Widget>[
                      SelectableText(scannedData),
                    ],
                  )),
                
                  
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Container(
                        height: 50,
                        width: 270,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [new BoxShadow(color: Color(0xffb3e6fa),blurRadius: 4,spreadRadius: 1,
                          offset: Offset(0, 5))]
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Color(0xff27b4ef),
                            onTap: (){
                              Clipboard.setData(ClipboardData(text: scannedData));
                            },
                            child: Center(
                              child: Text(
                                "Copy to Clipboard",
                                style: TextStyle(fontSize: 16,color: Color(0xff021032),fontFamily: "SF_PRO_DISPLAY",
                              ),
                            ),
                          ),
                        ),
                      )
                      ),
                )

                
              ],

            ),
          ),
        ],
      );
    });

  }

  Future scanQRfromGallery() async{
    String scannedData = await scanner.scanPhoto();

    bottomSheet(scannedData);
    
  }

  Future scanQRfromCamera() async{
    String scannedData = await scanner.scan();

    bottomSheet(scannedData);
    
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text("QR CODE SCAN",
                      style: TextStyle(
                        color: Color(0xff021032),
                        fontSize: 16,
                        fontFamily: "SF_PRO_DISPLAY"
                      ),),
                    ),
                  ),
                  // Scan information
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [new BoxShadow(
                        blurRadius: 4,
                        spreadRadius: -2,
                        color: Color(0xffb3e6fa),
                        offset: Offset(0, 5)
                      )]
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
                      
                      ),

                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 230,
                              child: Text("Click on scan button to scan your QR code.",
                              style: TextStyle(
                                color: Color(0xffc7d1d9),
                                fontFamily: "SF_PRO_DISPLAY",
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,),
                            ),

                            SizedBox(
                              height: 20,

                            ),
                            
                            Container(
                              height: 180,
                              child: Image.asset("assets/images/sample_qr.png",fit: BoxFit.fitHeight,)),

                            SizedBox(
                              height: 20,

                            ),

                            Container(
                              width: 230,
                              child: Text("The app will require access to the camera.",
                              style: TextStyle(
                                color: Color(0xffc7d1d9),
                                fontFamily: "SF_PRO_DISPLAY",
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,),
                            )
                            
                          ],
                        )
                        ),
                    ),
                  ),
                  
                  SizedBox(
                    height: 20,
                  ),

                  Container(
                    height: 50,
                    width: 270,
                    decoration: BoxDecoration(
                      color: Color(0xff27B4ef),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [new BoxShadow(color: Color(0xffb3e6fa),blurRadius: 4,spreadRadius: 1,
                      offset: Offset(0, 5))]
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.white,
                        onTap: () => scanQRfromCamera(),
                        child: Center(
                          child: Text(
                            "Scan",
                            style: TextStyle(fontSize: 16,color: Colors.white,fontFamily: "SF_PRO_DISPLAY",
                          ),
                        ),
                      ),
                    ),
                  )
                  ),
                  
                  SizedBox(
                    height: 20,
                  ),

                  
                  // Scan Button
                  Container(
                    height: 50,
                    width: 270,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [new BoxShadow(color: Color(0xffb3e6fa),blurRadius: 4,spreadRadius: 1,
                      offset: Offset(0, 5))]
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.white,
                        onTap: () => scanQRfromGallery(),
                        child: Center(
                          child: Text(
                            "Select Image from Gallery",
                            style: TextStyle(fontSize: 16,color: Color(0xff021032),fontFamily: "SF_PRO_DISPLAY",
                          ),
                        ),
                      ),
                    ),
                  )
                  )
                ],
              ),
            );

  }
}
