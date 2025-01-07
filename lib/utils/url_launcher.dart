import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchWeb(String link,
    {required VoidCallback onFailureFunc}) async {
  final url = Uri.parse(link);
  if (!await launchUrl(
    url,
    mode: LaunchMode.inAppBrowserView,
    webViewConfiguration: const WebViewConfiguration(),
  )) {
    onFailureFunc();
  }
}
