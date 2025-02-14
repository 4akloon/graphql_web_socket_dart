part of 'subscriptions_transports_ws_messages.dart';

class ConnectionErrorMessage implements ServerMessage {
  const ConnectionErrorMessage({this.payload});

  ConnectionErrorMessage.fromJson(Map<String, dynamic> json)
      : payload = json['payload'];

  static const messageType = 'connection_error';

  final Object? payload;

  @override
  String get type => messageType;

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        if (payload != null) 'payload': payload,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionErrorMessage &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          payload == other.payload;

  @override
  int get hashCode => type.hashCode ^ payload.hashCode;

  @override
  String toString() => 'ConnectionErrorMessage(payload: $payload)';
}
