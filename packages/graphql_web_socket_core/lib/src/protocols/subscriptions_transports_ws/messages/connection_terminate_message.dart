part of 'subscriptions_transports_ws_messages.dart';

class ConnectionTerminateMessage implements ClientMessage {
  const ConnectionTerminateMessage({this.payload});

  ConnectionTerminateMessage.fromJson(Map<String, dynamic> json)
      : payload = json['payload'];

  static const messageType = 'connection_terminate';

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
      other is ConnectionTerminateMessage &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          const MapEquality().equals(payload, other.payload);

  @override
  int get hashCode => type.hashCode ^ const MapEquality().hash(payload);

  @override
  String toString() => 'ConnectionTerminateMessage(payload: $payload)';
}
