import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'base_to_timage.dart';



class GenerateBottomSheet extends StatefulWidget {
  final String base;

  const GenerateBottomSheet({Key key, this.base}) : super(key: key);

  @override
  _GenerateBottomSheetState createState() => _GenerateBottomSheetState();
}

class _GenerateBottomSheetState extends State<GenerateBottomSheet> {

  void savetoGallery() async{
    Uint8List basebytes = base64Decode(widget.base);
    final Directory path = await getApplicationDocumentsDirectory();
    final String pathUrl = path.path;
    final String filename = "qrgx_code_"+DateTime.now().toString();
    final File localimage = File("$pathUrl/$filename");
    localimage.writeAsBytes(basebytes);
    
  }

  void GeneratedQrBottomSheet(){

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
                  child: base64toImage(widget.base)
                  
                  ),
                
                  
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Container(
                            height: 50,
                            width: 120,
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
                                  
                                },
                                child: Center(
                                  child: Text(
                                    "Save to Gallery",
                                    style: TextStyle(fontSize: 16,color: Color(0xff021032),fontFamily: "SF_PRO_DISPLAY",
                                  ),
                                ),
                              ),
                            ),
                          )
                          ),
                    ),

                    Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Container(
                          height: 50,
                          width: 120,
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
                                
                              },
                              child: Center(
                                child: Text(
                                  "Share",
                                  style: TextStyle(fontSize: 16,color: Color(0xff021032),fontFamily: "SF_PRO_DISPLAY",
                                ),
                              ),
                            ),
                          ),
                        )
                        ),
                  ),
                  ],
                ),

                


                
              ],

            ),
          ),
        ],
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    debugPrint("ok");
    // TODO: implement build
    return GenerateBottomSheet();
  }
  
  
}