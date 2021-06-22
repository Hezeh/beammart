import 'package:beammart/enums/tools_home_improvement.dart';
import 'package:beammart/models/merchant_item.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/category_tokens_provider.dart';
import 'package:beammart/providers/image_upload_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:beammart/providers/subscriptions_provider.dart';
import 'package:beammart/utils/balance_util.dart';
import 'package:beammart/utils/upload_files_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tokens_screen.dart';

class ToolsHomeImprovementScreen extends StatefulWidget {
  @override
  _ToolsHomeImprovementScreenState createState() =>
      _ToolsHomeImprovementScreenState();
}

class _ToolsHomeImprovementScreenState
    extends State<ToolsHomeImprovementScreen> {
  bool isExpanded = true;

  ToolsHomeImprovement _toolsHomeImprovement = ToolsHomeImprovement.airQuality;

  final _toolsHomeImprovementFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Tools and Home Improvement';

  String _subCategory = 'Camera and Photo';

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  bool _inStock = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _userId = Provider.of<AuthenticationProvider>(context).user!.uid;
    final _imageUrls = Provider.of<ImageUploadProvider>(context).imageUrls;
    final _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    final _categoryTokensProvider =
        Provider.of<CategoryTokensProvider>(context);
    final _profileProvider = Provider.of<ProfileProvider>(context);
    final _subsProvider = Provider.of<SubscriptionsProvider>(context);
    _postItem() async {
      if (_toolsHomeImprovementFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider.categoryTokens!.electronicsTokens != null) {
          final double requiredTokens =
              _categoryTokensProvider.categoryTokens!.electronicsTokens!;
          final bool _hasTokens = await checkBalance(_userId, requiredTokens);
          if (_hasTokens) {
            saveItemFirestore(
              context,
              _userId,
              MerchantItem(
                category: _category,
                subCategory: _subCategory,
                images: _imageUrls,
                title: _titleController.text,
                description: _descriptionController.text,
                price: double.parse(_priceController.text),
                dateAdded: DateTime.now(),
                dateModified: DateTime.now(),
                inStock: _inStock,
                lastRenewal: DateTime.now().toIso8601String(),
                isActive: true,
              ).toJson(),
            );
            _imageUploadProvider.deleteImageUrls();
            _subsProvider.consume(requiredTokens, _userId);
            setState(() {
              _loading = false;
            });
          } else {
            setState(() {
              _loading = false;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TokensScreen(),
              ),
            );
          }
        }
      }
    }

    return (_loading)
        ? Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Uploading...'),
            centerTitle: true,
          ),
          body: LinearProgressIndicator(),
        )
        : Scaffold(
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Images Uploaded Successfully"),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.cyan,
                              ),
                              onPressed: () {
                                _postItem();
                              },
                              child: Text("Post Item"),
                            ),
                          ],
                        ),
                      )
                : Container(
                    child: Text(""),
                  ),
            appBar: AppBar(
              title: Text('Tools & Home Improvement'),
              actions: [
                (_imageUploadProvider.isUploadingImages != null)
                    ? (!_imageUploadProvider.isUploadingImages!)
                        ? TextButton(
                            onPressed: () async {
                              _postItem();
                            },
                            child: Text(
                              'Post Item',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : Container()
                    : Container(),
              ],
            ),
            body: Form(
              key: _toolsHomeImprovementFormKey,
              child: ListView(
                children: [
                  ExpansionPanelList(
                    expansionCallback: (panelIndex, _isExpanded) {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title:
                                Text('Tools & Home Improvement Subcategories'),
                          );
                        },
                        body: Wrap(
                          children: [
                            ChoiceChip(
                              label: Text('Air Quality'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.airQuality,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.airQuality;
                                  _subCategory = 'Air Quality';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Building Supplies'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.buildingSupplies,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.buildingSupplies;
                                  _subCategory = 'Building Supplies';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Windows'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.windows,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.windows;
                                  _subCategory = 'Windows';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Heating'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.heating,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.heating;
                                  _subCategory = 'Heating';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Appliances'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.appliances,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.appliances;
                                  _subCategory = 'Appliances';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Electrical'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.electrical,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.electrical;
                                  _subCategory = 'Electrical';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Hardware'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.hardware,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.hardware;
                                  _subCategory = 'Hardware';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Kitchen & Bath Fixtures'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.kitchenAndBathFixtures,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement = ToolsHomeImprovement
                                      .kitchenAndBathFixtures;
                                  _subCategory = 'Kitchen and Batch Fixtures';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Light Bulbs'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.lightBulbs,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.lightBulbs;
                                  _subCategory = 'Light Bulbs';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Lighting & Ceiling Fans'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.lightningAndCeilingFans,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement = ToolsHomeImprovement
                                      .lightningAndCeilingFans;
                                  _subCategory = 'Lighting and Ceiling Fans';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Measuring & Layout Tools'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.measuringAndLayoutTools,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement = ToolsHomeImprovement
                                      .measuringAndLayoutTools;
                                  _subCategory = 'Measuring and Layout Tools';
                                });
                              },
                            ),
                            ChoiceChip(
                              label:
                                  Text('Painting Supplies & Wall Treatments'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement
                                      .paintingSuppliesAndWallTreatments,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement = ToolsHomeImprovement
                                      .paintingSuppliesAndWallTreatments;
                                  _subCategory =
                                      'Painting Supplies and Wall Treatments';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Power & Hand Tools'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.powerAndHandTools,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.powerAndHandTools;
                                  _subCategory = 'Power and Hand Tools';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Rough Plumbing'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.roughPlumbing,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.roughPlumbing;
                                  _subCategory = 'Rough Plumbing';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Safety & Security'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.safetyAndSecurity,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.safetyAndSecurity;
                                  _subCategory = 'Safety and Security';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Storage & Home Organization'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement
                                      .storageAndHomeOrganization,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement = ToolsHomeImprovement
                                      .storageAndHomeOrganization;
                                  _subCategory =
                                      'Storage and Home Organization';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Welding & Soldering'),
                              selectedColor: Colors.pink,
                              selected: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.weldingAndSoldering,
                              onSelected: (bool selected) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.weldingAndSoldering;
                                  _subCategory = 'Welding and Soldering';
                                });
                              },
                            ),
                          ],
                        ),
                        isExpanded: isExpanded,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _titleController,
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a title";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Title (required)',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a description";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Description (required)',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a price";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Price (required)',
                      ),
                    ),
                  ),
                  MergeSemantics(
                    child: ListTile(
                      title: Text('Item in Stock'),
                      trailing: CupertinoSwitch(
                        value: _inStock,
                        onChanged: (bool value) {
                          setState(() {
                            _inStock = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _inStock = !_inStock;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          );
  }
}
