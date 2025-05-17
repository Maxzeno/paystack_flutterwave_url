import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paystack_flutterwave_url/utils/constants.dart';
import 'package:paystack_flutterwave_url/utils/template.dart';
import 'package:paystack_flutterwave_url/utils/url_launcher.dart';
import 'package:paystack_flutterwave_url/utils/validate.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RedirectionToPaymentScreen extends StatefulWidget {
  final GatewayType gatewayType;
  final String checkoutUrl;
  final String callbackUrl;
  final VoidCallback? onSuccess;
  final VoidCallback? onFailure;
  final Widget? loadingWidget;

  const RedirectionToPaymentScreen({
    super.key,
    required this.gatewayType,
    required this.callbackUrl,
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
  bool payTime = false;
  bool hasReachedPayment = false;

  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (kIsWeb) {
  //       launchWeb(widget.checkoutUrl, onFailureFunc: onFailureFunc);
  //     } else {
  //       if (!isValidUrl(widget.checkoutUrl, widget.gatewayType)) {
  //         onFailureFunc();
  //         return;
  //       }
  //     }
  //   });
  // }

  WebViewController? webViewController;
  bool payCalled = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (kIsWeb) {
          launchWeb(widget.checkoutUrl, onFailureFunc: onFailureFunc);
        } else {
          if (!isValidUrl(widget.checkoutUrl, widget.gatewayType)) {
            onFailureFunc();
            return;
          }
        }

        payFunc();

        Timer(
          const Duration(seconds: 2),
          () {
            setState(() {
              payCalled = true;
            });
          },
        );
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    webViewController?.clearCache();
    webViewController = null;
    super.dispose();
  }

  void payFunc() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent('Flutter;Webview')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) async {
            if (url.startsWith('https://checkout.paystack.com') ||
                url.startsWith('https://checkout.paystack.com')) {
            } else if (url.startsWith('about:blank')) {
              // if 2 sends passed and your back we take you out
              if (payCalled) {
                Navigator.pop(context);
              }
            } else if (url.startsWith(widget.callbackUrl) &&
                url.contains("trxref=")) {
              onSuccessFunc();
              return;
            } else if (url.startsWith("https://standard.paystack.co") &&
                !url.startsWith("'https://standard.paystack.co/close'")) {
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
      appBar: payCalled
          ? AppBar(
              backgroundColor: payCalled ? Colors.white : null,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.canPop(context),
              ),
            )
          : null,
      backgroundColor: payCalled ? Colors.white : Colors.blue,
      body: SafeArea(
        child: payCalled && webViewController != null
            ? WebViewWidget(
                controller: webViewController!,
              )
            : widget.loadingWidget ??
                const CircularProgressIndicator(
                  color: Colors.blue,
                ),
      ),
    );
  }
}
