# GraphQL WebSocket Client

A Dart implementation of GraphQL WebSocket client that supports both `graphql-ws` and `subscriptions-transport-ws` protocols.

## Features

- Support for both modern `graphql-ws` and legacy `subscriptions-transport-ws` protocols
- Auto-reconnection with configurable interval
- Subscription management
- Connection state tracking
- Ping/Pong latency monitoring (for `graphql-ws`)
- Keep-alive monitoring (for `subscriptions-transport-ws`)
- Customizable message IDs generation

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  graphql_web_socket_client: ^1.0.0
```

## Usage

### Basic Setup with graphql-ws Protocol

```dart
import 'package:graphql_web_socket_client/graphql_web_socket_client.dart';
import 'package:graphql_web_socket_client/graphql_ws_protocol.dart';

void main() async {
  // Create protocol delegate
  final delegate = GraphQLWSDelegate();
  
  // Create protocol factory
  final factory = GraphQLWSProtocolFactory(
    uri: Uri.parse('ws://localhost:4000/graphql'),
    delegate: delegate,
  );
  
  // Create client
  final client = GraphQLWebSocketClient(
    protocolFactory: factory,
  );
  
  // Connect
  await client.connect();
}
```

### Creating a Subscription

```dart
final request = Request(
  operationName: 'OnNewMessage',
  query: '''
    subscription OnNewMessage {
      messageAdded {
        id
        content
      }
    }
  ''',
);

final subscription = client.createSubscriptionStream(request).listen(
  (response) {
    print('Received: ${response.data}');
  },
  onError: (error) {
    print('Error: $error');
  },
);

// Later, when done
subscription.cancel();
```

### Using subscriptions-transport-ws Protocol

```dart
import 'package:graphql_web_socket_client/graphql_web_socket_client.dart';
import 'package:graphql_web_socket_client/subscriptions_transports_ws_protocol.dart';

final delegate = SubscriptionsTransportsWSDelegate();

final factory = SubscriptionsTransportsWSProtocolFactory(
  uri: Uri.parse('ws://localhost:4000/graphql'),
  delegate: delegate,
);

final client = GraphQLWebSocketClient(
  protocolFactory: factory,
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

final delegate = AuthenticatedDelegate('your-auth-token');
```

### Monitoring Connection State

```dart
client.connectionState.listen((state) {
  switch (state) {
    case WSClientState.connected:
      print('Connected');
    case WSClientState.connecting:
      print('Connecting...');
    case WSClientState.disconnected:
      print('Disconnected');
  }
});
```

### Monitoring Latency (graphql-ws only)

```dart
class MonitoringDelegate extends GraphQLWSDelegate {
  @override
  void onLatencyChanged(Duration? latency) {
    if (latency != null) {
      print('Current latency: ${latency.inMilliseconds}ms');
    } else {
      print('Latency measurement failed');
    }
  }
}
```

### Custom ID Generation

```dart
class IncrementalIdGenerator implements IdGenerator {
  int _counter = 0;
  
  @override
  String generate() => (++_counter).toString();
}

final client = GraphQLWebSocketClient(
  protocolFactory: factory,
  idGenerator: IncrementalIdGenerator(),
);
```

### Auto-Reconnection

```dart
final client = GraphQLWebSocketClient(
  protocolFactory: factory,
  autoReconnectInterval: Duration(seconds: 5), // Default is 1 second
);
```

## Error Handling

The client provides several ways to handle errors:

1. Connection errors through the connection state stream
2. Operation-specific errors in subscription streams
3. Protocol-specific errors through delegates

```dart
// Handle connection state
client.connectionState.listen((state) {
  if (state == WSClientState.disconnected) {
    print('Connection lost');
  }
});

// Handle subscription errors
subscription.listen(
  (data) => print(data),
  onError: (error) => print('Subscription error: $error'),
);
```

## Cleanup

Don't forget to dispose of the client when you're done:

```dart
await client.dispose();
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
