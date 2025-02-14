part of 'subscriptions_transports_ws_messages.dart';

class StartMessage implements OperationMessage, ClientMessage {
  const StartMessage({
    required this.id,
    required this.payload,
  });

  StartMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        payload = Request.fromJson(json['payload']);

  static const messageType = 'start';

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
      other is StartMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          payload == other.payload;

  @override
  int get hashCode => id.hashCode ^ payload.hashCode;

  @override
  String toString() => 'StartMessage(id: $id, payload: $payload)';
}
