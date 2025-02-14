part of 'graphql_ws_messages.dart';

class SubscribeMessage implements OperationMessage, ClientMessage {
  const SubscribeMessage({
    required this.id,
    required this.payload,
  });

  SubscribeMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        payload = Request.fromJson(json['payload']);

  static const messageType = 'subscribe';

  @override
  final String id;
  final Request payload;

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
      other is SubscribeMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          payload == other.payload;

  @override
  int get hashCode => id.hashCode ^ payload.hashCode;

  @override
  String toString() => 'SubscribeMessage(id: $id, payload: $payload)';
}
