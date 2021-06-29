import 'package:beammart/enums/sports_fitness_outdoors.dart';
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

class SportsFitnessOutdoorsScreen extends StatefulWidget {
  @override
  _SportsFitnessOutdoorsScreenState createState() =>
      _SportsFitnessOutdoorsScreenState();
}

class _SportsFitnessOutdoorsScreenState
    extends State<SportsFitnessOutdoorsScreen> {
  bool isExpanded = true;
  SportsFitnessOutdoors _sportsFitnessOutdoors =
      SportsFitnessOutdoors.basketball;
  final _sportsFitnessOutdoorsFormKey = GlobalKey<FormState>();

  bool _loading = false;

  final String _category = 'Sports, Fitness and Outdoors';

  String _subCategory = 'Basketball';

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
      if (_sportsFitnessOutdoorsFormKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        if (_profileProvider.profile!.tokensBalance != null &&
            _categoryTokensProvider.categoryTokens!.sportsFitnessOutdoorsTokens != null) {
          final double requiredTokens =
              _categoryTokensProvider.categoryTokens!.sportsFitnessOutdoorsTokens!;
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
              title: Text('Sports, Fitness & Outdoors'),
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
              key: _sportsFitnessOutdoorsFormKey,
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
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title: Text(
                                'Sports, Fitness & Outdoors Subcategories'),
                          );
                        },
                        body: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Basketball'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.basketball,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.basketball;
                                  _subCategory = 'Basketball';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Bikes'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.bikes,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.bikes;
                                  _subCategory = 'Bikes';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Walk & Run'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.walkAndRun,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.walkAndRun;
                                  _subCategory = 'Walk and Run';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Treadmills'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.treadmills,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.treadmills;
                                  _subCategory = 'Treadmills';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Boxing'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.boxing,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.boxing;
                                  _subCategory = 'Boxing';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Exercise Machines'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.exerciseMachines,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.exerciseMachines;
                                  _subCategory = 'Excercise Machines';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Yoga'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.yoga,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.yoga;
                                  _subCategory = 'Yoga';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Strength Training'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.stregthTraining,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.stregthTraining;
                                  _subCategory = 'Strength Training';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Sports Recovery'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.sportsRecovery,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.sportsRecovery;
                                  _subCategory = 'Sports Recovery';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Boats & Marine'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.boatsAndMarine,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.boatsAndMarine;
                                  _subCategory = 'Boats and Marine';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Fishing'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.fishing,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.fishing;
                                  _subCategory = 'Fishing';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Hunting'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.hunting,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.hunting;
                                  _subCategory = 'Hunting';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Kayak & Paddle'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.kayakAndPaddle,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.kayakAndPaddle;
                                  _subCategory = 'Kayak and Paddle';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Recreational Shooting'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.recreationalShooting,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors = SportsFitnessOutdoors
                                      .recreationalShooting;
                                  _subCategory = 'Recreational Shooting';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Watersports'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.waterSports,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.waterSports;
                                  _subCategory = 'Watersports';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Football'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.football,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.football;
                                  _subCategory = 'Football';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Golf'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.golf,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.golf;
                                  _subCategory = 'Golf';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Hockey'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.hockey,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.hockey;
                                  _subCategory = 'Hockey';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Tennis'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.tennis,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.tennis;
                                  _subCategory = 'Tennis';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Volleyball'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.volleyball,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.volleyball;
                                  _subCategory = 'Volleyball';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Skateboards & Skates'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.skateboardsAndSkates,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors = SportsFitnessOutdoors
                                      .skateboardsAndSkates;
                                  _subCategory = 'Skateboards and Skates';
                                });
                              },
                            ),
                            CheckboxListTile(
                              activeColor: Colors.amber,
                              title: Text('Camping & Hiking'),
                              value: _sportsFitnessOutdoors ==
                                  SportsFitnessOutdoors.campingAndHiking,
                              onChanged: (value) {
                                setState(() {
                                  _sportsFitnessOutdoors =
                                      SportsFitnessOutdoors.campingAndHiking;
                                  _subCategory = 'Camping and Hiking';
                                });
                              },
                            ),
                          ],
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
