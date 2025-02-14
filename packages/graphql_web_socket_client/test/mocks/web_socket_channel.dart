import 'dart:async';

import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MockWebSocketChannel extends StreamChannelMixin
    implements WebSocketChannel {
  MockWebSocketChannel()
      : _serverMessageController = StreamController<String>.broadcast(),
        _clientMessageController = StreamController<String>.broadcast();

  final StreamController<String> _serverMessageController;
  final StreamController<String> _clientMessageController;

  (int? closeCode, String? closeReason)? _closeData;

  @override
  int? get closeCode => _closeData?.$1;

  @override
  String? get closeReason => _closeData?.$2;

  @override
  final String? protocol = null;

  @override
  Future<void> get ready => Future.delayed(Duration.zero);

  @override
  WebSocketSink get sink => MockWebSocketSink(this);

  @override
  Stream get stream => _serverMessageController.stream;

  void addServerMessage(String message) =>
      _serverMessageController.add(message);

  Stream<String> get clientMessageStream => _clientMessageController.stream;

  void dispose() {
    _serverMessageController.close();
    _clientMessageController.close();
  }
}

class MockWebSocketSink implements WebSocketSink {
  MockWebSocketSink(this._channel)
      : _sink = _channel._clientMessageController.sink;

  final MockWebSocketChannel _channel;
  final StreamSink<String> _sink;

  @override
  void add(dynamic data) => _sink.add(data);

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _sink.addError(error, stackTrace);

  @override
  Future addStream(Stream stream) => _sink.addStream(stream.cast<String>());

  @override
  Future get done => _sink.done;

  @override
  Future<void> close([int? closeCode, String? closeReason]) {
    _channel._closeData = (closeCode, closeReason);
    return _sink.close();
  }
}
