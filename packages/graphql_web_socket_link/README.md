# GraphQL WebSocket Link

A GraphQL Link implementation for the `gql` ecosystem that enables WebSocket connections for subscriptions and other real-time operations.

## Features

- WebSocket-based GraphQL operations
- Support for both `graphql-ws` and `subscriptions-transport-ws` protocols
- Auto-reconnection capabilities
- Connection state monitoring
- Custom ID generation
- Integration with `gql` ecosystem

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  graphql_web_socket_link: ^1.0.0
```

## Usage

### Basic Setup

```dart
import 'package:graphql_web_socket_link/graphql_web_socket_link.dart';
import 'package:graphql_web_socket_link/graphql_ws_protocol.dart';

void main() {
  final delegate = GraphQLWSDelegate();
  
  final factory = GraphQLWSProtocolFactory(
    uri: Uri.parse('ws://localhost:4000/graphql'),
    delegate: delegate,
  );
  
  final link = GraphQLWebSocketLink(
    protocolFactory: factory,
  );
}
```

### Using with GraphQL Client

```dart
import 'package:gql_link/gql_link.dart';

final link = Link.from([
  // Other links (like auth)
  graphQLWebSocketLink,
]);

// Use with your preferred GraphQL client
final client = GraphQLClient(
  link: link,
  // ... other configuration
);
```

### Authentication

```dart
class AuthenticatedDelegate extends GraphQLWSDelegate {
  final String token;
  
  AuthenticatedDelegate(this.token);
  
  @override
  Map<String, dynamic>? getInitialPayload() {
    return {
      'token': token,
    };
  }
}

final link = GraphQLWebSocketLink(
  protocolFactory: GraphQLWSProtocolFactory(
    uri: Uri.parse('ws://localhost:4000/graphql'),
    delegate: AuthenticatedDelegate('your-auth-token'),
  ),
);
```

### Custom ID Generation

```dart
class IncrementalIdGenerator implements IdGenerator {
  int _counter = 0;
  
  @override
  String generate() => (++_counter).toString();
}

final link = GraphQLWebSocketLink(
  protocolFactory: factory,
  idGenerator: IncrementalIdGenerator(),
);
```

### Using Legacy Protocol

```dart
import 'package:graphql_web_socket_link/subscriptions_transports_ws_protocol.dart';

final link = GraphQLWebSocketLink(
  protocolFactory: SubscriptionsTransportsWSProtocolFactory(
    uri: Uri.parse('ws://localhost:4000/graphql'),
    delegate: SubscriptionsTransportsWSDelegate(),
  ),
);
```

### Manual Reconnection

```dart
final link = GraphQLWebSocketLink(
  protocolFactory: factory,
);

// Later when needed
await link.reconnect();
```

## Error Handling

The link will automatically handle connection errors and retry operations when appropriate. You can catch errors in your GraphQL operations:

```dart
try {
  final result = await client.execute(
    Request(
      operation: Operation(
        document: gql('''
          subscription OnNewMessage {
            messageAdded {
              id
              content
            }
          }
        '''),
      ),
    ),
  );
  
  await for (final response in result) {
    print(response.data);
  }
} catch (error) {
  print('Error: $error');
}
```

## Cleanup

Don't forget to dispose of the link when you're done:

```dart
await link.dispose();
```

## See Also

- [graphql_web_socket_client](https://pub.dev/packages/graphql_web_socket_client) - The underlying WebSocket client
- [gql](https://pub.dev/packages/gql) - GraphQL tooling for Dart
- [gql_link](https://pub.dev/packages/gql_link) - Base interfaces for GraphQL links

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
