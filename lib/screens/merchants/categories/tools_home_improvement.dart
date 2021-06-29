import 'package:beammart/enums/tools_home_improvement.dart';
import 'package:beammart/models/merchant_item.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/category_tokens_provider.dart';
import 'package:beammart/providers/image_upload_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:beammart/providers/subscriptions_provider.dart';
import 'package:beammart/screens/merchants/tokens_screen.dart';
import 'package:beammart/utils/balance_util.dart';
import 'package:beammart/utils/posting_item_util.dart';
import 'package:beammart/utils/upload_files_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            _categoryTokensProvider.categoryTokens!.toolsHomeImprovementTokens != null) {
          final double requiredTokens =
              _categoryTokensProvider.categoryTokens!.toolsHomeImprovementTokens!;
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
      } else {
        postingItemErrorUtils(context);
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
                        body: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Air Quality'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.airQuality,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.airQuality;
                                  _subCategory = 'Air Quality';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Building Supplies'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.buildingSupplies,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.buildingSupplies;
                                  _subCategory = 'Building Supplies';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Windows'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.windows,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.windows;
                                  _subCategory = 'Windows';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Heating'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.heating,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.heating;
                                  _subCategory = 'Heating';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Appliances'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.appliances,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.appliances;
                                  _subCategory = 'Appliances';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Electrical'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.electrical,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.electrical;
                                  _subCategory = 'Electrical';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Hardware'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.hardware,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.hardware;
                                  _subCategory = 'Hardware';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Kitchen & Bath Fixtures'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.kitchenAndBathFixtures,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement = ToolsHomeImprovement
                                      .kitchenAndBathFixtures;
                                  _subCategory = 'Kitchen and Batch Fixtures';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Light Bulbs'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.lightBulbs,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.lightBulbs;
                                  _subCategory = 'Light Bulbs';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Lighting & Ceiling Fans'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.lightningAndCeilingFans,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement = ToolsHomeImprovement
                                      .lightningAndCeilingFans;
                                  _subCategory = 'Lighting and Ceiling Fans';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Measuring & Layout Tools'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.measuringAndLayoutTools,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement = ToolsHomeImprovement
                                      .measuringAndLayoutTools;
                                  _subCategory = 'Measuring and Layout Tools';
                                });
                              },
                            ),
                            
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title:
                                  Text('Painting Supplies & Wall Treatments'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement
                                      .paintingSuppliesAndWallTreatments,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement = ToolsHomeImprovement
                                      .paintingSuppliesAndWallTreatments;
                                  _subCategory =
                                      'Painting Supplies and Wall Treatments';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Power & Hand Tools'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.powerAndHandTools,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.powerAndHandTools;
                                  _subCategory = 'Power and Hand Tools';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Rough Plumbing'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.roughPlumbing,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.roughPlumbing;
                                  _subCategory = 'Rough Plumbing';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Safety & Security'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.safetyAndSecurity,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement =
                                      ToolsHomeImprovement.safetyAndSecurity;
                                  _subCategory = 'Safety and Security';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Storage & Home Organization'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement
                                      .storageAndHomeOrganization,
                              onChanged: (value) {
                                setState(() {
                                  _toolsHomeImprovement = ToolsHomeImprovement
                                      .storageAndHomeOrganization;
                                  _subCategory =
                                      'Storage and Home Organization';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Welding & Soldering'),
                              value: _toolsHomeImprovement ==
                                  ToolsHomeImprovement.weldingAndSoldering,
                              onChanged: (value) {
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
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          );
  }
}
