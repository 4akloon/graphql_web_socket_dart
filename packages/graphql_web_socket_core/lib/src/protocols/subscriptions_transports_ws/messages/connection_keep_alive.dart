part of 'subscriptions_transports_ws_messages.dart';

class ConnectionKeepAliveMessage implements ServerMessage {
  const ConnectionKeepAliveMessage();

  static const messageType = 'ka';

  @override
  String get type => messageType;

  @override
  Map<String, dynamic> toJson() => {'type': type};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionKeepAliveMessage &&
          runtimeType == other.runtimeType &&
          type == other.type;

  @override
  int get hashCode => type.hashCode;

  @override
  String toString() => 'ConnectionKeepAliveMessage';
}
