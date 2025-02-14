import 'package:graphql_web_socket_core/graphql_web_socket_core.dart';

sealed class ClientOperationMessage {
  const ClientOperationMessage({required this.id});

  final String id;
}

class OperationSubscribeMessage extends ClientOperationMessage {
  const OperationSubscribeMessage({
    required this.request,
    required super.id,
  });

  final Request request;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperationSubscribeMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          request == other.request;

  @override
  int get hashCode => id.hashCode ^ request.hashCode;

  @override
  String toString() => 'OperationSubscribeMessage(id: $id, request: $request)';
}

class OperationDataMessage extends ClientOperationMessage {
  const OperationDataMessage({
    required this.response,
    required super.id,
  });

  final Response response;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperationDataMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          response == other.response;

  @override
  int get hashCode => id.hashCode ^ response.hashCode;

  @override
  String toString() => 'OperationDataMessage(id: $id, response: $response)';
}

class OperationUnsubscribeMessage extends ClientOperationMessage {
  const OperationUnsubscribeMessage({required super.id});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperationUnsubscribeMessage &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'OperationUnsubscribeMessage(id: $id)';
}
