import 'package:beammart/enums/art_craft.dart';
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

class ArtsCraftsScreen extends StatefulWidget {
  @override
  _ArtsCraftsScreenState createState() => _ArtsCraftsScreenState();
}

class _ArtsCraftsScreenState extends State<ArtsCraftsScreen> {
  ArtCraft _artCraft = ArtCraft.paintingDrawingArtSupplies;

  bool isExpanded = true;

  final _artCraftFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Arts and Crafts';

  String _subCategory = 'Painting, Drawing and Art Supplies';

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  bool _inStock = true;
  bool _sellOnline = true;

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
      if (_artCraftFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider.categoryTokens!.artCraftTokens != null) {
          final double requiredTokens =
              _categoryTokensProvider.categoryTokens!.artCraftTokens!;
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
              title: Text('Arts & Crafts'),
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
              key: _artCraftFormKey,
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
                      cursorColor: Colors.pink,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.pink,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pink,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
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
                      cursorColor: Colors.pink,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.pink,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pink,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
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
                      cursorColor: Colors.pink,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.pink,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.pink,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
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
                            title: Text('Art & Craft Subcategories'),
                          );
                        },
                        body: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Painting, Drawing & Art Supplies'),
                                value: _artCraft ==
                                    ArtCraft.paintingDrawingArtSupplies,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _artCraft =
                                          ArtCraft.paintingDrawingArtSupplies;
                                      _subCategory =
                                          'Painting, Drawjng and Art Supplies';
                                    },
                                  );
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Beading & Jewelry Making'),
                                value:
                                    _artCraft == ArtCraft.beadingJewelryMaking,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _artCraft = ArtCraft.beadingJewelryMaking;
                                      _subCategory =
                                          'Beading and Jewelry Making';
                                    },
                                  );
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Crafting'),
                                value: _artCraft == ArtCraft.crafting,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _artCraft = ArtCraft.crafting;
                                      _subCategory = 'Crafting';
                                    },
                                  );
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Fabric'),
                                value: _artCraft == ArtCraft.fabric,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _artCraft = ArtCraft.fabric;
                                      _subCategory = 'Fabric';
                                    },
                                  );
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Fabric Decorating'),
                                value: _artCraft == ArtCraft.fabricDecorating,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _artCraft = ArtCraft.fabricDecorating;
                                      _subCategory = 'Fabric Decorating';
                                    },
                                  );
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Knitting & Crochet'),
                                value: _artCraft == ArtCraft.knittingCrochet,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _artCraft = ArtCraft.knittingCrochet;
                                      _subCategory = 'Knitting and Crochet';
                                    },
                                  );
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Needlework'),
                                value: _artCraft == ArtCraft.needlework,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _artCraft = ArtCraft.needlework;
                                      _subCategory = 'Needlework';
                                    },
                                  );
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Printmaking'),
                                value: _artCraft == ArtCraft.printmaking,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _artCraft = ArtCraft.printmaking;
                                      _subCategory = 'Printmaking';
                                    },
                                  );
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Scrapbooking & Stamping'),
                                value:
                                    _artCraft == ArtCraft.scrapbookingStamping,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _artCraft = ArtCraft.scrapbookingStamping;
                                      _subCategory =
                                          'Scrapbooking and Stamping';
                                    },
                                  );
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Sewing'),
                                value: _artCraft == ArtCraft.sewing,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _artCraft = ArtCraft.sewing;
                                      _subCategory = 'Sewing';
                                    },
                                  );
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Party Decorations'),
                                value: _artCraft == ArtCraft.partyDecorations,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _artCraft = ArtCraft.partyDecorations;
                                      _subCategory = 'Party Decorations';
                                    },
                                  );
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Gift Wrapping Supplies'),
                                value:
                                    _artCraft == ArtCraft.giftWrappingSupplies,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _artCraft = ArtCraft.giftWrappingSupplies;
                                      _subCategory = 'Gift Wrapping Supplies';
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        isExpanded: isExpanded,
                      )
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
