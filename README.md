# Paystack and Flutterwave URL Payment Integration

# 💳 Paystack & Flutterwave Checkout for Flutter

A Flutter package to facilitate payments via **Paystack** and **Flutterwave** checkout URLs. This package enables you to seamlessly redirect users to the respective payment gateways and handle success or failure callbacks.

---

## ✨ Features

- 🔁 Redirect users to hosted **Paystack** or **Flutterwave** checkout pages.
- ⚙️ Supports:
  - Checkout URL generated from your **backend** (recommended).
  - Checkout URL generated **from the app** (requires secret key).
- ✅ Handles:
  - **Success** callback
  - **Failure** or **Cancel** callback

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
  void payWithKey() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CheckoutScreen(
            callbackUrl: "https://www.google.com",
            secretKey: "<secreyt_key>", // Paystack secret key or public key
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
            callbackUrl: "https://www.google.com",
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

```
