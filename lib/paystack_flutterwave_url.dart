library paystack_flutterwave_url;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paystack_flutterwave_url/utils/enum.dart';
import 'package:paystack_flutterwave_url/utils/template.dart';
import 'package:paystack_flutterwave_url/utils/url_launcher.dart';
import 'package:paystack_flutterwave_url/utils/validate.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RedirectionToPaymentScreen extends StatefulWidget {
  final GatewayType gatewayType;
  final String checkoutUrl;
  final VoidCallback? onSuccess;
  final VoidCallback? onFailure;
  final Widget? loadingWidget;

  const RedirectionToPaymentScreen({
    super.key,
    required this.gatewayType,
    required this.checkoutUrl,
    this.onSuccess,
    this.onFailure,
    this.loadingWidget,
  });

  @override
  State<RedirectionToPaymentScreen> createState() =>
      _RedirectionToPaymentScreenState();
}

class _RedirectionToPaymentScreenState
    extends State<RedirectionToPaymentScreen> {
  WebViewController? webViewController;
  late Timer timer;
  bool payCalled = false;

  @override
  void initState() {
    super.initState();

    timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        payCalled = true;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kIsWeb) {
        launchWeb(widget.checkoutUrl, onFailureFunc: onFailureFunc);
      } else {
        if (!isValidUrl(widget.checkoutUrl, widget.gatewayType)) {
          onFailureFunc();
          return;
        }
        payFunc();
      }
    });
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
            String baseGateWayUrl = {
              GatewayType.paystack: 'paystack.com',
              GatewayType.flutterwave: 'flutterwave.com',
            }[widget.gatewayType]!;
            if (url.contains(baseGateWayUrl)) {
              // Stay on the payment gateway
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
      ..loadHtmlString(getHtmlTemplate(widget.checkoutUrl));
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: payCalled && webViewController != null
            ? WebViewWidget(controller: webViewController!)
            : Center(
                child:
                    widget.loadingWidget ?? const CircularProgressIndicator()),
      ),
    );
  }
}
