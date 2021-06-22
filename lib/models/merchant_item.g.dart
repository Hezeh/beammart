// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantItem _$MerchantItemFromJson(Map<String, dynamic> json) {
  return MerchantItem(
    images:
        (json['images'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    itemId: json['itemId'] as String?,
    title: json['title'] as String?,
    description: json['description'] as String?,
    price: (json['price'] as num?)?.toDouble(),
    category: json['category'] as String?,
    subCategory: json['subCategory'] as String?,
    dateAdded: json['dateAdded'] == null
        ? null
        : DateTime.parse(json['dateAdded'] as String),
    dateModified: json['dateModified'] == null
        ? null
        : DateTime.parse(json['dateModified'] as String),
    inStock: json['inStock'] as bool?,
    lastRenewal: json['lastRenewal'] as String?,
    isActive: json['isActive'] as bool?,
  );
}

Map<String, dynamic> _$MerchantItemToJson(MerchantItem instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'images': instance.images,
      'category': instance.category,
      'subCategory': instance.subCategory,
      'dateAdded': instance.dateAdded?.toIso8601String(),
      'dateModified': instance.dateModified?.toIso8601String(),
      'inStock': instance.inStock,
      'lastRenewal': instance.lastRenewal,
      'isActive': instance.isActive,
    };
