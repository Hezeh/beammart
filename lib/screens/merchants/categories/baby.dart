import 'package:beammart/enums/baby.dart';
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

class BabyScreen extends StatefulWidget {
  @override
  _BabyScreenState createState() => _BabyScreenState();
}

class _BabyScreenState extends State<BabyScreen> {
  bool isExpanded = true;

  Baby _baby = Baby.activityAndEntertainment;

  final _babyFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Baby';

  String _subCategory = 'Activity and Entertainment';

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
      if (_babyFormKey.currentState!.validate()) {
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
              title: Text('Baby'),
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
              key: _babyFormKey,
              child: ListView(
                children: [
                  ExpansionPanelList(
                    expansionCallback: (int index, bool _isExpanded) {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text('Baby Subcategories'),
                          );
                        },
                        body: Wrap(
                          children: [
                            ChoiceChip(
                              label: Text('Activity & Entertainment'),
                              selectedColor: Colors.pink,
                              selected: _baby == Baby.activityAndEntertainment,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _baby = Baby.activityAndEntertainment;
                                    _subCategory = 'Activity and Entertainment';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Apparel & Accessories'),
                              selectedColor: Colors.pink,
                              selected: _baby == Baby.apparelAndAccessories,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _baby = Baby.apparelAndAccessories;
                                    _subCategory = 'Apparel and Accessories';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Baby & Todler Toys'),
                              selectedColor: Colors.pink,
                              selected: _baby == Baby.babyAndTodlerToys,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _baby = Baby.babyAndTodlerToys;
                                    _subCategory = 'Baby and Todler Toys';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Baby Care'),
                              selectedColor: Colors.pink,
                              selected: _baby == Baby.babyCare,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _baby = Baby.babyCare;
                                    _subCategory = 'Baby Care';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Baby Stationery'),
                              selectedColor: Colors.pink,
                              selected: _baby == Baby.babyStationery,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _baby = Baby.babyStationery;
                                    _subCategory = 'Baby Stationery';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Car seats & Accessories'),
                              selectedColor: Colors.pink,
                              selected: _baby == Baby.carSeatsAndAccessories,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _baby = Baby.carSeatsAndAccessories;
                                    _subCategory = 'Car Seats and Accessories';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Diapering'),
                              selectedColor: Colors.pink,
                              selected: _baby == Baby.diapering,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _baby = Baby.diapering;
                                    _subCategory = 'Diapering';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Feeding'),
                              selectedColor: Colors.pink,
                              selected: _baby == Baby.feeding,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _baby = Baby.feeding;
                                    _subCategory = 'Feeding';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Gifts'),
                              selectedColor: Colors.pink,
                              selected: _baby == Baby.gifts,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _baby = Baby.gifts;
                                    _subCategory = 'Gifts';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Nursery'),
                              selectedColor: Colors.pink,
                              selected: _baby == Baby.nursery,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _baby = Baby.nursery;
                                    _subCategory = 'Nursery';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Pregnancy & Maternity'),
                              selectedColor: Colors.pink,
                              selected: _baby == Baby.pregnancyAndMaternity,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _baby = Baby.pregnancyAndMaternity;
                                    _subCategory = 'Pregnancy and Maternity';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Potty Training'),
                              selectedColor: Colors.pink,
                              selected: _baby == Baby.pottyTraining,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _baby = Baby.pottyTraining;
                                    _subCategory = 'Potty Training';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Strollers & Accessories'),
                              selectedColor: Colors.pink,
                              selected: _baby == Baby.strollersAndAccessories,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _baby = Baby.strollersAndAccessories;
                                    _subCategory = 'Strollers and Accessories';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Travel Gear'),
                              selectedColor: Colors.pink,
                              selected: _baby == Baby.travelGear,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _baby = Baby.travelGear;
                                    _subCategory = 'Travel Gear';
                                  },
                                );
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
