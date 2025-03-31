import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class FlutterwaveService {
  final String secretKey;

  FlutterwaveService({required this.secretKey});

  /// Generate a unique transaction reference
  String generateReference() {
    return const Uuid().v4(); // Generates a UUID
  }

  /// Initialize payment with Flutterwave
  Future<Map<String, dynamic>> initializePayment({
    required double amount,
    required String email,
    required String currency,
    required String redirectUrl,
    required String? phoneNumber,
    required String customerName,
    required String title,
    required String description,
  }) async {
    const String baseUrl = "https://api.flutterwave.com/v3";
    final String reference = generateReference();

    Map<String, dynamic> data = {
      "payment_options": "card,banktransfer",
      "amount": amount,
      "email": email,
      "tx_ref": reference,
      "currency": currency,
      "redirect_url": redirectUrl,
      "customer": {"email": email, "name": customerName},
      "customizations": {"title": title, "description": description}
    };

    if (phoneNumber != null) {
      data["customer"]["phone_number"] = phoneNumber;
    }

    final response = await http.post(
      Uri.parse("$baseUrl/payments"),
      headers: {
        "Authorization": "Bearer $secretKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print(response.body);

      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to initialize payment: ${response.body}");
    }
  }
}
