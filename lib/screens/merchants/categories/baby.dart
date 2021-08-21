import 'package:beammart/enums/baby.dart';
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
import 'package:google_fonts/google_fonts.dart';
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
  bool _sellOnline = true;

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
            _categoryTokensProvider.categoryTokens!.babyTokens != null) {
          final double requiredTokens =
              _categoryTokensProvider.categoryTokens!.babyTokens!;
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
                sellOnline: _sellOnline,
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
                   MergeSemantics(
                    child: ListTile(
                      title: Text('Online Ordering'),
                      trailing: CupertinoSwitch(
                        value: _sellOnline,
                        onChanged: (bool value) {
                          setState(() {
                            _sellOnline = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _sellOnline = !_sellOnline;
                        });
                      },
                    ),
                  ),
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
                        body: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Activity & Entertainment'),
                              value: _baby == Baby.activityAndEntertainment,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _baby = Baby.activityAndEntertainment;
                                    _subCategory = 'Activity and Entertainment';
                                  },
                                );
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Apparel & Accessories'),
                              value: _baby == Baby.apparelAndAccessories,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _baby = Baby.apparelAndAccessories;
                                    _subCategory = 'Apparel and Accessories';
                                  },
                                );
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Baby & Todler Toys'),
                              value: _baby == Baby.babyAndTodlerToys,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _baby = Baby.babyAndTodlerToys;
                                    _subCategory = 'Baby and Todler Toys';
                                  },
                                );
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Baby Care'),
                              value: _baby == Baby.babyCare,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _baby = Baby.babyCare;
                                    _subCategory = 'Baby Care';
                                  },
                                );
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Baby Stationery'),
                              value: _baby == Baby.babyStationery,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _baby = Baby.babyStationery;
                                    _subCategory = 'Baby Stationery';
                                  },
                                );
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Car seats & Accessories'),
                              value: _baby == Baby.carSeatsAndAccessories,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _baby = Baby.carSeatsAndAccessories;
                                    _subCategory = 'Car Seats and Accessories';
                                  },
                                );
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Diapering'),
                              value: _baby == Baby.diapering,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _baby = Baby.diapering;
                                    _subCategory = 'Diapering';
                                  },
                                );
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Feeding'),
                              value: _baby == Baby.feeding,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _baby = Baby.feeding;
                                    _subCategory = 'Feeding';
                                  },
                                );
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Gifts'),
                              value: _baby == Baby.gifts,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _baby = Baby.gifts;
                                    _subCategory = 'Gifts';
                                  },
                                );
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Nursery'),
                              value: _baby == Baby.nursery,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _baby = Baby.nursery;
                                    _subCategory = 'Nursery';
                                  },
                                );
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Pregnancy & Maternity'),
                              value: _baby == Baby.pregnancyAndMaternity,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _baby = Baby.pregnancyAndMaternity;
                                    _subCategory = 'Pregnancy and Maternity';
                                  },
                                );
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Potty Training'),
                              value: _baby == Baby.pottyTraining,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _baby = Baby.pottyTraining;
                                    _subCategory = 'Potty Training';
                                  },
                                );
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Strollers & Accessories'),
                              value: _baby == Baby.strollersAndAccessories,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _baby = Baby.strollersAndAccessories;
                                    _subCategory = 'Strollers and Accessories';
                                  },
                                );
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Travel Gear'),
                              value: _baby == Baby.travelGear,
                              onChanged: (value) {
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
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          );
  }
}
