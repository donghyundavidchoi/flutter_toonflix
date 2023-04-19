import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';

class WebviewScreen extends StatefulWidget {
  final String title;
  final String webtoonId;
  final WebtoonEpisodeModel episode;

  const WebviewScreen({
    Key? key,
    required this.title,
    required this.episode,
    required this.webtoonId,
  }) : super(key: key);

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  WebViewController? webviewController;

  @override
  void initState() {
    super.initState();
    webviewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00ffffff))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('www.youtube.com')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://comic.naver.com/webtoon/detail?titleId=${widget.webtoonId}&no=${widget.episode.id}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: webviewController!,
      ),
    );
  }
}
