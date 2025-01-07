import 'package:flutter/material.dart';
import 'package:paystack_flutterwave_url/paystack_flutterwave_url.dart';
import 'package:paystack_flutterwave_url/utils/enum.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  void navToPay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return RedirectionToPaystackScreen(
            gatewayType: GatewayType.flutterwave,
            checkoutUrl:
                "https://checkout-v2.dev-flutterwave.com/v3/hosted/pay/e9ca5500a74e842d7209",
            onSuccess: () {
              Navigator.pushReplacementNamed(context, '/success');
            },
            onFailure: () {
              Navigator.pushReplacementNamed(context, '/failed');
            },
            loadingWidget: const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: navToPay,
          child: const Text("Proceed to Payment"),
        ),
      ),
    );
  }
}
