import 'package:json_annotation/json_annotation.dart';

part 'suggestions.g.dart';

@JsonSerializable()
class Suggestions {
  final List<String>? suggestions;

  Suggestions({this.suggestions});

  factory Suggestions.fromJson(Map<String, dynamic> json) => _$SuggestionsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SuggestionsToJson(this);
}