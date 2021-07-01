import 'package:beammart/enums/beauty_personal_care.dart';
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

class BeautyPersonalCareScreen extends StatefulWidget {
  @override
  _BeautyPersonalCareScreenState createState() =>
      _BeautyPersonalCareScreenState();
}

class _BeautyPersonalCareScreenState extends State<BeautyPersonalCareScreen> {
  final _beautyPersonalCareFormKey = GlobalKey<FormState>();

  bool isExpanded = true;

  BeautyPersonalCare _beautyPersonalCare = BeautyPersonalCare.makeup;

  bool _loading = false;

  final String _category = 'Beauty and Personal Care';

  String _subCategory = 'Makeup';

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
      if (_beautyPersonalCareFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider.categoryTokens!.beautyPersonalCareTokens != null) {
          final double requiredTokens =
              _categoryTokensProvider.categoryTokens!.beautyPersonalCareTokens!;
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
              title: Text('Beauty & Personal Care'),
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
              key: _beautyPersonalCareFormKey,
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
                    expansionCallback: (int index, bool _isExpanded) {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text('Beauty & Personal Care Subcategories'),
                          );
                        },
                        body: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Makeup'),
                                value: _beautyPersonalCare ==
                                    BeautyPersonalCare.makeup,
                                onChanged: (value) {
                                  setState(() {
                                    _beautyPersonalCare =
                                        BeautyPersonalCare.makeup;
                                    _subCategory = 'Makeup';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Skin Care'),
                                value: _beautyPersonalCare ==
                                    BeautyPersonalCare.skinCare,
                                onChanged: (value) {
                                  setState(() {
                                    _beautyPersonalCare =
                                        BeautyPersonalCare.skinCare;
                                    _subCategory = 'Skin Care';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Hair Care'),
                                value: _beautyPersonalCare ==
                                    BeautyPersonalCare.hairCare,
                                onChanged: (value) {
                                  setState(() {
                                    _beautyPersonalCare =
                                        BeautyPersonalCare.hairCare;
                                    _subCategory = 'Hair Care';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Fragrance'),
                                value: _beautyPersonalCare ==
                                    BeautyPersonalCare.fragrance,
                                onChanged: (value) {
                                  setState(() {
                                    _beautyPersonalCare =
                                        BeautyPersonalCare.fragrance;
                                    _subCategory = 'Fragrance';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Foot, Hand & Nail Care'),
                                value: _beautyPersonalCare ==
                                    BeautyPersonalCare.footHandAndNailCare,
                                onChanged: (value) {
                                  setState(() {
                                    _beautyPersonalCare =
                                        BeautyPersonalCare.footHandAndNailCare;
                                    _subCategory = 'Foot, Hand and Nail Care';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Tools & Accessories'),
                                value: _beautyPersonalCare ==
                                    BeautyPersonalCare.toolsAndAccessories,
                                onChanged: (value) {
                                  setState(() {
                                    _beautyPersonalCare =
                                        BeautyPersonalCare.toolsAndAccessories;
                                    _subCategory = 'Tools and Accessories';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Shave & Hair Removal'),
                                value: _beautyPersonalCare ==
                                    BeautyPersonalCare.shaveAndHairRemoval,
                                onChanged: (value) {
                                  setState(() {
                                    _beautyPersonalCare =
                                        BeautyPersonalCare.shaveAndHairRemoval;
                                    _subCategory = 'Shave and Hair Removal';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Personal Care'),
                                value: _beautyPersonalCare ==
                                    BeautyPersonalCare.personalCare,
                                onChanged: (value) {
                                  setState(() {
                                    _beautyPersonalCare =
                                        BeautyPersonalCare.personalCare;
                                    _subCategory = 'Personal Care';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Oral Care'),
                                value: _beautyPersonalCare ==
                                    BeautyPersonalCare.oralCare,
                                onChanged: (value) {
                                  setState(() {
                                    _beautyPersonalCare =
                                        BeautyPersonalCare.oralCare;
                                    _subCategory = 'Oral Care';
                                  });
                                },
                              ),
                            ],
                          ),
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
