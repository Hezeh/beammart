import 'package:json_annotation/json_annotation.dart';

part 'category_tokens.g.dart';

@JsonSerializable()
class CategoryTokens {
  double? artCraftTokens;
  double? automotiveTokens;
  double? babyTokens;
  double? beautyPersonalCareTokens;
  double? computersTokens;
  double? electronicsTokens;
  double? foodTokens;
  double? healthHouseholdTokens;
  double? homeKitchenTokens;
  double? householdEssentialsTokens;
  double? industrialScientificTokens;
  double? luggageTokens;
  double? mensFashionTokens;
  double? patioGardenTokens;
  double? petSuppliesTokens;
  double? smartHomeTokens;
  double? sportsFitnessOutdoorsTokens;
  double? toolsHomeImprovementTokens;
  double? toysGamesTokens;
  double? womensFashionTokens;

  CategoryTokens({
    this.artCraftTokens,
    this.automotiveTokens,
    this.babyTokens,
    this.beautyPersonalCareTokens,
    this.computersTokens,
    this.electronicsTokens,
    this.foodTokens,
    this.healthHouseholdTokens,
    this.homeKitchenTokens,
    this.householdEssentialsTokens,
    this.industrialScientificTokens,
    this.luggageTokens,
    this.mensFashionTokens,
    this.patioGardenTokens,
    this.petSuppliesTokens,
    this.smartHomeTokens,
    this.sportsFitnessOutdoorsTokens,
    this.toolsHomeImprovementTokens,
    this.toysGamesTokens,
    this.womensFashionTokens,
  });

  factory CategoryTokens.fromJson(Map<String, dynamic>? json) => _$CategoryTokensFromJson(json!);
  Map<String, dynamic> toJson() => _$CategoryTokensToJson(this);
}
