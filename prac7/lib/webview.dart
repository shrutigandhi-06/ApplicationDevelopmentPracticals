import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

class webView extends StatefulWidget {
  @override
  _webViewState createState() => _webViewState();
}

class _webViewState extends State<webView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return const WebView(
      initialUrl: 'https://flutter.dev',
    );
  }
}
