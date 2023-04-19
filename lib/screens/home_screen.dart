import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
        foregroundColor: const Color(0xff3eaf0e),
        title: const Text('NAVER'),
        titleTextStyle: const TextStyle(
          color: Color(0xff3eaf0e),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              color: const Color(0xffffffff),
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Color(0xffffffff),
                            Color(0xffffffff),
                            Color(0xff3eaf0e),
                          ])),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              '오늘',
                              style: TextStyle(
                                color: Color(0xff3eaf0e),
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '의 ',
                              style: TextStyle(
                                color: Color(0xff3eaf0e),
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'NAVER',
                              style: TextStyle(
                                color: Color(0xff3eaf0e),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '웹',
                              style: TextStyle(
                                color: Color(0xff3eaf0e),
                                fontSize: 130,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '툰',
                              style: TextStyle(
                                color: Color(0xff3eaf0e),
                                fontSize: 110,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.02,
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder(
                      future: webtoons,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CarouselSlider.builder(
                            carouselController: CarouselController(),
                            options: CarouselOptions(
                              height: MediaQuery.of(context).size.height,
                              aspectRatio: 16 / 9,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.4,
                              initialPage: 0,
                              viewportFraction: 0.7,
                              enableInfiniteScroll: true,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index, realIndex) {
                              var webtoon = snapshot.data![index];
                              return SingleChildScrollView(
                                child: Webtoon(
                                  title: webtoon.title,
                                  thumb: webtoon.thumb,
                                  id: webtoon.id,
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
