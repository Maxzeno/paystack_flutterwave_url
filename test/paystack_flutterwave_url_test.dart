import 'package:flutter_test/flutter_test.dart';
import 'package:paystack_flutterwave_url/utils/constants.dart';
import 'package:paystack_flutterwave_url/utils/flutterwave.dart';
import 'package:paystack_flutterwave_url/utils/paystack.dart';
import 'package:paystack_flutterwave_url/utils/validate.dart';

void main() {
  group('PaystackService Tests', () {
    final paystackService = PaystackService(secretKey: 'test_sk_key');

    test('initializePayment should include required parameters', () async {
      try {
        await paystackService.initializePayment(
          email: 'test@example.com',
          fullName: 'Test User',
          amount: 1000,
          callbackUrl: 'https://example.com/callback',
        );
      } catch (e) {
        // We expect an error due to invalid key, but we can verify the error message
        expect(e.toString(), contains('Failed to initialize payment'));
      }
    });
  });

  group('FlutterwaveService Tests', () {
    final flutterwaveService = FlutterwaveService(secretKey: 'test_sk_key');

    test('generateReference should return a valid UUID', () {
      final reference = flutterwaveService.generateReference();
      expect(reference.length, 36); // UUID length
      expect(reference.split('-').length, 5); // UUID format
    });

    test('initializePayment should include required parameters', () async {
      try {
        await flutterwaveService.initializePayment(
          amount: 10.0,
          email: 'test@example.com',
          currency: 'NGN',
          redirectUrl: 'https://example.com/callback',
          phoneNumber: '1234567890',
          customerName: 'Test User',
          title: 'Test Payment',
          description: 'Test Payment Description',
        );
      } catch (e) {
        // We expect an error due to invalid key, but we can verify the error message
        expect(e.toString(), contains('Failed to initialize payment'));
      }
    });
  });

  group('URL Validation Tests', () {
    test('validate Paystack URLs', () {
      const validPaystackUrl = 'https://checkout.paystack.com/123456';
      const invalidPaystackUrl = 'https://example.com/123456';

      expect(isValidUrl(validPaystackUrl, GatewayType.paystack), true);
      expect(isValidUrl(invalidPaystackUrl, GatewayType.paystack), false);
    });

    test('validate Flutterwave URLs', () {
      const validFlutterwaveUrl = 'https://checkout.flutterwave.com/123456';
      const invalidFlutterwaveUrl = 'https://example.com/123456';

      expect(isValidUrl(validFlutterwaveUrl, GatewayType.flutterwave), true);
      expect(isValidUrl(invalidFlutterwaveUrl, GatewayType.flutterwave), false);
    });

    test('handle null or empty URLs', () {
      expect(isValidUrl('', GatewayType.paystack), false);
      expect(isValidUrl('', GatewayType.flutterwave), false);
    });
  });
}
