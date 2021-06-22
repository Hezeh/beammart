import 'package:beammart/enums/womens_fashion.dart';
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

class WomensFashionScreen extends StatefulWidget {
  @override
  _WomensFashionScreenState createState() => _WomensFashionScreenState();
}

class _WomensFashionScreenState extends State<WomensFashionScreen> {
  bool isExpanded = true;

  final _womensFashionFormKey = GlobalKey<FormState>();

  WomensFashion _womensFashion = WomensFashion.accessories;

  bool _loading = false;

  final String _category = "Women's Fashion";

  String _subCategory = 'Accessories';

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
      if (_womensFashionFormKey.currentState!.validate()) {
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
              title: Text("Women's Fashion"),
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
              key: _womensFashionFormKey,
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
                            title: Text("Women's Fashion Subcategories"),
                          );
                        },
                        body: Wrap(
                          children: [
                            ChoiceChip(
                              label: Text('Accessories'),
                              selectedColor: Colors.pink,
                              selected:
                                  _womensFashion == WomensFashion.accessories,
                              onSelected: (bool selected) {
                                setState(() {
                                  _womensFashion = WomensFashion.accessories;
                                  _subCategory = 'Accessories';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Clothing'),
                              selectedColor: Colors.pink,
                              selected:
                                  _womensFashion == WomensFashion.clothing,
                              onSelected: (bool selected) {
                                setState(() {
                                  _womensFashion = WomensFashion.clothing;
                                  _subCategory = 'Clothing';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Shoes'),
                              selectedColor: Colors.pink,
                              selected: _womensFashion == WomensFashion.shoes,
                              onSelected: (bool selected) {
                                setState(() {
                                  _womensFashion = WomensFashion.shoes;
                                  _subCategory = 'Shoes';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Jewelry'),
                              selectedColor: Colors.pink,
                              selected: _womensFashion == WomensFashion.jewelry,
                              onSelected: (bool selected) {
                                setState(() {
                                  _womensFashion = WomensFashion.jewelry;
                                  _subCategory = 'Jewerly';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Watches'),
                              selectedColor: Colors.pink,
                              selected: _womensFashion == WomensFashion.watches,
                              onSelected: (bool selected) {
                                setState(() {
                                  _womensFashion = WomensFashion.watches;
                                  _subCategory = 'Watches';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Handbags'),
                              selectedColor: Colors.pink,
                              selected:
                                  _womensFashion == WomensFashion.handbags,
                              onSelected: (bool selected) {
                                setState(() {
                                  _womensFashion = WomensFashion.handbags;
                                  _subCategory = 'Handbags';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Bras, Panties & Lingerie'),
                              selectedColor: Colors.pink,
                              selected: _womensFashion ==
                                  WomensFashion.brasPantiesAndLingerie,
                              onSelected: (bool selected) {
                                setState(() {
                                  _womensFashion =
                                      WomensFashion.brasPantiesAndLingerie;
                                  _subCategory = 'Bras, Panties and Lingerie';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Pajamas & Loungewear'),
                              selectedColor: Colors.pink,
                              selected: _womensFashion ==
                                  WomensFashion.pajamasAndLoungewear,
                              onSelected: (bool selected) {
                                setState(() {
                                  _womensFashion =
                                      WomensFashion.pajamasAndLoungewear;
                                  _subCategory = 'Pajamas and Loungewear';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Maternity'),
                              selectedColor: Colors.pink,
                              selected:
                                  _womensFashion == WomensFashion.maternity,
                              onSelected: (bool selected) {
                                setState(() {
                                  _womensFashion = WomensFashion.maternity;
                                  _subCategory = 'Maternity';
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
                  ),
                ],
              ),
            ),
          );
  }
}
