// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactList _$ContactListFromJson(Map<String, dynamic> json) {
  return ContactList(
    contactListId: json['contactListId'] as String?,
    listName: json['listName'] as String?,
  );
}

Map<String, dynamic> _$ContactListToJson(ContactList instance) =>
    <String, dynamic>{
      'contactListId': instance.contactListId,
      'listName': instance.listName,
    };
