import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerPage extends StatelessWidget {
  const MovieTrailerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final url = ModalRoute.of(context)?.settings.arguments as String;
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: url,
    );
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: controller,
        progressColors: const ProgressBarColors(
          playedColor: Color(0xff0296E5),
          handleColor: Colors.white
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Column(
            children: [
              player,
            ],
          ),
        );
      },
    );
  }
}
