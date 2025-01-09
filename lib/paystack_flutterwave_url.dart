library paystack_flutterwave_url;

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:paystack_flutterwave_url/utils/constants.dart';
import 'package:paystack_flutterwave_url/utils/template.dart';
import 'package:paystack_flutterwave_url/utils/url_launcher.dart';
import 'package:paystack_flutterwave_url/utils/validate.dart';

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
  InAppWebViewController? webViewController;
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
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
        child: payCalled
            ? InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri.uri(
                    Uri.dataFromString(
                      getHtmlTemplate(widget.checkoutUrl),
                      mimeType: 'text/html',
                      encoding: Encoding.getByName('utf-8'),
                    ),
                  ),
                ),
                initialSettings: InAppWebViewSettings(
                  useShouldOverrideUrlLoading: true,
                  javaScriptEnabled: true,
                ),
                // initialOptions: InAppWebViewGroupOptions(
                //   crossPlatform: InAppWebViewOptions(
                //     useShouldOverrideUrlLoading: true,
                //     javaScriptEnabled: true,
                //   ),
                // ),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;
                  String url = uri.toString();
                  String baseGateWayUrl = checkoutType[widget.gatewayType]!;
                  log(url);
                  if (url.contains(baseGateWayUrl)) {
                    // Stay on the payment gateway
                    return NavigationActionPolicy.ALLOW;
                  } else if (url.startsWith('about:blank')) {
                    if (payCalled) {
                      log('on payCalled');
                      onFailureFunc();
                    }
                    return NavigationActionPolicy.CANCEL;
                  } else if (!url.contains(baseGateWayUrl)) {
                    if (widget.gatewayType == GatewayType.flutterwave &&
                        url.contains('status=cancelled')) {
                      onFailureFunc();
                      return NavigationActionPolicy.CANCEL;
                    }
                    onSuccessFunc();
                    return NavigationActionPolicy.CANCEL;
                  } else {
                    log('on else');

                    onFailureFunc();
                    return NavigationActionPolicy.CANCEL;
                  }
                },
              )
            : widget.loadingWidget ??
                const Center(
                  child: CircularProgressIndicator(),
                ),
      ),
    );
  }
}
