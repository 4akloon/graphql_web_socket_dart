import 'dart:convert';

import 'package:collection/collection.dart';

class Request {
  const Request({
    this.operationName,
    required this.query,
    this.variables = const <String, dynamic>{},
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        query: json['query'],
        operationName: json['operationName'],
        variables: json['variables'] as Map<String, dynamic>? ?? const {},
      );

  final String? operationName;
  final String query;
  final Map<String, dynamic> variables;

  Map<String, dynamic> toJson() => {
        'operationName': operationName,
        'variables': variables,
        'query': query,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Request &&
          other.operationName == operationName &&
          other.query == query &&
          const MapEquality().equals(other.variables, variables));

  @override
  int get hashCode =>
      operationName.hashCode ^
      query.hashCode ^
      const MapEquality().hash(variables);

  @override
  String toString() {
    final queryRepr = json.encode(query);
    return 'Request(operationName: $operationName, query: DocumentNode($queryRepr), variables: $variables)';
  }
}
