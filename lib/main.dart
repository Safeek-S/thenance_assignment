import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/src/blocs/music_player_bloc/music_player_bloc.dart';
import 'package:musicplayer/src/blocs/music_player_bloc/music_player_event.dart';
import 'package:musicplayer/src/core/constants.dart';
import 'package:musicplayer/src/screens/music_player/music_player_screen.dart';
import 'package:musicplayer/src/services/api_service/api_service.dart';
import 'package:musicplayer/src/services/api_service/api_service_impl.dart';
import 'package:musicplayer/src/services/audio_service/audio_service.dart';
import 'package:musicplayer/src/services/audio_service/audio_service_impl.dart';
import 'package:musicplayer/src/services/file_service/file_service.dart';
import 'package:musicplayer/src/services/file_service/file_service_impl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  // DI
  final IApiService apiService = ApiServiceImpl();
  final IAudioService audioService = AudioServiceImpl();
  final IFileService fileService = FileServiceImpl();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MusicPlayerBloc(
          apiService: apiService,
          fileService: fileService,
          audioService: audioService)
        ..add( FetchAndSaveMusicFile(AppConstants.url)),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff4E4BE4),
      ),
    ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MusicPlayerScreen(),
      ),
    );
  }
}
