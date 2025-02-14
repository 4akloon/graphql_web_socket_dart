import 'dart:async';

import 'package:graphql_web_socket_client/src/client_operation_message.dart';
import 'package:graphql_web_socket_core/graphql_web_socket_core.dart';
import 'package:graphql_web_socket_core/graphql_ws_protocol.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../graphql_web_socket_delegate.dart';
import '../graphql_web_socket_protocol.dart';
import '../graphql_web_socket_protocol_factory.dart';

part 'graphql_ws_protocol_factory.dart';
part 'graphql_ws_delegate.dart';

typedef GetInitialPayload = FutureOr<Map<String, dynamic>?> Function();

class GraphQLWSProtocol
    extends GraphQLWebSocketProtocol<ServerMessage, ClientMessage> {
  GraphQLWSProtocol({
    required WebSocketChannel channel,
    required GraphQLWSDelegate delegate,
  })  : _delegate = delegate,
        super(
          ChannelAdapter(
            channel,
            incomingMessageConverter: const ServerMessageFromJsonConverter(),
            outgoingMessageConverter: const ClientMessageToJsonConverter(),
          ),
        );

  final GraphQLWSDelegate _delegate;

  Timer? _pingTimer;

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

      _pingServer();

      channel.stream.listen(
        (message) => switch (message) {
          final PingMessage message => _onPing(message),
          _ => null,
        },
        onDone: _onConnectionLost,
      );

      print('connected');
    } catch (error, stackTrace) {
      print(
        'Error connecting: $error\n$stackTrace \n'
        'channel reason: ${channel.closeReason} code: ${channel.closeCode}',
      );
      _onConnectionLost();

      rethrow;
    }
  }

  @override
  Stream<ClientOperationMessage> get stream => channel.stream.transform(
        StreamTransformer.fromHandlers(
          handleData: (message, sink) => switch (message) {
            NextMessage(:final id, :final payload) => sink.add(
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
  void subscribe(OperationSubscribeMessage message) => channel.sink
      .add(SubscribeMessage(id: message.id, payload: message.request));

  @override
  void unsubscribe(OperationUnsubscribeMessage message) =>
      channel.sink.add(CompleteMessage(id: message.id));

  void _schedulePing() {
    _pingTimer?.cancel();
    _pingTimer = Timer(_delegate.pingInterval, _pingServer);
  }

  Future<void> _pingServer() async {
    final stopwatch = Stopwatch()..start();

    final ping = await _delegate.getPingMessage();

    channel.sink.add(ping);

    try {
      await channel.stream
          .whereType<PongMessage>()
          .first
          .timeout(const Duration(seconds: 5));

      final elapsed = stopwatch.elapsed;

      _delegate._emitLatency(elapsed);
      print('Latency: ${elapsed.inMilliseconds}ms');
    } on TimeoutException {
      _delegate._emitLatency(null);
    } finally {
      stopwatch.stop();
      _schedulePing();
    }
  }

  Future<void> _onPing(PingMessage message) async {
    final pong = await _delegate.onPing(message);
    channel.sink.add(pong);
  }

  void _onConnectionLost() {
    _pingTimer?.cancel();
    _delegate._emitLatency(null);
  }

  @override
  Future close([int? closeCode, String? closeReason]) async {
    _onConnectionLost();
    await channel.close(closeCode, closeReason);
  }
}
