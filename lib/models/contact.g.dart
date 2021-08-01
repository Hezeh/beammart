// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) {
  return Contact(
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    phoneNumber: json['phoneNumber'] as String?,
    emailAddress: json['emailAddress'] as String?,
  );
}

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'emailAddress': instance.emailAddress,
    };
