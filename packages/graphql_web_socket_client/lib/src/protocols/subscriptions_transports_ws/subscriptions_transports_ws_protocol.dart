import 'dart:async';

import 'package:graphql_web_socket_client/graphql_web_socket_client.dart';
import 'package:graphql_web_socket_core/subscriptions_transports_ws_protocol.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'subscriptions_transports_ws_protocol_factory.dart';
part 'subscriptions_transports_ws_delegate.dart';

typedef GetInitialPayload = FutureOr<Map<String, dynamic>?> Function();

class SubscriptionsTransportsWSProtocol
    extends GraphQLWebSocketProtocol<ServerMessage, ClientMessage> {
  SubscriptionsTransportsWSProtocol({
    required WebSocketChannel channel,
    required SubscriptionsTransportsWSDelegate delegate,
  })  : _delegate = delegate,
        super(
          ChannelAdapter(
            channel,
            incomingMessageConverter: const ServerMessageFromJsonConverter(),
            outgoingMessageConverter: const ClientMessageToJsonConverter(),
          ),
        );

  final SubscriptionsTransportsWSDelegate _delegate;

  @override
  Future<void> initializeConnection() async {
    try {
      final initialPayload = await _delegate.getInitialPayload();

      channel.sink.add(ConnectionInitMessage(payload: initialPayload));
      await channel.stream
          .whereType<ConnectionAckMessage>()
          .doOnDone(() => print('disconnected'))
          .first
          .timeout(_delegate.connectionTimeout);

      print('connected');

      _listenForKeepAlive();
    } catch (error, stackTrace) {
      print(
        'Error connecting: $error\n$stackTrace \n'
        'channel reason: ${channel.closeReason} code: ${channel.closeCode}',
      );

      rethrow;
    }
  }

  void _listenForKeepAlive() {
    final timeLimit = _delegate.keepAliveInterval;
    if (timeLimit == null) return;

    channel.stream
        .whereType<ConnectionKeepAliveMessage>()
        .timeout(timeLimit)
        .listen(
      (_) => print('keep alive'),
      onError: (error, stackTrace) {
        if (error is TimeoutException) {
          final result = _delegate.onKeepAliveTimeout();

          if (result != null) {
            final (closeCode, closeReason) = result;
            close(closeCode, closeReason);
          }
        }
      },
    );
  }

  @override
  Stream<ClientOperationMessage> get stream => channel.stream.transform(
        StreamTransformer.fromHandlers(
          handleData: (message, sink) => switch (message) {
            DataMessage(:final id, :final payload) => sink.add(
                OperationDataMessage(id: id, response: payload),
              ),
            ErrorMessage(:final id, :final payload) => sink.add(
                OperationDataMessage(
                  id: id,
                  response: Response(errors: payload),
                ),
              ),
            CompleteMessage(:final id) =>
              sink.add(OperationUnsubscribeMessage(id: id)),
            _ => null,
          },
        ),
      );

  @override
  void subscribe(OperationSubscribeMessage message) =>
      channel.sink.add(StartMessage(id: message.id, payload: message.request));

  @override
  void unsubscribe(OperationUnsubscribeMessage message) =>
      channel.sink.add(StopMessage(id: message.id));

  @override
  Future close([int? closeCode, String? closeReason]) async {
    await channel.close(closeCode, closeReason);
  }
}
