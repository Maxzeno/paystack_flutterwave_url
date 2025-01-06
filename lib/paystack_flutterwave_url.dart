library paystack_flutterwave_url;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paystack_flutterwave_url/utils/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum GatewayType {
  paystack,
  flutterwave,
}

class RedirectionToPaystackScreen extends StatefulWidget {
  final GatewayType gatewayType;
  final String checkoutUrl;
  final VoidCallback? onSuccess;
  final VoidCallback? onFailure;
  final Widget? loadingWidget;
  const RedirectionToPaystackScreen({
    super.key,
    required this.gatewayType,
    required this.checkoutUrl,
    this.onSuccess,
    this.onFailure,
    this.loadingWidget,
  });

  @override
  State<RedirectionToPaystackScreen> createState() =>
      _RedirectionToPaystackScreenState();
}

class _RedirectionToPaystackScreenState
    extends State<RedirectionToPaystackScreen> {
  late WebViewController webViewController;
  late Timer timer;
  late String baseGateWayUrl;
  bool payCalled = false;

  @override
  void initState() {
    if (widget.gatewayType == GatewayType.paystack) {
      baseGateWayUrl = 'paystack.com/';
    } else {
      baseGateWayUrl = 'flutterwave.com/';
    }
    // give 2 seconds delay before setting payCalled to true
    timer = Timer(
      const Duration(seconds: 2),
      () {
        setState(() {
          payCalled = true;
        });
      },
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (kIsWeb) {
          launchWeb(widget.checkoutUrl);
        } else {
          payFunc();
        }
      },
    );

    super.initState();
  }

  void onSuccessFunc() {
    if (widget.onSuccess != null) {
      widget.onSuccess!();
      return;
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void onFailureFunc() {
    if (widget.onFailure != null) {
      widget.onFailure!();
      return;
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  payFunc() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent('Flutter;Webview')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) async {
            if (url.contains(baseGateWayUrl)) {
              // do nothing
            } else if (url.startsWith('about:blank')) {
              if (payCalled) {
                onFailureFunc();
              }
            } else if (!url.contains(baseGateWayUrl)) {
              if (widget.gatewayType == GatewayType.flutterwave &&
                  url.contains('status=cancelled')) {
                onFailureFunc();
                return;
              }
              onSuccessFunc();
              return;
            } else {
              onFailureFunc();
            }
          },
        ),
      )
      ..loadHtmlString('''
<!DOCTYPE html>
<html>
<head>
  <title>Payment</title>
  <script type="text/javascript">
    function redirectToUrl() {
      setTimeout(function() {
        window.location.href = '${widget.checkoutUrl}';
      }, 10);
    }
  </script>
</head>
<body onload="redirectToUrl()">
  <h1></h1>
</body>
</html>
''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: payCalled
            ? WebViewWidget(
                controller: webViewController,
              )
            : widget.loadingWidget ??
                const Center(
                  child: CircularProgressIndicator(),
                ),
      ),
    );
  }
}
