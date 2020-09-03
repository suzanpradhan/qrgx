import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

class InternetService{
  var connectionStatus;
  final Connectivity _connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> _connectionSubscription;
  
  Future<String> initConnectivity() async{
    connectionStatus = (await _connectivity.checkConnectivity()).toString();
    debugPrint(connectionStatus);
    if (connectionStatus == "ConnectivityResult.wifi" || connectionStatus == "ConnectivityResult.mobile"){
      return "Online";
    }else{
      return "Offline";
    }
    
  }
}