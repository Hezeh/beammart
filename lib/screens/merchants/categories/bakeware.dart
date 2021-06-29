import 'package:beammart/enums/bakeware.dart';
import 'package:beammart/models/merchant_item.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/category_tokens_provider.dart';
import 'package:beammart/providers/image_upload_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:beammart/providers/subscriptions_provider.dart';
import 'package:beammart/screens/merchants/tokens_screen.dart';
import 'package:beammart/screens/merchants/uploading_screen.dart';
import 'package:beammart/utils/balance_util.dart';
import 'package:beammart/utils/posting_item_util.dart';
import 'package:beammart/utils/upload_files_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BakewareScreen extends StatefulWidget {
  const BakewareScreen({Key? key}) : super(key: key);

  @override
  _BakewareScreenState createState() => _BakewareScreenState();
}

class _BakewareScreenState extends State<BakewareScreen> {
  Bakeware _bakeware = Bakeware.bakewareSets;

  bool isExpanded = true;

  final _bakewareFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Bakeware';

  String _subCategory = 'Bakeware Sets';

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
      if (_bakewareFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider.categoryTokens!.bakewareTokens != null) {
          final double requiredTokens =
              _categoryTokensProvider.categoryTokens!.bakewareTokens!;
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
        ? UploadingScreen()
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
              title: Text('Bakeware'),
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
              key: _bakewareFormKey,
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
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text('Bakeware Subcategories'),
                          );
                        },
                        body: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Bakeware Sets'),
                                value: _bakeware == Bakeware.bakewareSets,
                                onChanged: (value) {
                                  setState(() {
                                    _bakeware = Bakeware.bakewareSets;
                                    _subCategory = 'Bakeware Sets';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Baking Dishes'),
                                value: _bakeware == Bakeware.bakingDishes,
                                onChanged: (value) {
                                  setState(() {
                                    _bakeware = Bakeware.bakingDishes;
                                    _subCategory = 'Baking Dishes';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Baking Sheets'),
                                value: _bakeware == Bakeware.bakingSheets,
                                onChanged: (value) {
                                  setState(() {
                                    _bakeware = Bakeware.bakingSheets;
                                    _subCategory = 'Baking Sheets';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Cake And Bundt Pans'),
                                value: _bakeware == Bakeware.cakeAndBundtPans,
                                onChanged: (value) {
                                  setState(() {
                                    _bakeware = Bakeware.cakeAndBundtPans;
                                    _subCategory = 'Cake And Bundt Pans';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Cookie Cutters'),
                                value: _bakeware == Bakeware.cookieCutters,
                                onChanged: (value) {
                                  setState(() {
                                    _bakeware = Bakeware.cookieCutters;
                                    _subCategory = 'Cookie Cutters';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Decorating Tools'),
                                value: _bakeware == Bakeware.decoratingTools,
                                onChanged: (value) {
                                  setState(() {
                                    _bakeware = Bakeware.decoratingTools;
                                    _subCategory = 'Decorating Tools';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Pie And Tart Pans'),
                                value: _bakeware == Bakeware.pieAndTartPans,
                                onChanged: (value) {
                                  setState(() {
                                    _bakeware = Bakeware.pieAndTartPans;
                                    _subCategory = 'Pie And Tart Pans';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Measuring Cups And Spoons'),
                                value: _bakeware == Bakeware.measuringCupsAndSpoons,
                                onChanged: (value) {
                                  setState(() {
                                    _bakeware = Bakeware.measuringCupsAndSpoons;
                                    _subCategory = 'Measuring Cups And Spoons';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Bread And Loaf Pans'),
                                value: _bakeware == Bakeware.breadAndLoafPans,
                                onChanged: (value) {
                                  setState(() {
                                    _bakeware = Bakeware.breadAndLoafPans;
                                    _subCategory = 'Bread And Loaf Pans';
                                  });
                                },
                              ),
                               CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Cupcake And Muffin Pans'),
                                value: _bakeware == Bakeware.cupcakeAndMuffinPans,
                                onChanged: (value) {
                                  setState(() {
                                    _bakeware = Bakeware.cupcakeAndMuffinPans;
                                    _subCategory = 'Cupcake And Muffin Pans';
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
