import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/src/blocs/music_player_bloc/music_player_event.dart';
import 'package:musicplayer/src/blocs/music_player_bloc/music_player_state.dart';
import 'package:musicplayer/src/services/api_service/api_service.dart';
import 'package:musicplayer/src/services/file_service/file_service.dart';

import '../../core/constants.dart';
import '../../services/audio_service/audio_service.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final IAudioService audioService;
  final IFileService fileService;

  final IApiService apiService;

  double lastPosition = 0, totalDuration = 0;
  StreamSubscription<double>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  MusicPlayerBloc({
    required this.apiService,
    required this.fileService,
    required this.audioService,
  }) : super(InitialState()) {
    on<FetchAndSaveMusicFile>(_onFetchAndSaveMusicFile);
    on<PlayMusic>(_handlePlayMusicEvent);
    on<PauseMusic>(_onPauseMusicEvent);
    on<UpdateSliderPosition>(_onUpdateSliderPosition);
    on<PlaybackCompleted>(_handlePlaybackCompleted);
  }
  //  Handles fetch and save of music file
  Future<void> _onFetchAndSaveMusicFile(
      FetchAndSaveMusicFile event, Emitter<MusicPlayerState> emit) async {
    try {
      emit(MusicLoadingState());
      // Get the file path
      final filePath = await _getFilePathOrFetch(event.url);

      await _setAudioSourceAndUpdateDuration(filePath);
      emit(MusicLoadedState());
    } catch (e) {
      emit(ErrorState('An error occurred: ${e.toString()}'));
    }
  }

  Future<String> _getFilePathOrFetch(String url) async {
    try {
      //  Check if file already exists
      final fileExists = await fileService.fileExists(AppConstants.fileName);
      if (fileExists) {
        return await fileService.getFilePath(AppConstants.fileName);
      } else {
        //  Fetch file from internet
        final musicData = await apiService.fetchMp3File(url);
        return await fileService.saveFileToLocal(
            musicData!, AppConstants.fileName);
      }
    } catch (e) {
      throw Exception(
          'Failed to get file path or fetch the file: ${e.toString()}');
    }
  }

  Future<void> _setAudioSourceAndUpdateDuration(String filePath) async {
    try {
      // Set the audio source with the file path
      await audioService.setAudioSource(filePath);
      totalDuration = await audioService.getTotalDuration();
    } catch (e) {
      throw Exception(
          'Failed to set audio source or get duration: ${e.toString()}');
    }
  }

  Future<void> _handlePlayMusicEvent(
      PlayMusic event, Emitter<MusicPlayerState> emit) async {
    try {
      await _startPlayback();
      await _listenToPositionStream(emit);

      // Emit the initial playing state
      emit(MusicPlayingState(lastPosition, totalDuration));
    } catch (e) {
      emit(ErrorState('Failed to play MP3: ${e.toString()}'));
    }
  }

  Future<void> _startPlayback() async {
    try {
      _playerStateSubscription?.cancel(); // Cancel previous subscription if any

      // Listen for player state changes
      _playerStateSubscription =
          audioService.playerStateStream.listen((playerState) {
        if (playerState.name == "completed") {
          // Trigger PlaybackCompleted event when playback finishes
          add(const PlaybackCompleted());
        }
      });
      await audioService.play();
      // Fetch the currentPosition of the track
      lastPosition = await audioService.returnCurrentPositionOfTheTrack();

      // Trigger PlaybackCompleted event when playback finishes
      _positionSubscription?.cancel();
    } catch (e) {
      throw Exception('Failed to start playback: ${e.toString()}');
    }
  }

  Future<void> _handlePlaybackCompleted(
      PlaybackCompleted event, Emitter<MusicPlayerState> emit) async {
    add(FetchAndSaveMusicFile(AppConstants.url));
  }

  Future<void> _listenToPositionStream(Emitter<MusicPlayerState> emit) async {
    try {
      await for (final position in audioService.positionStream) {
// Check for current position greater than total duration
        if (position >= totalDuration) {
          add(FetchAndSaveMusicFile(AppConstants.url));
          // Cancel subscription
          _positionSubscription?.cancel();
          break; // Exit the loop
        } else {
          add(UpdateSliderPosition(position, totalDuration));
        }
      }
    } catch (e) {
      emit(ErrorState('Error handling position stream: ${e.toString()}'));
    }
  }

  Future<void> _onPauseMusicEvent(
      PauseMusic event, Emitter<MusicPlayerState> emit) async {
    try {
      // Pause the music
      await audioService.pause();
      double currentPosition =
          await audioService.returnCurrentPositionOfTheTrack();

      emit(MusicPausedState(currentPosition, totalDuration));
    } catch (e) {
      emit(ErrorState('Failed to pause MP3: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateSliderPosition(
      UpdateSliderPosition event, Emitter<MusicPlayerState> emit) async {
    try {
      emit(MusicPlayingState(event.position, event.totalDuration));
    } catch (e) {
      emit(ErrorState('Failed to update slider: ${e.toString()}'));
    }
  }

// Disposing all the streams used
  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    audioService.dispose();
    _playerStateSubscription?.cancel();
    return super.close();
  }
}
