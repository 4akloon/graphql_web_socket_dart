import 'package:collection/collection.dart';

class GraphQLError {
  const GraphQLError({
    required this.message,
    this.locations,
    this.path,
    this.extensions,
  });

  factory GraphQLError.fromJson(Map<String, dynamic> json) => GraphQLError(
        message: json['message'],
        locations: (json['locations'] as List?)
            ?.map((location) => ErrorLocation.fromJson(location))
            .toList(),
        path: json['path'] as List?,
        extensions: json['extensions'] as Map<String, dynamic>?,
      );

  final String message;
  final List<ErrorLocation>? locations;
  final List<Object?>? path;
  final Map<String, Object?>? extensions;

  Map<String, Object> toJson() => {
        'message': message,
        if (locations case final locations?)
          'locations': locations.map((location) => location.toJson()).toList(),
        if (path case final path?) 'path': path,
        if (extensions case final extensions?) 'extensions': extensions,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GraphQLError &&
          other.message == message &&
          const ListEquality<ErrorLocation?>()
              .equals(other.locations, locations) &&
          const ListEquality<Object?>().equals(other.path, path) &&
          const MapEquality<String, Object?>()
              .equals(other.extensions, extensions));

  @override
  int get hashCode =>
      message.hashCode ^
      const ListEquality<ErrorLocation?>().hash(locations) ^
      const ListEquality<Object?>().hash(path) ^
      const MapEquality<String, Object?>().hash(extensions);

  @override
  String toString() =>
      'GraphQLError(message: $message, locations: $locations, path: $path, extensions: $extensions)';
}

class ErrorLocation {
  const ErrorLocation({
    required this.line,
    required this.column,
  });

  factory ErrorLocation.fromJson(Map<String, dynamic> json) => ErrorLocation(
        line: json['line'],
        column: json['column'],
      );

  final int line;
  final int column;

  Map<String, int> toJson() => {
        'line': line,
        'column': column,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ErrorLocation && other.line == line && other.column == column);

  @override
  int get hashCode => line.hashCode ^ column.hashCode;

  @override
  String toString() => 'ErrorLocation(line: $line, column: $column)';
}
