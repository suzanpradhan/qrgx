import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qrgx/generateBottomSheet.dart';



Future postMethod(BuildContext context,String msg,String color) async {
  if (msg == null){
    msg = "";
  }
  debugPrint(msg+"done");
  Map data = {
      "message": msg,
      "color": color
    };

  try{
    http.Response response = await http.post(
    "https://qrgeneratorzenith.herokuapp.com/",
    headers: {
      "Content-Type": "application/json"
    },
    body: json.encode(data)
    );

  Map<String, dynamic> resDatas = jsonDecode(response.body);
  
  if(response.statusCode > 200 || response.statusCode < 400){
    debugPrint(json.decode(response.body).toString());
    debugPrint(json.decode(response.body)["image_bytes_png"]);
    GenerateBottomSheet(base: resDatas["image_bytes_png"],);
    return resDatas["image_bytes_png"];
  }else{
    return null;


  } 
  }catch(e){
    debugPrint("error");
    return null;

  }
}