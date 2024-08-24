import 'package:flutter/services.dart';
// Abstract class for the ApiServiceImpl
abstract class IApiService{
  Future<Uint8List?> fetchMp3File(String url);
}