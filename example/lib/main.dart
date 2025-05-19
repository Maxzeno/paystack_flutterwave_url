import 'package:example/screens/failed.dart';
import 'package:example/screens/success.dart';
import 'package:flutter/material.dart';
import 'package:paystack_flutterwave_url/paystack_flutterwave_url.dart';
import 'package:paystack_flutterwave_url/utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PaymentPage(),
      routes: {
        '/success': (context) => const SuccessPage(),
        '/failed': (context) => const FailedPage(),
        '/payment': (context) => const PaymentPage(),
      },
    );
  }
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  void payWithKey() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CheckoutScreen(
            callbackUrl: "https://www.google.com",
            secretKey: "sk_test_d71994bd5f5740055d86931cc55e961d02bea411",
            // secretKey: "FLWSECK_TEST-d9cae45c047f9b5a40c5b5c884a2d64c-X",
            amountInMinorUnits: 10000, // 100 naira will be 1000 (kobo)
            fullName: "Emma Nwa",
            email: "emmanuelnwaegunwa@gmail.com",
            gatewayType: GatewayType
                .paystack, // toggle between GatewayType.paystack and GatewayType.flutterwave
            onSuccess: () {
              // Is called when payment succeeds
              Navigator.pushReplacementNamed(context, '/success');
            },
            onFailure: () {
              // Is called when payment fails
              Navigator.pushReplacementNamed(context, '/failed');
            },
            loadingWidget: const Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            ),
          );
        },
      ),
    );
  }

  void payWithCheckoutURL() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return RedirectionToPaymentScreen(
            callbackUrl: "https://google.com",
            gatewayType: GatewayType
                .paystack, // toggle between GatewayType.paystack and GatewayType.flutterwave
            checkoutUrl:
                "https://checkout.paystack.com/sop7flsdp5t2ure", // eg. https://checkout.paystack.com/xlt21ud3wz0985r
            onSuccess: () {
              // Is called when payment succeeds
              Navigator.pushReplacementNamed(context, '/success');
            },
            onFailure: () {
              // Is called when payment fails
              Navigator.pushReplacementNamed(context, '/failed');
            },
            loadingWidget: const Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
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
          onPressed: payWithCheckoutURL,
          child: const Text("Proceed to Payment"),
        ),
      ),
    );
  }
}
