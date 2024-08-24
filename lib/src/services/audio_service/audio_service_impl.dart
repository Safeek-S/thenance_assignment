import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:musicplayer/src/core/utils/utils.dart';
import 'audio_service.dart';

class AudioServiceImpl implements IAudioService {
  // Create the audio player instance
  final AudioPlayer _audioPlayer = AudioPlayer();

  // This stream listens to the position of the track
  final StreamController<double> _positionController =
      StreamController<double>.broadcast();

  // This stream listens to the player state (whether completed, playing or paused)
  final StreamController<PlayerState> _playerStateController =
      StreamController<PlayerState>.broadcast();
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  @override
  Stream<double> get positionStream => _positionController.stream;

  @override
  Stream<PlayerState> get playerStateStream => _playerStateController.stream;

  // This method sets the audio file source
  @override
  Future<void> setAudioSource(String filePath) async {
    try {
      // This method allows to set the song file trsck
      await _audioPlayer.setSourceDeviceFile(filePath);
    } on Exception catch (exception) {
      exception.log();
    }
  }

// This method plays the song
  @override
  Future<void> play() async {
    try {
      // This method resumes the song from where it is paused or stopped
      await _audioPlayer.resume();

      // Start listening to the positions
      _startPositionListener();
    } on Exception catch (exception) {
      exception.log();
    }
  }

//  This method is to pause the song
  @override
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();

      // Stop listening to the subscriptions
      _cancelTheStreamSubscriptions();
    } on Exception catch (exception) {
      exception.log();
    }
  }

  @override
  Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;

  void _startPositionListener() {
    // Cancel previous subscription if any
    _positionSubscription?.cancel();

    // Listen to the changes in the position
    _audioPlayer.onPositionChanged.listen((Duration position) {
      _positionController.add(position.inSeconds.toDouble());
    });

    // Cancel previous subscription if any
    _playerStateSubscription?.cancel();

    // Listen to the changes in player state
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      _playerStateController.add(state);
    });
  }

// This method returns the total duration of the track
  @override
  Future<double> getTotalDuration() async {
    try {
      var totalDuration = await _audioPlayer.getDuration();
      return totalDuration!.inSeconds.toDouble();
    } on Exception catch (exception) {
      exception.log();
      return -9;
    }
  }

// This method returns current position
  @override
  Future<double> returnCurrentPositionOfTheTrack() async {
    try {
      var duration = await _audioPlayer.getCurrentPosition();
      return duration != null
          ? duration.inSeconds.toDouble()
          : Duration.zero.inSeconds.toDouble();
    } on Exception catch (exception) {
      exception.log();
      return -9;
    }
  }

  @override
  Stream<PlayerState> get onPlayerStateChanged =>
      _audioPlayer.onPlayerStateChanged;

// This method cancels all the subscriptions
  void _cancelTheStreamSubscriptions() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel(); // Cancel subscription to stop listening
  }

// Dispose method to dispose all the streams
  @override
  void dispose() {
    _positionController.close();
    _playerStateController.close();
    _cancelTheStreamSubscriptions();
  }
}
