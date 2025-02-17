library;

import 'dart:async';

import 'package:gql/language.dart';

import 'package:gql_exec/gql_exec.dart';
import 'package:gql_link/gql_link.dart';
import 'package:graphql_web_socket_client/graphql_web_socket_client.dart'
    as gql_client;

class GraphQLWebSocketLink<P extends gql_client.GraphQLWebSocketProtocol>
    extends Link {
  GraphQLWebSocketLink({
    required gql_client.GraphQLWebSocketProtocolFactory<P> protocolFactory,
    gql_client.IdGenerator? idGenerator,
  }) : client = gql_client.GraphQLWebSocketClient(
          protocolFactory: protocolFactory,
          idGenerator: idGenerator,
        );

  final gql_client.GraphQLWebSocketClient<P> client;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) => client
      .createSubscriptionStream(request.toClient())
      .map((response) => response.toGql());

  @override
  Future<void> dispose() async {
    await client.dispose();
    return super.dispose();
  }
}

extension on Request {
  gql_client.Request toClient() => gql_client.Request(
        operationName: operation.operationName,
        query: printNode(operation.document),
        variables: variables,
      );
}

extension on gql_client.Response {
  Response toGql() => Response(
        data: data,
        errors: errors?.map((e) => e.toGql()).toList(),
        response: toJson(),
      );
}

extension on gql_client.GraphQLError {
  GraphQLError toGql() => GraphQLError(
        message: message,
        locations: locations?.map((e) => e.toGql()).toList(),
        path: path,
        extensions: extensions,
      );
}

extension on gql_client.ErrorLocation {
  ErrorLocation toGql() => ErrorLocation(
        line: line,
        column: column,
      );
}
