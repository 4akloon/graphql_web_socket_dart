part of 'subscriptions_transports_ws_protocol.dart';

class SubscriptionsTransportsWSProtocolFactory
    extends GraphQLWebSocketProtocolFactory<SubscriptionsTransportsWSProtocol> {
  const SubscriptionsTransportsWSProtocolFactory({
    required super.uri,
    required this.delegate,
  }) : super(protocols: const ['graphql-ws']);

  final SubscriptionsTransportsWSDelegate delegate;

  @override
  SubscriptionsTransportsWSProtocol createProtocol(WebSocketChannel channel) =>
      SubscriptionsTransportsWSProtocol(
        channel: channel,
        delegate: delegate,
      );
}
