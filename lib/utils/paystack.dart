import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class PaystackService {
  final String secretKey;

  PaystackService({required this.secretKey});

  Future<Map<String, dynamic>> initializePayment({
    String? reference,
    required String email,
    required String fullName,
    required int amount,
    required String callbackUrl,
  }) async {
    const String url = "https://api.paystack.co/transaction/initialize";
    final String txRef = reference ?? const Uuid().v4();

    final Map<String, dynamic> formData = {
      'reference': txRef,
      'email': email,
      'full_name': fullName,
      'amount': amount,
      "callback_url": callbackUrl,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $secretKey",
        "Content-Type": "application/json",
        "Cache-Control": "no-cache",
      },
      body: jsonEncode(formData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to initialize payment: ${response.body}");
    }
  }
}
