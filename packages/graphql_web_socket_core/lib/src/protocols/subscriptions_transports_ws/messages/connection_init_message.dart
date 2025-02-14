part of 'subscriptions_transports_ws_messages.dart';

class ConnectionInitMessage implements ClientMessage {
  const ConnectionInitMessage({this.payload});

  ConnectionInitMessage.fromJson(Map<String, dynamic> json)
      : payload = json['payload'];

  static const messageType = 'connection_init';

  final Map<String, dynamic>? payload;

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
      other is ConnectionInitMessage &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          const MapEquality().equals(payload, other.payload);

  @override
  int get hashCode => type.hashCode ^ const MapEquality().hash(payload);

  @override
  String toString() => 'ConnectionInitMessage(payload: $payload)';
}
