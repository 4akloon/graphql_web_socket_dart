import 'package:graphql_web_socket_core/graphql_web_socket_core.dart';
import 'package:graphql_web_socket_core/graphql_ws_protocol.dart';
import 'package:test/test.dart';

void main() {
  group('ConnectionAckMessage', () {
    test('should parse connection_ack message', () {
      final message = ServerMessage.fromJson({
        'type': 'connection_ack',
      });

      const expectedMessage = ConnectionAckMessage();

      expect(message, equals(expectedMessage));
    });

    test('should parse connection_ack message with payload', () {
      final message = ServerMessage.fromJson({
        'type': 'connection_ack',
        'payload': {'key': 'value'},
      });

      const expectedMessage = ConnectionAckMessage(
        payload: {'key': 'value'},
      );

      expect(message, equals(expectedMessage));
    });
  });

  group('NextMessage', () {
    test('should parse next message', () {
      final message = ServerMessage.fromJson({
        'type': 'next',
        'id': '1',
        'payload': {
          'data': {'key': 'value'},
        },
      });

      const expectedMessage = NextMessage(
        id: '1',
        payload: Response(data: {'key': 'value'}),
      );

      expect(message, equals(expectedMessage));
    });

    test('should throw on invalid next message', () {
      expect(
        () => ServerMessage.fromJson({
          'type': 'next',
          'payload': {
            'data': {'key': 'value'},
          },
        }),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('ErrorMessage', () {
    test('should parse error message', () {
      final message = ServerMessage.fromJson({
        'type': 'error',
        'id': '1',
        'payload': [
          {'message': 'error'},
        ],
      });

      const expectedMessage = ErrorMessage(
        id: '1',
        payload: [
          GraphQLError(message: 'error'),
        ],
      );

      expect(message, equals(expectedMessage));
    });

    test('should throw on invalid error message', () {
      expect(
        () => ServerMessage.fromJson({
          'type': 'error',
          'payload': [
            {'message': 'error'},
          ],
        }),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('PingMessage', () {
    test('should parse ping message', () {
      final message = ServerMessage.fromJson({
        'type': 'ping',
      });

      const expectedMessage = PingMessage();

      expect(message, equals(expectedMessage));
    });

    test('should parse ping message with payload', () {
      final message = ServerMessage.fromJson({
        'type': 'ping',
        'payload': {'key': 'value'},
      });

      const expectedMessage = PingMessage(
        payload: {'key': 'value'},
      );

      expect(message, equals(expectedMessage));
    });

    test('should serialize ping message', () {
      const message = PingMessage();

      final json = message.toJson();

      final expectedJson = {
        'type': 'ping',
      };

      expect(json, equals(expectedJson));
    });

    test('should serialize ping message with payload', () {
      const message = PingMessage(
        payload: {'key': 'value'},
      );

      final json = message.toJson();

      final expectedJson = {
        'type': 'ping',
        'payload': {'key': 'value'},
      };

      expect(json, equals(expectedJson));
    });
  });

  group('PongMessage', () {
    test('should parse pong message', () {
      final message = ServerMessage.fromJson({
        'type': 'pong',
      });

      const expectedMessage = PongMessage();

      expect(message, equals(expectedMessage));
    });

    test('should parse pong message with payload', () {
      final message = ServerMessage.fromJson({
        'type': 'pong',
        'payload': {'key': 'value'},
      });

      const expectedMessage = PongMessage(
        payload: {'key': 'value'},
      );

      expect(message, equals(expectedMessage));
    });

    test('should serialize pong message', () {
      const message = PongMessage();

      final json = message.toJson();

      final expectedJson = {
        'type': 'pong',
      };

      expect(json, equals(expectedJson));
    });

    test('should serialize pong message with payload', () {
      const message = PongMessage(
        payload: {'key': 'value'},
      );

      final json = message.toJson();

      final expectedJson = {
        'type': 'pong',
        'payload': {'key': 'value'},
      };

      expect(json, equals(expectedJson));
    });
  });

  group('CompleteMessage', () {
    test('should parse complete message', () {
      final message = ServerMessage.fromJson({
        'type': 'complete',
        'id': '1',
      });

      const expectedMessage = CompleteMessage(id: '1');

      expect(message, equals(expectedMessage));
    });

    test('should serialize complete message', () {
      const message = CompleteMessage(id: '1');

      final json = message.toJson();

      final expectedJson = {
        'type': 'complete',
        'id': '1',
      };

      expect(json, equals(expectedJson));
    });
  });

  group('SubscribeMessage', () {
    test('should serialize subscribe message', () {
      const message = SubscribeMessage(
        id: '1',
        payload: Request(
          query: 'query { field }',
        ),
      );

      final json = message.toJson();

      final expectedJson = {
        'type': 'subscribe',
        'id': '1',
        'payload': {
          'operationName': null,
          'query': 'query { field }',
          'variables': {},
        },
      };

      expect(json, equals(expectedJson));
    });
  });
}
