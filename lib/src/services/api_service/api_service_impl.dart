import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:musicplayer/src/core/network/network.dart';
import 'package:musicplayer/src/core/utils/utils.dart';
import 'package:musicplayer/src/services/api_service/api_service.dart';

class ApiServiceImpl implements IApiService {
  // This method returns the mp3 data in Uint8List
  @override
  Future<Uint8List?> fetchMp3File(String url) async {
    try {
      // Check of internet connectivity
      if (await NetworkConnectivity.isConnected()) {
        // Make the api call
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          // return the response
          return response.bodyBytes;
        } else {
          print('Failed to load MP3 file');
          return null;
        }
      } else {
        print("No internet!");
        return null;
      }
    } on HttpException catch (exception) {
      // Log the error
      exception.log();
      return null;
    } on Exception catch (exception) {
      // Log the error
      exception.log();
      return null;
    }
  }
}
