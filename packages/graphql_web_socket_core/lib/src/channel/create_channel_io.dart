import 'dart:async';
import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

FutureOr<WebSocketChannel> defaultConnectPlatform(
  Uri uri,
  Iterable<String>? protocols, {
  Map<String, dynamic>? headers,
}) async =>
    IOWebSocketChannel(
      await WebSocket.connect(
        uri.toString(),
        protocols: protocols,
        headers: headers,
      ),
    );
