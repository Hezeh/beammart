import 'dart:io';

import 'package:beammart/providers/category_tokens_provider.dart';
import 'package:beammart/providers/image_upload_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './categories/art_craft_screen.dart';
import './categories/automotive.dart';
import './categories/baby.dart';
import './categories/beauty_personal_care.dart';
import './categories/computers.dart';
import './categories/food.dart';
import './categories/health_household.dart';
import './categories/home_kitchen.dart';
import './categories/household_essentials.dart';
import './categories/industrial_scientific.dart';
import './categories/luggage.dart';
import './categories/mens_fashion.dart';
import './categories/patio_garden.dart';
import './categories/pet_supplies.dart';
import './categories/smart_home.dart';
import './categories/sports_fitness_outdoors.dart';
import './categories/tools_home_improvement.dart';
import './categories/toys_games.dart';
import './categories/womens_fashion.dart';
import './categories/electronics_screen.dart';

class PickCategory extends StatelessWidget {
  final List<File>? images;

  const PickCategory({Key? key, this.images}) : super(key: key);

  Widget _subTitle(double? tokens) {
    return Row(
      children: [
        Icon(
          Icons.toll_outlined,
          color: Colors.yellow,
        ),
        SizedBox(
          width: 15,
        ),
        Text('$tokens')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final CategoryTokensProvider _tokensProvider =
        Provider.of<CategoryTokensProvider>(context);
    final _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    print(_imageUploadProvider.isUploadingImages);
    return Scaffold(
      bottomSheet: (_imageUploadProvider.isUploadingImages != null)
          ? (_imageUploadProvider.isUploadingImages!)
              ? Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.pink,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text("Uploading Product Images..."),
                  ),
                )
              : Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.pink,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text("Product Images Uploaded"),
                  ),
                )
          : Container(
              child: Text(""),
            ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            _imageUploadProvider.deleteImageUrls();
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Pick Category',
        ),
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ElectronicsScreen(),
                settings: RouteSettings(name: 'ElectronicsScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                'Electronics',
              ),
              subtitle:
                  _subTitle(_tokensProvider.categoryTokens!.electronicsTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ComputersScreen(),
                settings: RouteSettings(name: 'ComputersScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                'Computers',
              ),
              subtitle:
                  _subTitle(_tokensProvider.categoryTokens!.computersTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SmartHomeScreen(),
                settings: RouteSettings(name: 'SmartHomeScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                'Smart Home',
              ),
              subtitle:
                  _subTitle(_tokensProvider.categoryTokens!.smartHomeTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ArtsCraftsScreen(),
                settings: RouteSettings(name: 'ArtsCraftsScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                'Arts & Crafts',
              ),
              subtitle:
                  _subTitle(_tokensProvider.categoryTokens!.artCraftTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AutomotiveScreen(),
                settings: RouteSettings(name: 'AutomotiveScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                'Automotive',
              ),
              subtitle:
                  _subTitle(_tokensProvider.categoryTokens!.automotiveTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BabyScreen(),
                settings: RouteSettings(name: 'BabyScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                'Baby',
              ),
              subtitle: _subTitle(_tokensProvider.categoryTokens!.babyTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BeautyPersonalCareScreen(),
                settings: RouteSettings(name: 'BeautyPersonalCareScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                'Beauty & Personal Care',
              ),
              subtitle: _subTitle(
                  _tokensProvider.categoryTokens!.beautyPersonalCareTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => WomensFashionScreen(),
                settings: RouteSettings(name: 'WomensFashionScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                "Women's Fashion",
              ),
              subtitle: _subTitle(
                  _tokensProvider.categoryTokens!.womensFashionTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MensFashionScreen(),
                settings: RouteSettings(name: 'MensFashionScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                "Men's Fashion",
              ),
              subtitle:
                  _subTitle(_tokensProvider.categoryTokens!.mensFashionTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => HealthHouseholdScreen(),
                settings: RouteSettings(name: 'HealthHouseholdScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                'Health & Household',
              ),
              subtitle: _subTitle(
                  _tokensProvider.categoryTokens!.healthHouseholdTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => HomeKitchenScreen(),
                settings: RouteSettings(name: 'HomeKitchenScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                "Home & Kitchen",
              ),
              subtitle:
                  _subTitle(_tokensProvider.categoryTokens!.homeKitchenTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PatioGardenScreen(),
                settings: RouteSettings(name: 'PatioGardenScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                "Patio & Garden",
              ),
              subtitle:
                  _subTitle(_tokensProvider.categoryTokens!.patioGardenTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => IndustrialScientificScreen(),
                settings: RouteSettings(name: 'IndustrialScientificScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                "Industrial & Scientific",
              ),
              subtitle: _subTitle(
                  _tokensProvider.categoryTokens!.industrialScientificTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LuggageScreen(),
                settings: RouteSettings(name: 'LuggageScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                "Luggage",
              ),
              subtitle:
                  _subTitle(_tokensProvider.categoryTokens!.luggageTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PetSuppliesScreen(),
                settings: RouteSettings(name: 'PetSuppliesScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                "Pet Supplies",
              ),
              subtitle:
                  _subTitle(_tokensProvider.categoryTokens!.petSuppliesTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SportsFitnessOutdoorsScreen(),
                settings: RouteSettings(name: 'SportsFitnessOutdoorsScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                "Sports, Fitness & Outdoors",
              ),
              subtitle: _subTitle(
                  _tokensProvider.categoryTokens!.sportsFitnessOutdoorsTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ToolsHomeImprovementScreen(),
                settings: RouteSettings(name: 'ToolsHomeImprovementScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                "Tools & Home Improvement",
              ),
              subtitle: _subTitle(
                  _tokensProvider.categoryTokens!.toolsHomeImprovementTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ToysGamesScreen(),
                settings: RouteSettings(name: 'ToysGamesScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                "Toys & Games",
              ),
              subtitle:
                  _subTitle(_tokensProvider.categoryTokens!.toysGamesTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FoodScreen(),
                settings: RouteSettings(name: 'FoodScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                "Food",
              ),
              subtitle: _subTitle(_tokensProvider.categoryTokens!.foodTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => HouseholdEssentialsScreen(),
                settings: RouteSettings(name: 'HouseholdEssentialsScreen'),
              ),
            ),
            child: ListTile(
              title: Text(
                "Household Essentials",
              ),
              subtitle: _subTitle(
                  _tokensProvider.categoryTokens!.householdEssentialsTokens),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
