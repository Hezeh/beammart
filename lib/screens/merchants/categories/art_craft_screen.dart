import 'package:beammart/enums/art_craft.dart';
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
                        body: Wrap(
                          children: [
                            ChoiceChip(
                              label: Text('Painting, Drawing & Art Supplies'),
                              selectedColor: Colors.pink,
                              selected: _artCraft ==
                                  ArtCraft.paintingDrawingArtSupplies,
                              onSelected: (bool selected) {
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
                            ChoiceChip(
                              label: Text('Beading & Jewelry Making'),
                              selectedColor: Colors.pink,
                              selected:
                                  _artCraft == ArtCraft.beadingJewelryMaking,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _artCraft = ArtCraft.beadingJewelryMaking;
                                    _subCategory = 'Beading and Jewelry Making';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Crafting'),
                              selectedColor: Colors.pink,
                              selected: _artCraft == ArtCraft.crafting,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _artCraft = ArtCraft.crafting;
                                    _subCategory = 'Crafting';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Fabric'),
                              selectedColor: Colors.pink,
                              selected: _artCraft == ArtCraft.fabric,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _artCraft = ArtCraft.fabric;
                                    _subCategory = 'Fabric';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Fabric Decorating'),
                              selectedColor: Colors.pink,
                              selected: _artCraft == ArtCraft.fabricDecorating,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _artCraft = ArtCraft.fabricDecorating;
                                    _subCategory = 'Fabric Decorating';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Knitting & Crochet'),
                              selectedColor: Colors.pink,
                              selected: _artCraft == ArtCraft.knittingCrochet,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _artCraft = ArtCraft.knittingCrochet;
                                    _subCategory = 'Knitting and Crochet';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Needlework'),
                              selectedColor: Colors.pink,
                              selected: _artCraft == ArtCraft.needlework,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _artCraft = ArtCraft.needlework;
                                    _subCategory = 'Needlework';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Printmaking'),
                              selectedColor: Colors.pink,
                              selected: _artCraft == ArtCraft.printmaking,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _artCraft = ArtCraft.printmaking;
                                    _subCategory = 'Printmaking';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Scrapbooking & Stamping'),
                              selectedColor: Colors.pink,
                              selected:
                                  _artCraft == ArtCraft.scrapbookingStamping,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _artCraft = ArtCraft.scrapbookingStamping;
                                    _subCategory = 'Scrapbooking and Stamping';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Sewing'),
                              selectedColor: Colors.pink,
                              selected: _artCraft == ArtCraft.sewing,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _artCraft = ArtCraft.sewing;
                                    _subCategory = 'Sewing';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Party Decorations'),
                              selectedColor: Colors.pink,
                              selected: _artCraft == ArtCraft.partyDecorations,
                              onSelected: (bool selected) {
                                setState(
                                  () {
                                    _artCraft = ArtCraft.partyDecorations;
                                    _subCategory = 'Party Decorations';
                                  },
                                );
                              },
                            ),
                            ChoiceChip(
                              label: Text('Gift Wrapping Supplies'),
                              selectedColor: Colors.pink,
                              selected:
                                  _artCraft == ArtCraft.giftWrappingSupplies,
                              onSelected: (bool selected) {
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
                        isExpanded: isExpanded,
                      )
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
