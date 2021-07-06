import 'package:beammart/enums/computers.dart';
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
            _categoryTokensProvider.categoryTokens!.computersTokens != null) {
          final double requiredTokens =
              _categoryTokensProvider.categoryTokens!.computersTokens!;
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
                            title: Text('Computers Subcategories'),
                          );
                        },
                        body: Container(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Computers & Accessories'),
                                value:
                                    _computers == Computers.computerAccessories,
                                onChanged: (value) {
                                  setState(() {
                                    _computers = Computers.computerAccessories;
                                    _subCategory = 'Computers and Accessories';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Computer Components'),
                                value:
                                    _computers == Computers.computerComponents,
                                onChanged: (value) {
                                  setState(() {
                                    _computers = Computers.computerComponents;
                                    _subCategory = 'Computer Components';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Data Storage'),
                                value: _computers == Computers.dataStorage,
                                onChanged: (value) {
                                  setState(() {
                                    _computers = Computers.dataStorage;
                                    _subCategory = 'Data Storage';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('External Components'),
                                value:
                                    _computers == Computers.externalComponents,
                                onChanged: (value) {
                                  setState(() {
                                    _computers = Computers.externalComponents;
                                    _subCategory = 'External Components';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Laptops & Accessories'),
                                value:
                                    _computers == Computers.laptopAccessories,
                                onChanged: (value) {
                                  setState(() {
                                    _computers = Computers.laptopAccessories;
                                    _subCategory = 'Laptops and Accessories';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Monitors'),
                                value: _computers == Computers.monitors,
                                onChanged: (value) {
                                  setState(() {
                                    _computers = Computers.monitors;
                                    _subCategory = 'Monitors';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Networking Products'),
                                value: _computers == Computers.networkinProducts,
                                onChanged: (value) {
                                  setState(() {
                                    _computers = Computers.networkinProducts;
                                    _subCategory = 'Networking Products';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Power Strips'),
                                value: _computers == Computers.powerStrips,
                                onChanged: (value) {
                                  setState(() {
                                    _computers = Computers.powerStrips;
                                    _subCategory = 'Power Strips';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Surge Protectors'),
                                value: _computers == Computers.surgeProtectors,
                                onChanged: (value) {
                                  setState(() {
                                    _computers = Computers.surgeProtectors;
                                    _subCategory = 'Surge Protectors';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Printers'),
                                value: _computers == Computers.printers,
                                onChanged: (value) {
                                  setState(() {
                                    _computers = Computers.printers;
                                    _subCategory = 'Printers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Scanners'),
                                value: _computers == Computers.scanners,
                                onChanged: (value) {
                                  setState(() {
                                    _computers = Computers.scanners;
                                    _subCategory = 'Scanners';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Servers'),
                                value: _computers == Computers.servers,
                                onChanged: (value) {
                                  setState(() {
                                    _computers = Computers.servers;
                                    _subCategory = 'Servers';
                                  });
                                },
                              ),
                              CheckboxListTile(
                                activeColor: Colors.amber,
                                title: Text('Tablet Accessories'),
                                value:
                                    _computers == Computers.tabletAccessories,
                                onChanged: (value) {
                                  setState(() {
                                    _computers = Computers.tabletAccessories;
                                    _subCategory = 'Tablet Accessories';
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
