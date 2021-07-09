import 'package:beammart/enums/office_furniture.dart';
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
import 'package:provider/provider.dart';

class OfficeFurnitureScreen extends StatefulWidget {
  const OfficeFurnitureScreen({Key? key}) : super(key: key);

  @override
  _OfficeFurnitureScreenState createState() => _OfficeFurnitureScreenState();
}

class _OfficeFurnitureScreenState extends State<OfficeFurnitureScreen> {
  OfficeFurniture _officeFurniture = OfficeFurniture.bookshelvesAndBookcases;

  bool isExpanded = true;

  final _officeFurnitureFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Office Furniture';

  String _subCategory = 'Bookshelves and Bookcases';

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
      if (_officeFurnitureFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider.categoryTokens!.officeFurnitureTokens !=
                null) {
          final double requiredTokens =
              _categoryTokensProvider.categoryTokens!.officeFurnitureTokens!;
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
              title: Text('Office Furniture'),
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
              key: _officeFurnitureFormKey,
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
                            title: Text('Office Furniture Subcategories'),
                          );
                        },
                        body: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Bookshelves and Bookcases'),
                                value: _officeFurniture ==
                                    OfficeFurniture.bookshelvesAndBookcases,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture =
                                        OfficeFurniture.bookshelvesAndBookcases;
                                    _subCategory = 'Bookshelves and Bookcases';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Desks'),
                                value:
                                    _officeFurniture == OfficeFurniture.desks,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture = OfficeFurniture.desks;
                                    _subCategory = 'Desks';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Office Chairs'),
                                value: _officeFurniture ==
                                    OfficeFurniture.officeChairs,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture =
                                        OfficeFurniture.officeChairs;
                                    _subCategory = 'Office Chairs';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Office Chair Mats'),
                                value: _officeFurniture ==
                                    OfficeFurniture.officeChairMats,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture =
                                        OfficeFurniture.officeChairMats;
                                    _subCategory = 'Office Chair Mats';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Foot Rests'),
                                value: _officeFurniture ==
                                    OfficeFurniture.footRests,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture =
                                        OfficeFurniture.footRests;
                                    _subCategory = 'Foot Rests';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('File Cabinets'),
                                value: _officeFurniture ==
                                    OfficeFurniture.fileCabinets,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture =
                                        OfficeFurniture.fileCabinets;
                                    _subCategory = 'File Cabinets';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Cube Storage'),
                                value: _officeFurniture ==
                                    OfficeFurniture.cubeStorage,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture =
                                        OfficeFurniture.cubeStorage;
                                    _subCategory = 'Cube Storage';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Gaming Chairs'),
                                value: _officeFurniture ==
                                    OfficeFurniture.gamingChairs,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture =
                                        OfficeFurniture.gamingChairs;
                                    _subCategory = 'Gaming Chairs';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Gaming Desks'),
                                value: _officeFurniture ==
                                    OfficeFurniture.gamingDesks,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture =
                                        OfficeFurniture.gamingDesks;
                                    _subCategory = 'Gaming Desks';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title:
                                    Text('Printer Stands and Computer Carts'),
                                value: _officeFurniture ==
                                    OfficeFurniture
                                        .printerStandsAndComputerCarts,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture = OfficeFurniture
                                        .printerStandsAndComputerCarts;
                                    _subCategory =
                                        'Printer Stands and Computer Carts';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Folding Tables and Chairs'),
                                value: _officeFurniture ==
                                    OfficeFurniture.foldingTablesAndChairs,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture =
                                        OfficeFurniture.foldingTablesAndChairs;
                                    _subCategory = 'Folding Tables and Chairs';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Office Collections'),
                                value: _officeFurniture ==
                                    OfficeFurniture.officeCollections,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture =
                                        OfficeFurniture.officeCollections;
                                    _subCategory = 'Office Collections';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Standing Desks'),
                                value: _officeFurniture ==
                                    OfficeFurniture.standingDesks,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture =
                                        OfficeFurniture.standingDesks;
                                    _subCategory = 'Standing Desks';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Ergonomic Chairs'),
                                value: _officeFurniture ==
                                    OfficeFurniture.ergonomicChairs,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture =
                                        OfficeFurniture.ergonomicChairs;
                                    _subCategory = 'Ergonomic Chairs';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Task Chairs'),
                                value: _officeFurniture ==
                                    OfficeFurniture.taskChairs,
                                onChanged: (value) {
                                  setState(() {
                                    _officeFurniture =
                                        OfficeFurniture.taskChairs;
                                    _subCategory = 'Task Chairs';
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
