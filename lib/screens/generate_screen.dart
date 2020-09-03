import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrgx/connectivity/internet_service.dart';
import 'package:qrgx/rest_api.dart';
import 'package:qrgx/sqflite/sqflite_db.dart';
import 'package:qrgx/firebaseadmob.dart';
import 'package:toast/toast.dart';
import 'dart:io';

import '../base_to_timage.dart';

class GenerateScreen extends StatefulWidget {

  

  
  @override
  _GenerateScreenState createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  
  InterstitialAd _interstitialAd = createinterstitialAd()..load()..show();
  
  bool isloading = true;

  final controller = TextEditingController();

  bool _firstpressed = true;


 
  List selectRadio = [20,4,4,4,4];
  static final List radiocolorslist = [0xff000000,0xfff44336,0xff2196f3,0xff4caf50,0xffff9800];
  Color pickedcolor = Color(0xff000000);

  @override
  void dispose() {
    // TODO: implement dispose
    _interstitialAd.dispose();
    controller.dispose();
    super.dispose();
  }

  void downloadQr(String base) async{
    Uint8List basebytes = base64Decode(base);
    
    final result = await ImageGallerySaver.saveImage(basebytes);
    debugPrint(result);

    Toast.show("Downloaded!", context,duration:Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);
    
  }

  void shareQr(String base) async{
    Uint8List basebytes = base64Decode(base);
    await Share.file("Qr code", "qrgx_code_"+DateTime.now().toString()+".png", basebytes, "image/png");
    
  }


