import 'dart:async';

import 'package:graphql_web_socket_client/graphql_web_socket_client.dart';
import 'package:rxdart/rxdart.dart';

abstract class GraphQLWebSocketProtocol<SM, CM, D extends ProtocolDelegate> {
  GraphQLWebSocketProtocol(this.channel, this.delegate) {
    channel.stream.doOnDone(
      () => delegate.onDisconnect(channel.closeCode, channel.closeReason),
    );
  }

  final ChannelAdapter<SM, CM> channel;
  final D delegate;

  Future<void> initializeConnection();

  Stream<ClientOperationMessage> get stream;

  void subscribe(OperationSubscribeMessage message);

  void unsubscribe(OperationUnsubscribeMessage message);

  Future close([int? closeCode, String? closeReason]);
}
