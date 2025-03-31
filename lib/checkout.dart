import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:paystack_flutterwave_url/redirect_to_payment.dart';
import 'package:paystack_flutterwave_url/utils/constants.dart';
import 'package:paystack_flutterwave_url/utils/flutterwave.dart';
import 'package:paystack_flutterwave_url/utils/paystack.dart';

class CheckoutScreen extends StatefulWidget {
  final GatewayType gatewayType;
  final String secretKey;
  final int amountInKobo;
  final VoidCallback? onSuccess;
  final VoidCallback? onFailure;
  final Widget? loadingWidget;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String callbackUrl;
  final String currency;
  final String title;
  final String description;

  const CheckoutScreen({
    super.key,
    required this.gatewayType,
    required this.secretKey,
    required this.amountInKobo,
    this.onSuccess,
    this.onFailure,
    this.loadingWidget,
    required this.email,
    required this.fullName,
    required this.callbackUrl,
    this.phoneNumber,
    this.currency = "NGN",
    this.title = "Payment",
    this.description = "Payment",
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  InAppWebViewController? webViewController;
  bool payTime = false;
  bool hasReachedPayment = false;
  String? checkoutUrl;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // logic to get the checkout url
      try {
        if (widget.gatewayType == GatewayType.paystack) {
          final resData = await PaystackService(secretKey: widget.secretKey)
              .initializePayment(
                  email: widget.email,
                  fullName: widget.fullName,
                  amount: widget.amountInKobo,
                  callbackUrl: widget.callbackUrl);
          setState(() {
            checkoutUrl = resData['data']['authorization_url'];
          });
        } else {
          final resData = await FlutterwaveService(secretKey: widget.secretKey)
              .initializePayment(
                  amount: widget.amountInKobo / 100,
                  email: widget.email,
                  currency: widget.currency,
                  redirectUrl: widget.callbackUrl,
                  phoneNumber: widget.phoneNumber,
                  customerName: widget.fullName,
                  title: widget.title,
                  description: widget.description);
          setState(() {
            checkoutUrl = resData['data']['link'];
          });
        }
      } catch (e) {
        onFailureFunc();
      }
    });
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
    return checkoutUrl == null
        ? Scaffold(
            backgroundColor: Colors.white,
            body: widget.loadingWidget ??
                const Center(
                  child: CircularProgressIndicator(),
                ),
          )
        : RedirectionToPaymentScreen(
            gatewayType: widget.gatewayType,
            checkoutUrl: checkoutUrl!,
            onSuccess: widget.onSuccess,
            onFailure: widget.onFailure,
            loadingWidget: widget.loadingWidget,
          );
  }
}
