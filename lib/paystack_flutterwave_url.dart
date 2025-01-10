library paystack_flutterwave_url;

import 'dart:convert';

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
  bool payTime = false;
  bool hasReachedPayment = false;

  @override
  void initState() {
    super.initState();

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
    final media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          InAppWebView(
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
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, uri) async {
              String url = uri.toString();

              if (url.startsWith('data:text/html;') && hasReachedPayment) {
                onFailureFunc();
                return;
              }
            },
            onLoadStop: (controller, uri) async {
              String url = uri.toString();
              String baseGateWayUrl = checkoutType[widget.gatewayType]!;

              if (url.contains(baseGateWayUrl)) {
                setState(() {
                  hasReachedPayment = true;
                  payTime = true;
                });
                return;
              }
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url!;
              String url = uri.toString();
              String baseGateWayUrl = checkoutType[widget.gatewayType]!;
              if (url.contains(baseGateWayUrl)) {
                // Stay on the payment gateway
                return NavigationActionPolicy.ALLOW;
              } else if (url.contains('about:blank')) {
                webViewController!.loadUrl(
                  urlRequest: URLRequest(
                    url: WebUri.uri(
                      Uri.dataFromString(
                        getHtmlTemplate(widget.checkoutUrl),
                        mimeType: 'text/html',
                        encoding: Encoding.getByName('utf-8'),
                      ),
                    ),
                  ),
                );
              } else if (!url.contains(baseGateWayUrl)) {
                if (widget.gatewayType == GatewayType.flutterwave &&
                    url.contains('status=cancelled')) {
                  onFailureFunc();
                  return NavigationActionPolicy.CANCEL;
                }
                onSuccessFunc();
                return NavigationActionPolicy.CANCEL;
              } else {
                onFailureFunc();
                return NavigationActionPolicy.CANCEL;
              }
              return null;
            },
          ),
          if (!payTime)
            Positioned(
              height: media.height,
              width: media.width,
              child: widget.loadingWidget ??
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
            )
        ],
      )),
    );
  }
}
