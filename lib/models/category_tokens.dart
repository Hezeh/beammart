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
  double? kitchenAppliancesTokens;
  double? diningEntertainingTokens;
  double? cookwareTokens;
  double? bakewareTokens;
  double? bedroomFurnitureTokens;
  double? entrywayFurnitureTokens;
  double? homeEntertainmentFurnitureTokens;
  double? kitchenAndTableLinensTokens;
  double? kitchenAndDiningFurnitureTokens;
  double? kitchenStorageTokens;
  double? kitchenToolsAndGadgetsTokens;
  double? livingRoomFurnitureTokens;
  double? mattressesAndAccessoriesTokens;
  double? officeFurnitureTokens;
  double? patioFurnitureTokens;
  double? specialtyKitchenApplianceTokens;

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
    this.kitchenAppliancesTokens,
    this.diningEntertainingTokens,
    this.cookwareTokens,
    this.bakewareTokens,
    this.bedroomFurnitureTokens,
    this.entrywayFurnitureTokens,
    this.homeEntertainmentFurnitureTokens,
    this.kitchenAndTableLinensTokens,
    this.kitchenAndDiningFurnitureTokens,
    this.kitchenStorageTokens,
    this.kitchenToolsAndGadgetsTokens,
    this.livingRoomFurnitureTokens,
    this.mattressesAndAccessoriesTokens,
    this.officeFurnitureTokens,
    this.patioFurnitureTokens,
    this.specialtyKitchenApplianceTokens,
  });

  factory CategoryTokens.fromJson(Map<String, dynamic>? json) =>
      _$CategoryTokensFromJson(json!);
  Map<String, dynamic> toJson() => _$CategoryTokensToJson(this);
}
