import 'dart:io';

import 'package:beammart/providers/add_business_profile_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:beammart/screens/merchants/merchants_home_screen.dart';
import 'package:beammart/screens/merchants/operating_hours_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddBusinessProfilePhoto extends StatefulWidget {
  final bool? changePhoto;

  const AddBusinessProfilePhoto({Key? key, this.changePhoto}) : super(key: key);
  @override
  _AddBusinessProfilePhotoState createState() =>
      _AddBusinessProfilePhotoState();
}

class _AddBusinessProfilePhotoState extends State<AddBusinessProfilePhoto> {
  String? fileName;
  PickedFile? pickedImageFile;
  final picker = ImagePicker();
  File? _image;

  getImage(context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _businessProfileProvider =
        Provider.of<AddBusinessProfileProvider>(context);
    final _profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      persistentFooterButtons: (!widget.changePhoto!)
          ? [
              (_image != null)
                  ? ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: ElevatedButton(
                        onPressed: () {
                          // Call the add business profile provider add profile photo func
                          _businessProfileProvider
                              .addBusinessProfilePhoto(_image);
                          // Navigate to Add Location Page
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OperatingHoursScreen(),
                              settings:
                                  RouteSettings(name: 'OperatingHoursScreen'),
                            ),
                          );
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                            // color: Colors.pink,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  : ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: ElevatedButton(
                        onPressed: () {
                          // Call the add business profile provider add profile photo func
                          // _businessProfileProvider
                          //     .addBusinessProfilePhoto(_image);
                          // Navigate to Add Location Page
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OperatingHoursScreen(),
                              settings:
                                  RouteSettings(name: 'OperatingHoursScreen'),
                            ),
                          );
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            // color: Colors.pink,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
            ]
          : [
              (_image != null)
                  ? ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: ElevatedButton(
                        onPressed: () {
                          // Upload photo to the backend
                          // Change url in firestore
                          // Navigate back to the home page
                          _profileProvider.changeBusinessProfilePhoto(
                              _image, _profileProvider.profile!.userId);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MerchantHomeScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Upload',
                          style: TextStyle(
                            // color: Colors.pink,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
      appBar: AppBar(
        title:
            widget.changePhoto! ? Text('Change Photo') : Text('Profile Photo'),
        actions: widget.changePhoto!
            ? [
                (_image != null)
                    ? Container(
                        margin: EdgeInsets.only(
                          right: 10,
                        ),
                        child: TextButton(
                          onPressed: () {
                            // Upload photo to the backend
                            // Change url in firestore
                            // Navigate back to the home page
                            _profileProvider.changeBusinessProfilePhoto(
                                _image, _profileProvider.profile!.userId);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MerchantHomeScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Upload',
                            style: GoogleFonts.gelasio(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      )
                    : Container()
              ]
            : [
                (_image != null)
                    ? TextButton(
                        onPressed: () {
                          // Call the add business profile provider add profile photo func
                          _businessProfileProvider
                              .addBusinessProfilePhoto(_image);
                          // Navigate to Add Location Page
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OperatingHoursScreen(),
                              settings:
                                  RouteSettings(name: 'OperatingHoursScreen'),
                            ),
                          );
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          // Call the add business profile provider add profile photo func
                          // _businessProfileProvider
                          //     .addBusinessProfilePhoto(_image);
                          // Navigate to Add Location Page
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => OperatingHoursScreen(),
                              settings:
                                  RouteSettings(name: 'OperatingHoursScreen'),
                            ),
                          );
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
              ],
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          child: (_image != null)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 400,
                    child: GridTile(
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                      footer: GridTileBar(
                        backgroundColor: Colors.black38,
                        leading: IconButton(
                          color: Colors.red,
                          icon: Icon(
                            Icons.delete_outline_outlined,
                          ),
                          onPressed: () => _removeImage(),
                        ),
                      ),
                    ),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: () => getImage(context),
                  icon: Icon(Icons.add_a_photo_outlined),
                  label: Text("Select a profile photo"),
                ),
        ),
      ),
    );
  }
}
