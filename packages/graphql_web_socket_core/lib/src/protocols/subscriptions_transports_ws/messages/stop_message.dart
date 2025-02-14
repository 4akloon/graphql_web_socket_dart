part of 'subscriptions_transports_ws_messages.dart';

class StopMessage implements OperationMessage, ClientMessage {
  const StopMessage({required this.id});

  StopMessage.fromJson(Map<String, dynamic> json) : id = json['id'];

  static const messageType = 'stop';

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
      other is StopMessage &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'StopMessage(id: $id)';
}
