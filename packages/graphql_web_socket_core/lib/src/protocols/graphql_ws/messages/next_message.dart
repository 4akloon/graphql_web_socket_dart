part of 'graphql_ws_messages.dart';

class NextMessage implements OperationMessage, ServerMessage {
  const NextMessage({
    required this.id,
    required this.payload,
  });

  NextMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        payload = Response.fromJson(json['payload'] as Map<String, dynamic>);

  static const messageType = 'next';

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
      other is NextMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          payload == other.payload;

  @override
  int get hashCode => id.hashCode ^ payload.hashCode;

  @override
  String toString() => 'NextMessage(id: $id, payload: $payload)';
}
