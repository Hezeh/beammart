import 'package:beammart/enums/computers.dart';
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

class ComputersScreen extends StatefulWidget {
  @override
  _ComputersScreenState createState() => _ComputersScreenState();
}

class _ComputersScreenState extends State<ComputersScreen> {
  Computers _computers = Computers.computerAccessories;

  bool isExpanded = true;

  final _computersFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Computers';

  String _subCategory = 'Computers and Accessories';

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
      if (_computersFormKey.currentState!.validate()) {
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
              title: Text('Computers'),
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
              key: _computersFormKey,
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
                            title: Text('Computers Subcategories'),
                          );
                        },
                        body: Wrap(
                          children: [
                            ChoiceChip(
                              label: Text('Computers & Accessories'),
                              selectedColor: Colors.pink,
                              selected:
                                  _computers == Computers.computerAccessories,
                              onSelected: (bool selected) {
                                setState(() {
                                  _computers = Computers.computerAccessories;
                                  _subCategory = 'Computers and Accessories';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Computer Components'),
                              selectedColor: Colors.pink,
                              selected:
                                  _computers == Computers.computerComponents,
                              onSelected: (bool selected) {
                                setState(() {
                                  _computers = Computers.computerComponents;
                                  _subCategory = 'Computer Components';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Data Storage'),
                              selectedColor: Colors.pink,
                              selected: _computers == Computers.dataStorage,
                              onSelected: (bool selected) {
                                setState(() {
                                  _computers = Computers.dataStorage;
                                  _subCategory = 'Data Storage';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('External Components'),
                              selectedColor: Colors.pink,
                              selected:
                                  _computers == Computers.externalComponents,
                              onSelected: (bool selected) {
                                setState(() {
                                  _computers = Computers.externalComponents;
                                  _subCategory = 'External Components';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Laptops & Accessories'),
                              selectedColor: Colors.pink,
                              selected:
                                  _computers == Computers.laptopAccessories,
                              onSelected: (bool selected) {
                                setState(() {
                                  _computers = Computers.laptopAccessories;
                                  _subCategory = 'Laptops and Accessories';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Monitors'),
                              selectedColor: Colors.pink,
                              selected: _computers == Computers.monitors,
                              onSelected: (bool selected) {
                                setState(() {
                                  _computers = Computers.monitors;
                                  _subCategory = 'Monitors';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Networking Products'),
                              selectedColor: Colors.pink,
                              selected:
                                  _computers == Computers.networkinProducts,
                              onSelected: (bool selected) {
                                setState(() {
                                  _computers = Computers.networkinProducts;
                                  _subCategory = 'Networking Products';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Power Strips'),
                              selectedColor: Colors.pink,
                              selected: _computers == Computers.powerStrips,
                              onSelected: (bool selected) {
                                setState(() {
                                  _computers = Computers.powerStrips;
                                  _subCategory = 'Power Strips';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Surge Protectors'),
                              selectedColor: Colors.pink,
                              selected: _computers == Computers.surgeProtectors,
                              onSelected: (bool selected) {
                                setState(() {
                                  _computers = Computers.surgeProtectors;
                                  _subCategory = 'Surge Protectors';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Printers'),
                              selectedColor: Colors.pink,
                              selected: _computers == Computers.printers,
                              onSelected: (bool selected) {
                                setState(() {
                                  _computers = Computers.printers;
                                  _subCategory = 'Printers';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Scanners'),
                              selectedColor: Colors.pink,
                              selected: _computers == Computers.scanners,
                              onSelected: (bool selected) {
                                setState(() {
                                  _computers = Computers.scanners;
                                  _subCategory = 'Scanners';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Servers'),
                              selectedColor: Colors.pink,
                              selected: _computers == Computers.servers,
                              onSelected: (bool selected) {
                                setState(() {
                                  _computers = Computers.servers;
                                  _subCategory = 'Servers';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text('Tablet Accessories'),
                              selectedColor: Colors.pink,
                              selected:
                                  _computers == Computers.tabletAccessories,
                              onSelected: (bool selected) {
                                setState(() {
                                  _computers = Computers.tabletAccessories;
                                  _subCategory = 'Tablet Accessories';
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
