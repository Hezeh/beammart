// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Suggestions _$SuggestionsFromJson(Map<String, dynamic> json) {
  return Suggestions(
    suggestions: (json['suggestions'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$SuggestionsToJson(Suggestions instance) =>
    <String, dynamic>{
      'suggestions': instance.suggestions,
    };
