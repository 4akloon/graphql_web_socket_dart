import 'package:uuid/data.dart';
import 'package:uuid/rng.dart';
import 'package:uuid/uuid.dart';

abstract interface class IdGenerator {
  String generate();
}

class UuidIdGenerator implements IdGenerator {
  UuidIdGenerator() : _uuid = Uuid(goptions: GlobalOptions(CryptoRNG()));

  final Uuid _uuid;

  @override
  String generate() => _uuid.v4();
}
