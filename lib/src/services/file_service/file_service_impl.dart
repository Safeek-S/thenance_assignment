import 'dart:io';

import 'package:flutter/services.dart';
import 'package:musicplayer/src/core/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

import 'file_service.dart';

class FileServiceImpl extends IFileService {
  // This method is to store the mp3 file in local
  @override
  Future<String> saveFileToLocal(Uint8List data, String fileName) async {
    try {
      // Get the file path
      final filePath = await _getFilePath(fileName);
      final file = File(filePath);

      // Write the data to the file
      await file.writeAsBytes(data);
      return filePath;
    } on Exception catch (e) {
      e.log();
      return "";
    }
  }

  // This method is to return file path
  Future<String> _getFilePath(String fileName) async {
    // Fetch the path to the directory where user can place data
    final directory = await getApplicationDocumentsDirectory();

    // Return file path
    return '${directory.path}/$fileName.mp3';
  }

// This method returns the boolean if file exists
  @override
  Future<bool> fileExists(String fileName) async {
    try {
      final filePath = await _getFilePath(fileName);
      final file = File(filePath);

      // Return boolean if file exists
      return file.exists();
    } on Exception catch (e) {
      e.log();
      return false;
    }
  }

//  This methode returns the file path
  @override
  Future<String> getFilePath(String fileName) async {
    try {
      final filePath = await _getFilePath(fileName);
      return filePath;
    } on Exception catch (e) {
      e.log();
      return "";
    }
  }
}
