import 'package:flutter/services.dart';

// Abstract class for FileServiceImpl
abstract class IFileService {
  Future<String> saveFileToLocal(Uint8List data, String fileName) ;
   Future<bool> fileExists(String fileName);
   Future<String> getFilePath(String fileName) ;
}