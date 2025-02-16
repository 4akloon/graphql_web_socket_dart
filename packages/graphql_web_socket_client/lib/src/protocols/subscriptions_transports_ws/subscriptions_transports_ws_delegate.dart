part of 'subscriptions_transports_ws_protocol.dart';

class SubscriptionsTransportsWSDelegate extends ProtocolDelegate {
  const SubscriptionsTransportsWSDelegate();

  Duration? get keepAliveInterval => null;

  (int, String?)? onKeepAliveTimeout() =>
      (3008, 'keep alive timeout'); // 3008 is the code for timeout
}
