// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    userId: json['userId'] as String?,
    email: json['email'] as String?,
    lastKnownLocation: json['lastKnownLocation'] as String?,
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'lastKnownLocation': instance.lastKnownLocation,
    };
