import 'package:beammart/models/profile.dart';
import 'package:beammart/providers/add_business_profile_provider.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:beammart/screens/merchants/add_business_photo.dart';
import 'package:beammart/screens/merchants/add_location.dart';
import 'package:beammart/screens/merchants/operating_hours_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  final Profile? profile;
  static const routeName = '/ProfileScreen';

  const ProfileScreen({Key? key, this.profile}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileFormKey = GlobalKey<FormState>();

  final TextEditingController _businessName = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _locationDescription = TextEditingController();
  final TextEditingController _businessDescription = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  @override
  void dispose() {
    _businessName.dispose();
    _city.dispose();
    _locationDescription.dispose();
    _businessDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.profile != null) {
      if (widget.profile!.businessName != null) {
        _businessName.text = widget.profile!.businessName!;
      }
      if (widget.profile!.city != null) {
        _city.text = widget.profile!.city!;
      }
      if (widget.profile!.locationDescription != null) {
        _locationDescription.text = widget.profile!.locationDescription!;
      }
      if (widget.profile!.businessDescription != null) {
        _businessDescription.text = widget.profile!.businessDescription!;
      }
      if (widget.profile!.phoneNumber != null) {
        _phoneNumber.text = widget.profile!.phoneNumber!;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Profile? profile = Provider.of<ProfileProvider>(context).profile;
    final profileProvider = Provider.of<ProfileProvider>(context);
    final _userProvider = Provider.of<AuthenticationProvider>(context);
    final _businessProfileProvider =
        Provider.of<AddBusinessProfileProvider>(context);
    return Scaffold(
      persistentFooterButtons: [
        (widget.profile != null)
            ? ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 30,
                      primary: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    onPressed: () {
                      if (_profileFormKey.currentState!.validate()) {
                        Map<String, dynamic> _data = {};
                        if (_businessName.text.isNotEmpty) {
                          _data['businessName'] = _businessName.text;
                        }
                        if (_businessDescription.text.isNotEmpty) {
                          _data['businessDescription'] =
                              _businessDescription.text;
                        }
                        if (_city.text.isNotEmpty) {
                          _data['city'] = _city.text;
                        }
                        if (_phoneNumber.text.isNotEmpty) {
                          _data['phoneNumber'] = _phoneNumber.text;
                        }
                        if (_locationDescription.text.isNotEmpty) {
                          _data['locationDescription'] =
                              _locationDescription.text;
                        }
                        profileProvider.addBusinessProfile(
                          _data,
                          _userProvider.user!.uid,
                        );

                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      'Save',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox.shrink()
      ],
      appBar: (widget.profile != null)
          ? AppBar(
              title: Text('Edit Profile'),
              centerTitle: false,
              actions: [
                IconButton(
                  iconSize: 40,
                  padding: EdgeInsets.only(
                    right: 20,
                  ),
                  color: Colors.pink,
                  onPressed: () {
                    if (_profileFormKey.currentState!.validate()) {
                      Map<String, dynamic> _data = {};
                      if (_businessName.text.isNotEmpty) {
                        _data['businessName'] = _businessName.text;
                      }
                      if (_businessDescription.text.isNotEmpty) {
                        _data['businessDescription'] =
                            _businessDescription.text;
                      }
                      if (_city.text.isNotEmpty) {
                        _data['city'] = _city.text;
                      }
                      if (_phoneNumber.text.isNotEmpty) {
                        _data['phoneNumber'] = _phoneNumber.text;
                      }
                      if (_locationDescription.text.isNotEmpty) {
                        _data['locationDescription'] =
                            _locationDescription.text;
                      }
                      profileProvider.addBusinessProfile(
                        _data,
                        _userProvider.user!.uid,
                      );

                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icon(
                    Icons.done,
                  ),
                )
              ],
            )
          : AppBar(
              backgroundColor: Colors.red,
              leading: IconButton(  
                icon: Icon(Icons.close),
                onPressed: () => _userProvider.signOut(),
              ),
              title: Text(
                'Get Started',
                style: GoogleFonts.gelasio(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
      body: Form(
        key: _profileFormKey,
        child: ListView(
          children: [
            (widget.profile != null)
                ? SizedBox()
                : Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.5,
                          color: Colors.orange,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Colors.pink,
                          Colors.purple,
                        ])),
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "What's the name of your business?",
                      style: GoogleFonts.gelasio(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            (widget.profile != null)
                ? Container(
                    // padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(10),
                    height: 300,
                    child: (widget.profile!.businessProfilePhoto != null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: GridTile(
                              footer: GridTileBar(
                                backgroundColor: Colors.black12,
                                title: Text(
                                  'Change Photo',
                                  style: GoogleFonts.gelasio(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit_outlined),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => AddBusinessProfilePhoto(
                                          changePhoto: true,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: widget.profile!.businessProfilePhoto!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) {
                                  return Shimmer.fromColors(
                                    child: Card(
                                      child: Container(
                                        width: double.infinity,
                                        height: 300,
                                        color: Colors.white,
                                      ),
                                    ),
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                  );
                                },
                              ),
                            ),
                          )
                        : Center(
                            child: ElevatedButton(
                              child: Text("Add Profile Photo"),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AddBusinessProfilePhoto(
                                      changePhoto: true,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  )
                : Container(),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _businessName,
                autocorrect: true,
                enableSuggestions: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLines: 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  labelText: 'Business Name (required)',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a Business Name or Profile Name";
                  }
                  return null;
                },
              ),
            ),
            (widget.profile != null)
                ? Container(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _businessDescription,
                      autocorrect: true,
                      enableSuggestions: true,
                      maxLines: 3,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Business Description',
                        hintText: 'What does your business offer?',
                      ),
                      validator: (value) {
                        // if (value!.isEmpty) {
                        //   return "Please enter a Business Description";
                        // }
                        return null;
                      },
                    ),
                  )
                : Container(),
            (widget.profile != null)
                ? Container(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _city,
                      autocorrect: true,
                      enableSuggestions: true,
                      maxLines: 2,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'City/Town',
                      ),
                      validator: (value) {
                        // if (value!.isEmpty) {
                        //   return "Please enter a city or town";
                        // }
                        return null;
                      },
                    ),
                  )
                : Container(),
            (widget.profile != null)
                ? Container(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _locationDescription,
                      autocorrect: true,
                      enableSuggestions: true,
                      maxLines: 3,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(10),
                        labelText: 'Address',
                        hintText:
                            'E.g. Street Name, Building Address, Store Number',
                      ),
                      validator: (value) {
                        // if (value!.isEmpty) {
                        //   return "Please enter an address";
                        // }
                        return null;
                      },
                    ),
                  )
                : Container(),
            (widget.profile != null)
                ? SizedBox()
                : Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.5,
                        color: Colors.teal,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                         
                          Colors.red,
                          Colors.yellow,
                        ],
                      ),
                    ),
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "What is your contact info?",
                      style: GoogleFonts.gelasio(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _phoneNumber,
                autocorrect: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                enableSuggestions: true,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  labelText: 'Phone Number (required)',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a Phone Number";
                  }
                  return null;
                },
              ),
            ),
            (widget.profile != null)
                ? Container(
                    child: ListTile(
                      title: Text('GPS Location'),
                      subtitle: (profile != null && profile.gpsLocation != null)
                          ? Text(
                              '${profile.gpsLocation!.latitude}, ${profile.gpsLocation!.longitude}')
                          : Container(),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddLocationMap(
                                currentLocation: GeoPoint(
                                  profile!.gpsLocation!.latitude,
                                  profile.gpsLocation!.longitude,
                                ),
                              ),
                              settings:
                                  RouteSettings(name: 'EditLocationScreen'),
                            ),
                          );
                        },
                        child: Text('Change'),
                      ),
                    ),
                  )
                : Container(),
            (widget.profile != null)
                ? Container(
                    child: ListTile(
                      title: Text('Operating Hours'),
                      subtitle: Text('Opening & Closing Time'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              settings: RouteSettings(
                                  name: 'EditOperatingHoursScreen'),
                              builder: (_) => OperatingHoursScreen(
                                profile: Profile(
                                  mondayOpeningHours:
                                      profile!.mondayOpeningHours,
                                  mondayClosingHours:
                                      profile.mondayClosingHours,
                                  tuesdayOpeningHours:
                                      profile.tuesdayOpeningHours,
                                  tuesdayClosingHours:
                                      profile.tuesdayClosingHours,
                                  wednesdayOpeningHours:
                                      profile.wednesdayOpeningHours,
                                  wednesdayClosingHours:
                                      profile.wednesdayClosingHours,
                                  thursdayOpeningHours:
                                      profile.thursdayOpeningHours,
                                  thursdayClosingHours:
                                      profile.thursdayClosingHours,
                                  fridayOpeningHours:
                                      profile.fridayOpeningHours,
                                  fridayClosingHours:
                                      profile.fridayClosingHours,
                                  saturdayOpeningHours:
                                      profile.saturdayOpeningHours,
                                  saturdayClosingHours:
                                      profile.saturdayClosingHours,
                                  sundayOpeningHours:
                                      profile.sundayOpeningHours,
                                  sundayClosingHours:
                                      profile.sundayClosingHours,
                                  isMondayOpen: profile.isMondayOpen,
                                  isTuesdayOpen: profile.isTuesdayOpen,
                                  isWednesdayOpen: profile.isWednesdayOpen,
                                  isThursdayOpen: profile.isThursdayOpen,
                                  isFridayOpen: profile.isFridayOpen,
                                  isSaturdayOpen: profile.isSaturdayOpen,
                                  isSundayOpen: profile.isSundayOpen,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text('Edit'),
                      ),
                    ),
                  )
                : Container(),
            (widget.profile != null)
                ? SizedBox.shrink()
                : Container(
                    // margin: EdgeInsets.all(10),
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      onPressed: () async {
                        if (_profileFormKey.currentState!.validate()) {
                          _businessProfileProvider.businessInfo(
                            businessName: _businessName.text,
                            businessDescription: _businessDescription.text,
                            city: _city.text,
                            phoneNumber: _phoneNumber.text,
                            locationDescription: _locationDescription.text,
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddBusinessProfilePhoto(
                                changePhoto: false,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text('NEXT'),
                    ),
                  ),
            (widget.profile != null)
                ? SizedBox.shrink()
                : Container(
                    // margin: EdgeInsets.all(10),
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      onPressed: () async {
                        _userProvider.signOut();
                      },
                      child: Text('Not Now'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
