import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:graphql_web_socket_core/graphql_web_socket_core.dart';

part 'connection_init_message.dart';
part 'connection_ack_message.dart';
part 'ping_message.dart';
part 'pong_message.dart';
part 'subscribe_message.dart';
part 'next_message.dart';
part 'error_message.dart';
part 'complete_message.dart';

mixin ChunkedConversionSinkConverter<S, T> on Converter<S, T> {
  @override
  Sink<S> startChunkedConversion(Sink<T> sink) =>
      ChunkedConversionSink.withCallback(
        (accumulated) {
          for (final value in accumulated) {
            sink.add(convert(value));
          }
          sink.close();
        },
      );
}

class ServerMessageCodec extends Codec<ServerMessage, Map<String, dynamic>> {
  const ServerMessageCodec();

  @override
  final Converter<Map<String, dynamic>, ServerMessage> decoder =
      const ServerMessageFromJsonConverter();

  @override
  final Converter<ServerMessage, Map<String, dynamic>> encoder =
      const ServerMessageToJsonConverter();
}

class ServerMessageFromJsonConverter
    extends Converter<Map<String, dynamic>, ServerMessage>
    with ChunkedConversionSinkConverter {
  const ServerMessageFromJsonConverter();

  @override
  ServerMessage convert(Map<String, dynamic> input) =>
      ServerMessage.fromJson(input);
}

class ServerMessageToJsonConverter
    extends Converter<ServerMessage, Map<String, dynamic>>
    with ChunkedConversionSinkConverter {
  const ServerMessageToJsonConverter();

  @override
  Map<String, dynamic> convert(ServerMessage input) => input.toJson();
}

class ClientMessageCodec extends Codec<ClientMessage, Map<String, dynamic>> {
  const ClientMessageCodec();

  @override
  final Converter<Map<String, dynamic>, ClientMessage> decoder =
      const ClientMessageFromJsonConverter();

  @override
  final Converter<ClientMessage, Map<String, dynamic>> encoder =
      const ClientMessageToJsonConverter();
}

class ClientMessageFromJsonConverter
    extends Converter<Map<String, dynamic>, ClientMessage>
    with ChunkedConversionSinkConverter {
  const ClientMessageFromJsonConverter();

  @override
  ClientMessage convert(Map<String, dynamic> input) =>
      ClientMessage.fromJson(input);
}

class ClientMessageToJsonConverter
    extends Converter<ClientMessage, Map<String, dynamic>>
    with ChunkedConversionSinkConverter {
  const ClientMessageToJsonConverter();

  @override
  Map<String, dynamic> convert(ClientMessage input) => input.toJson();
}

abstract interface class Message {
  String get type;

  Map<String, dynamic> toJson();
}

sealed class OperationMessage implements Message {
  String get id;
}

sealed class ClientMessage implements Message {
  const ClientMessage();

  factory ClientMessage.fromJson(Map<String, dynamic> json) =>
      switch (json['type']) {
        ConnectionInitMessage.messageType =>
          ConnectionInitMessage.fromJson(json),
        PingMessage.messageType => PingMessage.fromJson(json),
        PongMessage.messageType => PongMessage.fromJson(json),
        SubscribeMessage.messageType => SubscribeMessage.fromJson(json),
        CompleteMessage.messageType => CompleteMessage.fromJson(json),
        final type => throw FormatException('Invalid message type: $type'),
      };
}

sealed class ServerMessage implements Message {
  const ServerMessage();

  factory ServerMessage.fromJson(Map<String, dynamic> json) =>
      switch (json['type']) {
        ConnectionAckMessage.messageType => ConnectionAckMessage.fromJson(json),
        NextMessage.messageType => NextMessage.fromJson(json),
        ErrorMessage.messageType => ErrorMessage.fromJson(json),
        PingMessage.messageType => PingMessage.fromJson(json),
        PongMessage.messageType => PongMessage.fromJson(json),
        CompleteMessage.messageType => CompleteMessage.fromJson(json),
        final type => throw FormatException('Invalid message type: $type'),
      };
}
