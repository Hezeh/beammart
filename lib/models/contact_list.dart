import 'package:beammart/models/contact.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_list.g.dart';

@JsonSerializable(explicitToJson: true)
class ContactList {
  final String? contactListId;
  final String? listName;
  // final List<Contact?>? contacts;

  ContactList({
    this.contactListId,
    this.listName,
    // this.contacts,
  });

   factory ContactList.fromJson(Map<String, dynamic>? json) =>
      _$ContactListFromJson(json!);
  Map<String, dynamic> toJson() => _$ContactListToJson(this);
}
