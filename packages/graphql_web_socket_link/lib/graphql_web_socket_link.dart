library;

import 'dart:async';

import 'package:gql/language.dart';

import 'package:gql_exec/gql_exec.dart';
import 'package:gql_link/gql_link.dart';
import 'package:graphql_web_socket_client/graphql_web_socket_client.dart'
    as client;

class GraphQLWebSocketLink extends Link {
  GraphQLWebSocketLink({
    required client.GraphQLWebSocketProtocolFactory protocolFactory,
    client.IdGenerator? idGenerator,
  }) : _client = client.GraphQLWebSocketClient(
          protocolFactory: protocolFactory,
          idGenerator: idGenerator,
        );

  final client.GraphQLWebSocketClient _client;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) => _client
      .createSubscriptionStream(request.toClient())
      .map((response) => response.toGql());

  Future<void> reconnect() => _client.reconnect();

  @override
  Future<void> dispose() async {
    await _client.dispose();
    return super.dispose();
  }
}

extension on Request {
  client.Request toClient() => client.Request(
        operationName: operation.operationName,
        query: printNode(operation.document),
        variables: variables,
      );
}

extension on client.Response {
  Response toGql() => Response(
        data: data,
        errors: errors?.map((e) => e.toGql()).toList(),
        response: toJson(),
      );
}

extension on client.GraphQLError {
  GraphQLError toGql() => GraphQLError(
        message: message,
        locations: locations?.map((e) => e.toGql()).toList(),
        path: path,
        extensions: extensions,
      );
}

extension on client.ErrorLocation {
  ErrorLocation toGql() => ErrorLocation(
        line: line,
        column: column,
      );
}
