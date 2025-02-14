import 'dart:async';

import 'package:meta/meta.dart';

abstract class ProtocolDelegate {
  const ProtocolDelegate();

  final Duration connectionTimeout = const Duration(seconds: 10);

  FutureOr<Map<String, dynamic>?> getInitialPayload() => null;

  @protected
  FutureOr<void> dispose() {}
}
