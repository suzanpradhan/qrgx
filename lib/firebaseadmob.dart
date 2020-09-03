import 'package:firebase_admob/firebase_admob.dart';



MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo(

  testDevices: <String>[]
);

InterstitialAd interstitialAd;
InterstitialAd createinterstitialAd(){
  return new InterstitialAd(
    adUnitId: "ca-app-pub-7280152329525075/5384894015",
    targetingInfo: targetingInfo
  );
}


