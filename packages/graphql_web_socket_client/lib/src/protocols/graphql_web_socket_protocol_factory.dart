import 'dart:async';

import 'package:graphql_web_socket_core/graphql_web_socket_core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'graphql_web_socket_protocol.dart';

abstract class GraphQLWebSocketProtocolFactory<
    P extends GraphQLWebSocketProtocol> {
  const GraphQLWebSocketProtocolFactory({
    required this.uri,
    this.protocols = const [],
  });

  final Uri uri;
  final Iterable<String> protocols;

  Future<P> create() async {
    final channel = await createChannel();
    final protocol = await createProtocol(channel);
    await protocol.initializeConnection();
    return protocol;
  }

  FutureOr<P> createProtocol(WebSocketChannel channel);

  FutureOr<WebSocketChannel> createChannel() => defaultConnectPlatform(
        uri,
        protocols,
      );
}
