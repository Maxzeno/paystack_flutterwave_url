import 'package:paystack_flutterwave_url/utils/constants.dart';

bool isValidUrl(String url, GatewayType gatewayType) {
  String? baseGateWayUrl = checkoutType[gatewayType];

  if (baseGateWayUrl != null && url.contains(baseGateWayUrl)) {
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }
  return false;
}
