import 'package:collection/collection.dart';

import 'error.dart';

class Response {
  const Response({
    this.errors,
    this.data,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        errors: (json['errors'] as List?)
            ?.map((error) => GraphQLError.fromJson(error))
            .toList(),
        data: json['data'] as Map<String, dynamic>?,
      );

  final List<GraphQLError>? errors;
  final Map<String, dynamic>? data;

  Map<String, dynamic> toJson() => {
        if (errors case final errors?)
          'errors': errors.map((error) => error.toJson()).toList(),
        if (data case final data?) 'data': data,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Response &&
          const ListEquality<GraphQLError>().equals(other.errors, errors) &&
          const MapEquality<String, dynamic>().equals(other.data, data));

  @override
  int get hashCode =>
      const ListEquality<GraphQLError>().hash(errors) ^
      const MapEquality<String, dynamic>().hash(data);

  @override
  String toString() => 'Response(errors: $errors, data: $data)';
}
