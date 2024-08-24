import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/src/blocs/music_player_bloc/music_player_bloc.dart';
import 'package:musicplayer/src/blocs/music_player_bloc/music_player_event.dart';
import 'package:musicplayer/src/blocs/music_player_bloc/music_player_state.dart';
import 'package:musicplayer/src/core/constants.dart';

import 'widgets/audio_wave_form.dart';
import 'widgets/custom_slider.dart';
import 'widgets/icon_button.dart';

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is MusicLoadingState) {
            // Show loader while music is loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ErrorState) {
            // Show snackbar for errors
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Something went wrong!")));
            return const SizedBox.shrink();
          } else if (state is MusicLoadedState ||
              state is MusicPlayingState ||
              state is MusicPausedState ||
              state is MusicCompletedState) {
            // Set the default values for current position and total duration
            double currentPosition = 0;
            double totalDuration = 100;
            if (state is MusicPlayingState) {
              currentPosition = state.currentPosition;
              totalDuration = state.totalDuration;
            } else if (state is MusicPausedState) {
              currentPosition = state.currentPosition;
              totalDuration = state.totalDuration;
            }
            return Stack(
              children: [
                  Container(
                    
          color: const Color(0xFF6200EE), // Base solid color
        ),
                Container(
                  decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  stops: const [
                    0,
                    1
                  ],
                  colors: [
                    const Color(0xFF7951EA).withOpacity(1),
                    const Color(0xFF477EEA).withOpacity(0.5),
                  ]),
            ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 3,
                          child: SizedBox(
                            width: 300,
                            height: 100,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomSlider(
                                  currentPosition: currentPosition,
                                  totalDuration: totalDuration,
                                  onChanged: (value) {
                                    context.read<MusicPlayerBloc>().add(
                                          UpdateSliderPosition(
                                            value,
                                            state is MusicPlayingState
                                                ? state.totalDuration
                                                : 100,
                                          ),
                                        );
                                  },
                                ),
                                Row(
                                  children: [
                                    const PlayPauseButton(),
                                    SizedBox(
                                      width: 200,
                                      height: 50,
                                      child: CustomPaint(
                                        painter: WavePainter(
                                            waveformValues:
                                                AppConstants.waveformValues,
                                            waveColor: const Color(0xff5E72A5),
                                            strokeValue: 3,
                                            verticalCenter:
                                                AppConstants.verticalCenter),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
