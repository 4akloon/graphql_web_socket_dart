import 'dart:async';

import 'package:graphql_web_socket_client/src/client_operation_message.dart';
import 'package:graphql_web_socket_core/graphql_web_socket_core.dart';
import 'package:rxdart/rxdart.dart';

import 'protocols/graphql_web_socket_protocol.dart';
import 'protocols/graphql_web_socket_protocol_factory.dart';
import 'utils/id_generator.dart';

typedef SubscriptionEntity = (Request, StreamController<Response>);

enum WSClientState {
  connected,
  connecting,
  disconnected,
}

class GraphQLWebSocketClient<P extends GraphQLWebSocketProtocol> {
  GraphQLWebSocketClient({
    required GraphQLWebSocketProtocolFactory<P> protocolFactory,
    IdGenerator? idGenerator,
    Duration? autoReconnectInterval = const Duration(seconds: 1),
  })  : _protocolFactory = protocolFactory,
        _idGenerator = idGenerator ?? UuidIdGenerator(),
        _autoReconnectInterval = autoReconnectInterval;

  final GraphQLWebSocketProtocolFactory<P> _protocolFactory;
  final IdGenerator _idGenerator;
  final Duration? _autoReconnectInterval;

  P? _protocol;
  final _streamController =
      StreamController<ClientOperationMessage>.broadcast();
  final _subscriptions = <String, SubscriptionEntity>{};
  final _stateController = BehaviorSubject.seeded(
    WSClientState.disconnected,
    sync: true,
  );
  Timer? _reconnectTimer;

  Future<void> connect() async {
    if (_stateController.value != WSClientState.disconnected) return;
    print('Connecting');

    _stateController.add(WSClientState.connecting);

    try {
      final protocol = _protocol = await _protocolFactory.create();

      protocol.stream.listen(
        _streamController.add,
        onDone: _onConnectionLost,
      );

      _stateController.add(WSClientState.connected);
      print('Connected');

      _resubscribe();
    } catch (error, stackTrace) {
      print('Error connecting: $error\n$stackTrace');
      _onConnectionLost();
    }
  }

  Future<void> disconnect() async {
    if (_stateController.value != WSClientState.connected) return;

    print('Disconnecting');

    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    await _protocol?.close();
    _protocol = null;

    _stateController.add(WSClientState.disconnected);
  }

  Future<void> reconnect() async {
    await disconnect();
    if (_subscriptions.isNotEmpty) await connect();
  }

  Future<void> _onConnectionLost() async {
    print('Connection lost');
    _stateController.add(WSClientState.disconnected);
    _protocol?.delegate.onDisconnect(
      _protocol?.channel.closeCode,
      _protocol?.channel.closeReason,
    );

    if (_autoReconnectInterval != null) {
      await _reconnect();
    }
  }

  Future<void> _reconnect() async {
    if (_reconnectTimer != null ||
        _autoReconnectInterval == null ||
        _stateController.value != WSClientState.disconnected) {
      return;
    }

    if (_subscriptions.isEmpty) return;

    print('Reconnecting');

    _reconnectTimer = Timer(_autoReconnectInterval, () {
      connect();
      _reconnectTimer = null;
    });
  }

  void _resubscribe() {
    for (final MapEntry(key: id, value: (request, _))
        in _subscriptions.entries) {
      _protocol?.subscribe(OperationSubscribeMessage(id: id, request: request));
    }
  }

  Future<void> _addSubscription(
    String id,
    Request request,
    StreamController<Response> controller,
  ) async {
    _subscriptions[id] = (request, controller);
    if (_stateController.value == WSClientState.connected) {
      _protocol?.subscribe(OperationSubscribeMessage(id: id, request: request));
    } else {
      connect();
    }
  }

  Future<void> _removeSubscription(String id) async {
    _subscriptions.remove(id);
    _protocol?.unsubscribe(OperationUnsubscribeMessage(id: id));

    if (_subscriptions.isEmpty) await disconnect();
  }

  Stream<Response> createSubscriptionStream(Request request) {
    final controller = StreamController<Response>();

    final id = _idGenerator.generate();

    final subscription = _streamController.stream
        .where((message) => message.id == id)
        .takeWhile((message) => message is! OperationUnsubscribeMessage)
        .whereType<OperationDataMessage>()
        .map((message) => message.response)
        .listen(
          controller.add,
          onError: controller.addError,
          onDone: controller.close,
        );

    controller.onListen = () {
      print('Subscribing to $id');
      _addSubscription(id, request, controller);
    };

    controller.onCancel = () {
      print('Unsubscribing from $id');
      _removeSubscription(id);

      controller.close();
      subscription.cancel();
    };

    return controller.stream;
  }

  Future<void> dispose() async {
    await _streamController.close();
    await _stateController.close();
    _reconnectTimer?.cancel();
    await Future.wait(_subscriptions.values.map((sub) => sub.$2.close()));
    _subscriptions.clear();
    await disconnect();
  }
}
