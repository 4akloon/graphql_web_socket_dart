part of 'subscriptions_transports_ws_messages.dart';

class ErrorMessage implements OperationMessage, ServerMessage {
  const ErrorMessage({
    required this.id,
    required this.payload,
  });

  ErrorMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        payload = (json['payload'] as List)
            .cast<Map<String, dynamic>>()
            .map<GraphQLError>(GraphQLError.fromJson)
            .toList();

  static const messageType = 'error';

  @override
  final String id;
  final List<GraphQLError> payload;

  @override
  String get type => messageType;

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'payload': payload.map((error) => error.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          const ListEquality().equals(payload, other.payload);

  @override
  int get hashCode => id.hashCode ^ const ListEquality().hash(payload);

  @override
  String toString() => 'ErrorMessage(id: $id, payload: $payload)';
}
