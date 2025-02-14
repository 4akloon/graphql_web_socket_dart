import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

FutureOr<WebSocketChannel> defaultConnectPlatform(
  Uri uri,
  Iterable<String>? protocols, {
  Map<String, dynamic>? headers,
}) {
  if (headers != null) {
    print('The headers on the web are not supported');
  }
  return WebSocketChannel.connect(
    uri,
    protocols: protocols,
  );
}
