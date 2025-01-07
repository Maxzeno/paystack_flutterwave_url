import 'package:flutter/foundation.dart';
import 'package:paystack_flutterwave_url/utils/enum.dart';

void handleUrlNavigation({
  required String url,
  required GatewayType gatewayType,
  required VoidCallback onSuccessFunc,
  required VoidCallback onFailureFunc,
  required bool payCalled,
}) {
  String baseGateWayUrl = {
    GatewayType.paystack: 'paystack.com',
    GatewayType.flutterwave: 'flutterwave.com',
  }[gatewayType]!;
  if (url.contains(baseGateWayUrl)) {
    // Stay on the payment gateway
  } else if (url.startsWith('about:blank') && payCalled) {
    onFailureFunc();
  } else if (!url.contains(baseGateWayUrl)) {
    if (gatewayType == GatewayType.flutterwave &&
        url.contains('status=cancelled')) {
      onFailureFunc();
      return;
    }
    onSuccessFunc();
  } else {
    onFailureFunc();
  }
}
