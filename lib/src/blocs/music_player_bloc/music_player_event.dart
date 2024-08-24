import 'package:equatable/equatable.dart';

abstract class MusicPlayerEvent extends Equatable {
  const MusicPlayerEvent();

  @override
  List<Object?> get props => [];
}

class FetchAndSaveMusicFile extends MusicPlayerEvent {
  final String url;

  const FetchAndSaveMusicFile(this.url);

  @override
  List<Object?> get props => [url];
}

class PlayMusic extends MusicPlayerEvent {}

class PauseMusic extends MusicPlayerEvent {}

class PlaybackCompleted extends MusicPlayerEvent {
  const PlaybackCompleted();
}

class UpdateSliderPosition extends MusicPlayerEvent {
  final double position, totalDuration;

  const UpdateSliderPosition(this.position, this.totalDuration);

  @override
  List<Object?> get props => [position, totalDuration];
}
