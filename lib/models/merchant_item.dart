import 'package:json_annotation/json_annotation.dart';

part 'merchant_item.g.dart';

@JsonSerializable()
class MerchantItem {
  String? itemId;
  String? title;
  String? description;
  double? price;
  List<String?>? images;
  String? category;
  String? subCategory;
  DateTime? dateAdded;
  DateTime? dateModified;
  bool? inStock;
  String? lastRenewal;
  bool? isActive;

  MerchantItem({
    this.images,
    this.itemId,
    this.title,
    this.description,
    this.price,
    this.category,
    this.subCategory,
    this.dateAdded,
    this.dateModified,
    this.inStock,
    this.lastRenewal,
    this.isActive,
  });

  factory MerchantItem.fromJson(Map<String, dynamic> json) => _$MerchantItemFromJson(json);

  Map<String, dynamic> toJson() => _$MerchantItemToJson(this);
}