  void GeneratedQRBottomSheet(String base){
    if (base !=null){
    
      _interstitialAd..show();
      Image qrImage = base64toImage(base);
    
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
                  child: qrImage
                  
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
                                  if(_firstpressed){
                                    downloadQr(base);
                                    
                                    setState(() {
                                      _firstpressed = false;
                                    });
                                  }
                                  
                                },
                                child: Center(
                                  child: Text(
                                    "Download",
                                    style: TextStyle(fontSize: 16,color: Color(0xff021032),fontFamily: "SF_PRO_DISPLAY",
                                  ),
                                ),
                              ),
                            ),
                          )
                          ),
                    ),

                    SizedBox(
                      width: 20,
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
                                shareQr(base);
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
    

    }else{
      Scaffold.of(context).showSnackBar(new SnackBar(content: Text("No Internet Connection.")));
    }
    
      setState(() {
        isloading = true;
      });
    

  }

  void internet() async{
    if (await InternetService().initConnectivity() == "Online"){
      var color = "0x${pickedcolor.value.toRadixString(16)}";
      debugPrint(color);
    
      String base = await postMethod(context,controller?.text ?? "",color);
      GeneratedQRBottomSheet(base);
      
      debugPrint(await InternetService().initConnectivity());
      setState(() {
        isloading = true;
      });
    }else{
      setState(() {
        isloading = true;
      });
      
      Scaffold.of(context).showSnackBar(new SnackBar(content: Text("No Internet Connection.")));
      
    }
    

  }

  void internetConnection() async{
    

    try{
      var connectionListener = DataConnectionChecker().onStatusChange.listen((status){
      if (status == DataConnectionStatus.connected){
        debugPrint(controller.value.toString());
        postMethod(context,controller.text,"$pickedcolor");
        setState(() {
          isloading = true;
        });
      }else{
        Scaffold.of(context).showSnackBar(new SnackBar(content: Text("Error 1")));
      }
    });
    
    await Future.delayed(Duration(seconds: 30));
    await connectionListener.cancel();
    }on SocketException catch (_){
      Scaffold.of(context).showSnackBar(new SnackBar(content: Text("Error 2")));
    }on ClientException catch (_){
      Scaffold.of(context).showSnackBar(new SnackBar(content: Text("Error 3")));

    }catch(e){
      return null;
    }
    
  }
    


  Widget RadioButColored(int color, int radius){
  return Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      color: Color(color),
      border: Border.all(width: 2,color: Colors.white),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [new BoxShadow(
        color: Color(color),
        blurRadius: radius.toDouble(),
        spreadRadius: -2
      )]
    ),
    child: Material(
      color: Colors.transparent,
      child: new InkWell(
        onTap: (){
          RadioColorPick(color);

          

        },
      ),
    ),

  );
}

  void RadioColorPick(int color){
    setState(() {
      if (color == radiocolorslist[0]){
        selectRadio = [20,4,4,4,4];
        pickedcolor = Color(radiocolorslist[0]);
        
      }else if (color ==radiocolorslist[1])
      {
        selectRadio = [4,20,4,4,4];
        pickedcolor = Color(radiocolorslist[1]);
      }else if (color == radiocolorslist[2]){
        selectRadio = [4,4,20,4,4];
        pickedcolor = Color(radiocolorslist[2]);
      }else if (color == radiocolorslist[3]){
        selectRadio = [4,4,4,20,4];
        pickedcolor = Color(radiocolorslist[3]);
      }else if (color == radiocolorslist[4]){
        selectRadio = [4,4,4,4,20];
        pickedcolor = Color(radiocolorslist[4]);
      }else{
        selectRadio = [4,4,4,4,4];
      }
    });
  }

  void ChangeColor(Color color){
    setState(() {
      pickedcolor = color;
    });
  }

  colorpickerDialog(){
    return showDialog(context: context,
    child: AlertDialog(
          content: SingleChildScrollView(
            child: ColorPicker(pickerColor: pickedcolor, onColorChanged: ChangeColor,
        showLabel: true,
        pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          RadioColorPick(null);
          Navigator.of(context).pop();
        }, 
        child: Text("Done"))
      ],
    ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Text("QR CODE GENERATE",
                            style: TextStyle(
                              color: Color(0xff021032),
                              fontSize: 16,
                              fontFamily: "SF_PRO_DISPLAY"
                            ),),
                          ),
                        ),
                        
                        Container(
                          width: 270,
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextField(
                              controller: controller,
                              decoration: new InputDecoration(
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Enter text or link...",
                                hintStyle: TextStyle(color: Color(0xffc7d1d9))
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "SF_PRO_DISPLAY"
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1,color: Color(0xff27b4ef)),
                            borderRadius: BorderRadius.circular(8),

                            
                          ),
                          
                        ),

                        SizedBox(
                          height: 40,
                        ),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RadioButColored(radiocolorslist[0], selectRadio[0]),
                            SizedBox(width: 20),
                            RadioButColored(radiocolorslist[1],selectRadio[1]),
                            SizedBox(width: 20),
                            RadioButColored(radiocolorslist[2], selectRadio[2]),
                            SizedBox(width: 20),
                            RadioButColored(radiocolorslist[3], selectRadio[3]),
                            SizedBox(width: 20),
                            RadioButColored(radiocolorslist[4],selectRadio[4]),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),

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
                              onTap: (){
                                colorpickerDialog();
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: pickedcolor
                                      ),
                                    ),
                                  ),

                                  Text(
                                    "Use Color Picker",
                                    style: TextStyle(fontSize: 16,color: Color(0xff021032),fontFamily: "SF_PRO_DISPLAY",
                                  ),
                                  ),
                                ],
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
                            color: Color(0xff27B4ef),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [new BoxShadow(color: Color(0xffb3e6fa),blurRadius: 4,spreadRadius: 1,
                            offset: Offset(0, 5))]
                          ),
                          child: isloading ? Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.white,
                              onTap: (){
                                setState(() {
                                  isloading = false;
                                });
                                internet();

                              },
                              child: Center(
                                child: Text(
                                  "Generate",
                                  style: TextStyle(fontSize: 16,color: Colors.white,fontFamily: "SF_PRO_DISPLAY",
                                ),
                              ),
                            ),
                          ),
                        ):Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            backgroundColor: Colors.white,
                          ),
                        )

                        )
                      ],
                    ),
                  ),
  );
  }
}
  


