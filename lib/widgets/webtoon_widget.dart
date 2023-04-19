import 'package:flutter/material.dart';
import 'package:toonflix/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;

  const Webtoon({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  Route fadeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => DetailScreen(
        title: title,
        thumb: thumb,
        id: id,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            fadeRoute(),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 60,
            horizontal: 5,
          ),
          child: Column(
            children: [
              Hero(
                tag: id,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff000000).withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 7,
                        offset: const Offset(9, 12),
                      ),
                    ],
                  ),
                  child: Image.network(thumb),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
