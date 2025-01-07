import 'package:paystack_flutterwave_url/utils/enum.dart';

bool isValidUrl(String url, GatewayType gatewayType) {
  if ((url.contains('paystack.com') && gatewayType == GatewayType.paystack) ||
      (url.contains('flutterwave.com') &&
          gatewayType == GatewayType.flutterwave)) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
  return false;
}
