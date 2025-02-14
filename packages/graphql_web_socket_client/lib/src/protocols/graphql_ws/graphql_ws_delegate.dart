part of 'graphql_ws_protocol.dart';

class GraphQLWSDelegate extends ProtocolDelegate {
  GraphQLWSDelegate();

  final Duration pingInterval = const Duration(seconds: 10);

  final _latencyController = BehaviorSubject<Duration?>.seeded(null);

  Stream<Duration?> get latencyStream => _latencyController.stream;

  void _emitLatency(Duration? latency) => _latencyController.add(latency);

  FutureOr<PingMessage> getPingMessage() => const PingMessage();

  @mustCallSuper
  FutureOr<PongMessage> onPing(PingMessage message) => const PongMessage();

  @mustCallSuper
  @override
  FutureOr<void> dispose() async {
    await _latencyController.close();
  }
}
