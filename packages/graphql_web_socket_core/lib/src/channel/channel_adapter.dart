import 'dart:async' show Future, Stream, StreamSink;
import 'dart:convert' show Converter, json;

import 'package:web_socket_channel/status.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChannelAdapter<I, O> {
  ChannelAdapter(
    this._channel, {
    required Converter<Map<String, dynamic>, I> incomingMessageConverter,
    required Converter<O, Map<String, dynamic>> outgoingMessageConverter,
  })  : sink = ChannelAdapterSink(_channel.sink, outgoingMessageConverter),
        stream = _channel.stream
            .transform(json.decoder.fuse(incomingMessageConverter))
            .asBroadcastStream();

  final WebSocketChannel _channel;

  final Stream<I> stream;
  final StreamSink<O> sink;

  Future<void> get ready => _channel.ready;

  int? get closeCode => _channel.closeCode;

  String? get closeReason => _channel.closeReason;

  Future close([int? closeCode = normalClosure, String? closeReason]) =>
      _channel.sink.close(closeCode, closeReason);
}

class ChannelAdapterSink<C> implements StreamSink<C> {
  ChannelAdapterSink(
    this._sink,
    Converter<C, Map<String, dynamic>> outgoingMessageConverter,
  ) : _outgoingMessageConverter =
            outgoingMessageConverter.fuse(json.encoder.cast());

  final StreamSink _sink;
  final Converter<C, String> _outgoingMessageConverter;

  @override
  void add(C data) => _sink.add(_outgoingMessageConverter.convert(data));

  @override
  void addError(Object error, [StackTrace? stackTrace]) => _sink.addError(
        error,
        stackTrace,
      );

  @override
  Future<void> addStream(Stream<C> stream) => _sink.addStream(
        stream.transform(_outgoingMessageConverter),
      );

  @override
  Future<void> get done => _sink.done;

  @override
  Future close() => _sink.close();
}
