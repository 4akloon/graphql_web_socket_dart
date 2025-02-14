import 'dart:convert';

import 'package:graphql_web_socket_client/graphql_web_socket_client.dart';
import 'package:graphql_web_socket_client/graphql_ws_protocol.dart';
import 'package:test/test.dart';

import '../../../mocks/web_socket_channel.dart';

void main() {
  group(
    'GraphQLWSChannelAdapter',
    () {
      late MockWebSocketChannel channel;
      late ChannelAdapter<ServerMessage, ClientMessage> adapter;

      setUp(() {
        channel = MockWebSocketChannel();
        adapter = ChannelAdapter(
          channel,
          incomingMessageConverter: const ServerMessageFromJsonConverter(),
          outgoingMessageConverter: const ClientMessageToJsonConverter(),
        );
      });

      tearDown(() {
        channel.dispose();
        adapter.close();
      });

      test(
        'should parse server message',
        () {
          final message = jsonEncode({
            'type': 'connection_ack',
          });

          const expectedMessage = ConnectionAckMessage();

          adapter.stream.first.then(
            expectAsync1(
              (message) {
                expect(message, isA<ConnectionAckMessage>());
                expect(message, equals(expectedMessage));
              },
            ),
          );

          channel.addServerMessage(message);
        },
        timeout: const Timeout(Duration(seconds: 5)),
      );

      test(
        'should serialize client message',
        () {
          const message = ConnectionInitMessage(
            payload: {'key': 'value'},
          );

          final expectedMessage = jsonEncode({
            'type': 'connection_init',
            'payload': {'key': 'value'},
          });

          channel.clientMessageStream.first.then(
            expectAsync1(
              (message) {
                expect(message, equals(expectedMessage));
              },
            ),
          );

          adapter.sink.add(message);
        },
        timeout: const Timeout(Duration(seconds: 5)),
      );

      test('should close channel', () {
        adapter.close();

        expect(channel.closeCode, equals(1000));
      });

      test('should close channel with code and reason', () {
        adapter.close(1001, 'reason');

        expect(channel.closeCode, equals(1001));
        expect(channel.closeReason, equals('reason'));
      });

      test(
        'should close channel and close stream',
        () {
          adapter.stream.listen(
            expectAsync1(
              (_) {},
              count: 0,
            ),
            onDone: expectAsync0(() {}),
          );

          adapter.close();
        },
        timeout: const Timeout(Duration(seconds: 5)),
      );
    },
  );
}
