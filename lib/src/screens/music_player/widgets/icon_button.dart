import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/src/blocs/music_player_bloc/music_player_bloc.dart';
import 'package:musicplayer/src/blocs/music_player_bloc/music_player_event.dart';
import 'package:musicplayer/src/blocs/music_player_bloc/music_player_state.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      builder: (context, state) {
        if (state is MusicLoadingState) {
          // Show loader while loading
          return const CircularProgressIndicator();
        }

        // Determine the icon and action based on the current state
        IconData icon;
        VoidCallback? onPressed;

        if (state is MusicPlayingState) {
          // Show pause icon when music is playing
          icon = Icons.pause;
          onPressed = () => context.read<MusicPlayerBloc>().add(PauseMusic());
        } else if (state is MusicPausedState || state is MusicLoadedState) {
          // Show play icon when music is paused or loaded
          icon = Icons.play_arrow;
          onPressed = () => context.read<MusicPlayerBloc>().add(PlayMusic());
        } else {
          // Default icon
          icon = Icons.play_arrow;
          // Default state before music is loaded
          onPressed = null;
        }

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
          ),
          onPressed: onPressed,
          child: Icon(icon),
        );
      },
    );
  }
}
