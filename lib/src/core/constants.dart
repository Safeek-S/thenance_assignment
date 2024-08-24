import 'dart:math';
class AppConstants {
  static String url =
        "https://codeskulptor-demos.commondatastorage.googleapis.com/descent/background%20music.mp3",
    fileName = 'downloaded_mp3';

static double verticalCenter = 50 / 2;
// This generates a list with 100 random values between 0 t0 25
static List<double> waveformValues = List<double>.generate(100, (_) {
  return Random().nextDouble() * verticalCenter;
});

}
