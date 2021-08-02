import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  final String? contactId;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? emailAddress;

  Contact({
    this.contactId,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.emailAddress,
  });

  factory Contact.fromJson(Map<String, dynamic>? json) =>
      _$ContactFromJson(json!);
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
