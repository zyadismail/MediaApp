import 'package:flutter/material.dart';
import 'package:media_app/shared/style/hex_converter/hex_converter.dart';

class ImageModel{

  late int id;
  late num width;
  late num height;
  late String url;
  late String photographerName;
  late String photographerProfile;
  late Color averageColor;
  late String alt;
  late String originalUrl;
  late String mediumUrl;
  late String smallUrl;

  ImageModel.fromJson(Map<String,dynamic>json){
    id = json['id'];
    width = json['width'];
    height = json['height'];
    url = json['url'];
    photographerName = json['photographer'];
    photographerProfile = json['photographer_url'];
    averageColor = HexColorConverter.fromHex(json['avg_color']);
    alt = json['alt'];
    originalUrl = json['src']['original'];
    mediumUrl = json['src']['medium'];
    smallUrl = json['src']['small'];
  }

}