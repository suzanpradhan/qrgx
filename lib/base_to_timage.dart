import 'dart:convert';

import 'package:flutter/cupertino.dart';

Image base64toImage(String base){
  return Image.memory(base64Decode(base));
}