import 'package:url_launcher/url_launcher.dart';

Future<void> launchWeb(String link,
    {LaunchMode mode = LaunchMode.inAppBrowserView}) async {
  final url = Uri.parse(link);
  if (!await launchUrl(
    url,
    mode: mode,
    webViewConfiguration: const WebViewConfiguration(),
  )) {
    throw Exception('Could not launch $url');
  }
}
