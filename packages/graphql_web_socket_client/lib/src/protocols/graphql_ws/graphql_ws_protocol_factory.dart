part of 'graphql_ws_protocol.dart';

class GraphQLWSProtocolFactory
    extends GraphQLWebSocketProtocolFactory<GraphQLWSProtocol> {
  const GraphQLWSProtocolFactory({
    required super.uri,
    required this.delegate,
  }) : super(protocols: const ['graphql-transport-ws']);

  final GraphQLWSDelegate delegate;

  @override
  GraphQLWSProtocol createProtocol(WebSocketChannel channel) =>
      GraphQLWSProtocol(
        channel: channel,
        delegate: delegate,
      );
}
