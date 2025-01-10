# Paystack and Flutterwave URL Payment Integration

A simple Flutter package to facilitate payments via Paystack and Flutterwave checkout URLs. This package enables you to seamlessly redirect users to the respective payment gateway and handle success or failure callbacks.

<p align="center">

  <a href="https://pub.dev/packages/paystack_flutterwave_url"><img src="https://raw.githubusercontent.com/Maxzeno/paystack_flutterwave_url/main/asset/paystack1.png" alt="Paystack" height="400" width="200"/></a>
  <a href="https://pub.dev/packages/paystack_flutterwave_url"><img src="https://raw.githubusercontent.com/Maxzeno/paystack_flutterwave_url/main/asset/paystack2.png" alt="Paystack" height="400" width="200"/></a>
  <br/>
  <a href="https://pub.dev/packages/paystack_flutterwave_url"><img src="https://raw.githubusercontent.com/Maxzeno/paystack_flutterwave_url/main/asset/flutterwave1.png" alt="Flutterwave" height="400" width="200"/></a>
  <a href="https://pub.dev/packages/paystack_flutterwave_url"><img src="https://raw.githubusercontent.com/Maxzeno/paystack_flutterwave_url/main/asset/flutterwave2.png" alt="Flutterwave" height="400" width="200"/></a>
</p>

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
                "Checkout url for paystack or flutterwave", // eg. https://checkout.paystack.com/xlt21ud3wz0985r
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
          onPressed: navToPay,
          child: const Text("Proceed to Payment"),
        ),
      ),
    );
  }
}

```
