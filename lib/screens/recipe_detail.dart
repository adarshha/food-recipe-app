import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeDetail extends StatefulWidget {
  String url;
  RecipeDetail(this.url);
  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  String url;

  @override
  void initState() {
    if (widget.url.toString().contains("http://")) {
      url = widget.url.toString().replaceAll("http://", "https://");
    } else {
      url = widget.url;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details'),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff213A50),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: Container(
        child: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            setState(() {
              controller.complete(webViewController);
            });
          },
        ),
      ),
    );
  }
}
