import 'package:audioplayers/audioplayers.dart';
// Abstract class for AudioServiceImpl
abstract class IAudioService {
  Future<void> play();
  Future<void> pause();
  Stream<Duration> get onPositionChanged;
  Future<double> getTotalDuration();
  Future<double> returnCurrentPositionOfTheTrack();
   Future<void> setAudioSource(String filePath);
     Stream<double> get positionStream;
     void dispose();
     Stream<PlayerState> get onPlayerStateChanged;
     Stream<PlayerState> get playerStateStream;
}
