import 'package:flutter/material.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/screens/webview_screen.dart';

class Episode extends StatelessWidget {
  final String title;
  final String webtoonId;
  final WebtoonEpisodeModel episode;

  const Episode({
    Key? key,
    required this.title,
    required this.episode,
    required this.webtoonId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebviewScreen(
                  title: title, episode: episode, webtoonId: webtoonId),
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xff000000).withOpacity(0.8),
            width: 2,
          ),
          color: const Color(0xffffffff).withOpacity(0.9),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 22,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                episode.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              const Icon(Icons.chevron_right_sharp),
            ],
          ),
        ),
      ),
    );
  }
}
