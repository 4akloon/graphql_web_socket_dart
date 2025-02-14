part of 'subscriptions_transports_ws_messages.dart';

class DataMessage implements OperationMessage, ServerMessage {
  const DataMessage({
    required this.id,
    required this.payload,
  });

  DataMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        payload = Response.fromJson(json['payload'] as Map<String, dynamic>);

  static const messageType = 'data';

  @override
  final String id;
  final Response payload;

  @override
  String get type => messageType;

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'payload': payload.toJson(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          payload == other.payload;

  @override
  int get hashCode => id.hashCode ^ payload.hashCode;

  @override
  String toString() => 'DataMessage(id: $id, payload: $payload)';
}
