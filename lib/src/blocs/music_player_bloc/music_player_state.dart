abstract class MusicPlayerState {}

class InitialState extends MusicPlayerState {}

class MusicLoadingState extends MusicPlayerState {}

class MusicLoadedState extends MusicPlayerState {}

class MusicPlayingState extends MusicPlayerState {
  final double currentPosition;
  final double totalDuration;
  MusicPlayingState(this.currentPosition, this.totalDuration);
}

class MusicPausedState extends MusicPlayerState {
  final double currentPosition;
  final double totalDuration;

  MusicPausedState(this.currentPosition, this.totalDuration);
}

class ErrorState extends MusicPlayerState {
  final String message;
  ErrorState(this.message);
}

class MusicCompletedState extends MusicPlayerState {}
