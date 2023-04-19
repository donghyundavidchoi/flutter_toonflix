import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/widgets/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoonDetail;
  late Future<List<WebtoonEpisodeModel>> webtoonEpisodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (likedToons.contains(widget.id) == true) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList('likedToons', []);
    }
  }

  @override
  void initState() {
    super.initState();
    webtoonDetail = ApiService.getToonsById(widget.id);
    webtoonEpisodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        leadingWidth: 70,
        elevation: 0,
        backgroundColor: const Color(0xffffffff).withOpacity(0.8),
        foregroundColor: const Color(0xff000000),
        title: Text(widget.title),
        titleTextStyle: const TextStyle(
          color: Color(0xff000000),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            onPressed: onHeartTap,
            icon: Icon(
              color: const Color(0xffff3434),
              isLiked ? Icons.favorite_rounded : Icons.add_circle_outline_sharp,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.thumb),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 40,
                sigmaY: 40,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 140,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: widget.id,
                          child: Container(
                            width: 300,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff000000).withOpacity(0.3),
                                  blurRadius: 12,
                                  spreadRadius: 7,
                                  offset: const Offset(9, 12),
                                ),
                              ],
                            ),
                            child: Image.network(widget.thumb),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Container(
                      color: const Color(0xffffffff).withOpacity(0.4),
                      child: FutureBuilder(
                        future: webtoonDetail,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 70,
                                right: 70,
                                top: 36,
                                bottom: 38,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${snapshot.data!.genre} / ${snapshot.data!.age}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 22,
                                  ),
                                  Text(
                                    snapshot.data!.about,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                      ),
                      child: FutureBuilder(
                        future: webtoonEpisodes,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                for (var episode in snapshot.data!)
                                  Episode(
                                    title: widget.title,
                                    episode: episode,
                                    webtoonId: widget.id,
                                  ),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
