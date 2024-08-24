import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectivity {
  // Method to check if connected to network
  static Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }
}