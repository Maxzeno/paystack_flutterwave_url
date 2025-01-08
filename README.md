# Paystack and Flutterwave URL Payment Integration

A simple Flutter package to facilitate payments via Paystack and Flutterwave checkout URLs. This package enables you to seamlessly redirect users to the respective payment gateway and handle success or failure callbacks.

## Features

- Supports **Paystack** and **Flutterwave** gateways.
- Handles payment success and failure callbacks.
- Customizable loading widget during the redirection process.

---

## Example Usage

Below is a complete example to help you integrate the package into your Flutter app:

```dart
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
  void navToPay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return RedirectionToPaymentScreen(
            gatewayType: GatewayType
                .paystack, // toggle between GatewayType.paystack and GatewayType.flutterwave
            checkoutUrl:
                "https://checkout.paystack.com/hu6b3obfydtnu49", // eg. https://checkout.paystack.com/xlt21ud3wz0985r
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

```
