// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactList _$ContactListFromJson(Map<String, dynamic> json) {
  return ContactList(
    contactId: json['contactId'] as String?,
    listName: json['listName'] as String?,
    contacts: (json['contacts'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : Contact.fromJson(e as Map<String, dynamic>?))
        .toList(),
  );
}

Map<String, dynamic> _$ContactListToJson(ContactList instance) =>
    <String, dynamic>{
      'contactId': instance.contactId,
      'listName': instance.listName,
      'contacts': instance.contacts?.map((e) => e?.toJson()).toList(),
    };
