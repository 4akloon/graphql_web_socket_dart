part of 'subscriptions_transports_ws_messages.dart';

class CompleteMessage implements OperationMessage, ServerMessage {
  const CompleteMessage({required this.id});

  CompleteMessage.fromJson(Map<String, dynamic> json) : id = json['id'];

  static const messageType = 'complete';

  @override
  final String id;

  @override
  String get type => messageType;

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompleteMessage &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CompleteMessage(id: $id)';
}
