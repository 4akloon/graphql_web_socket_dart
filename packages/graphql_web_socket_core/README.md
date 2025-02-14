# GraphQL WebSocket Core

A foundational package that implements the GraphQL over WebSocket protocols. This package provides core functionality for building GraphQL clients and servers that communicate over WebSockets.

## Supported Protocols

- [graphql-ws](https://github.com/enisdenjo/graphql-ws) - Modern protocol for GraphQL over WebSocket
- [subscriptions-transport-ws](https://github.com/apollographql/subscriptions-transport-ws) - Legacy protocol (deprecated but still widely used)

## Features

- Complete implementation of GraphQL WebSocket protocols
- Platform agnostic - works on both web and native platforms
- Type-safe message definitions
- Built-in connection management
- Customizable message handling
- Supports custom headers and connection parameters
- Error handling utilities

## Installation

Add this package to your `pubspec.yaml`:

## Platform Support

The package automatically handles platform-specific WebSocket implementations:

- Web: Uses `dart:html` WebSocket
- Native (IO): Uses `dart:io` WebSocket

## Additional Information

- [Protocol Specification (graphql-ws)](https://github.com/enisdenjo/graphql-ws/blob/master/PROTOCOL.md)
- [Protocol Specification (subscriptions-transport-ws)](https://github.com/apollographql/subscriptions-transport-ws/blob/master/PROTOCOL.md)

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
