import 'package:beammart/models/profile.dart';
import 'package:beammart/providers/add_business_profile_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:beammart/screens/merchants/add_location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OperatingHoursScreen extends StatefulWidget {
  final Profile? profile;

  const OperatingHoursScreen({
    Key? key,
    this.profile,
  }) : super(key: key);

  @override
  _OperatingHoursScreenState createState() => _OperatingHoursScreenState();
}

class _OperatingHoursScreenState extends State<OperatingHoursScreen> {
  TimeOfDay? _mondayOpeningHour = TimeOfDay(hour: 08, minute: 00);
  TimeOfDay? _mondayClosingHour = TimeOfDay(hour: 20, minute: 00);
  TimeOfDay? _tuesdayOpeningHour = TimeOfDay(hour: 08, minute: 00);
  TimeOfDay? _tuesdayClosingHour = TimeOfDay(hour: 20, minute: 00);
  TimeOfDay? _wednesdayOpeningHour = TimeOfDay(hour: 08, minute: 00);
  TimeOfDay? _wednesdayClosingHour = TimeOfDay(hour: 20, minute: 00);
  TimeOfDay? _thursdayOpeningHour = TimeOfDay(hour: 08, minute: 00);
  TimeOfDay? _thursdayClosingHour = TimeOfDay(hour: 20, minute: 00);
  TimeOfDay? _fridayOpeningHour = TimeOfDay(hour: 08, minute: 00);
  TimeOfDay? _fridayClosingHour = TimeOfDay(hour: 20, minute: 00);
  TimeOfDay? _saturdayOpeningHour = TimeOfDay(hour: 08, minute: 00);
  TimeOfDay? _saturdayClosingHour = TimeOfDay(hour: 20, minute: 00);
  TimeOfDay? _sundayOpeningHour = TimeOfDay(hour: 08, minute: 00);
  TimeOfDay? _sundayClosingHour = TimeOfDay(hour: 20, minute: 00);
  //Open Days
  bool _isMondayOpen = true;
  bool _isTuesdayOpen = true;
  bool _isWednesdayOpen = true;
  bool _isThursdayOpen = true;
  bool _isFridayOpen = true;
  bool _isSaturdayOpen = true;
  bool _isSundayOpen = true;

  Future<TimeOfDay?> selectTimeOfDay(
      BuildContext context, TimeOfDay timeOfDay) {
    return showTimePicker(
      context: context,
      initialTime: timeOfDay,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
  }

  @override
  void initState() {
    if (widget.profile != null) {
      // Monday
      if (widget.profile!.isMondayOpen != null &&
          widget.profile!.isMondayOpen!) {
        final _mondayOpeningString = widget.profile!.mondayOpeningHours!;
        TimeOfDay _mondayOpeningTime =
            TimeOfDay.fromDateTime(DateFormat.jm().parse(_mondayOpeningString));
        _mondayOpeningHour = _mondayOpeningTime;
        final _mondayClosingString = widget.profile!.mondayClosingHours!;
        TimeOfDay _mondayClosingTime =
            TimeOfDay.fromDateTime(DateFormat.jm().parse(_mondayClosingString));
        _mondayClosingHour = _mondayClosingTime;
      } else {
        _isMondayOpen = false;
        _mondayOpeningHour = null;
        _mondayClosingHour = null;
      }

      // Tuesday
      if (widget.profile!.isTuesdayOpen != null &&
          widget.profile!.isTuesdayOpen!) {
        final _tuesdayOpeningString = widget.profile!.tuesdayOpeningHours!;
        TimeOfDay _tuesdayOpeningTime = TimeOfDay.fromDateTime(
            DateFormat.jm().parse(_tuesdayOpeningString));
        _tuesdayOpeningHour = _tuesdayOpeningTime;

        final _tuesdayClosingString = widget.profile!.tuesdayClosingHours!;
        TimeOfDay _tuesdayClosingTime = TimeOfDay.fromDateTime(
            DateFormat.jm().parse(_tuesdayClosingString));
        _tuesdayClosingHour = _tuesdayClosingTime;
      } else {
        _isTuesdayOpen = false;
        _tuesdayOpeningHour = null;
        _tuesdayClosingHour = null;
      }

      // Wednesday
      if (widget.profile!.isWednesdayOpen != null &&
          widget.profile!.isWednesdayOpen!) {
        final _wednesdayOpeningString = widget.profile!.wednesdayOpeningHours!;
        TimeOfDay _wednesdayOpeningTime = TimeOfDay.fromDateTime(
            DateFormat.jm().parse(_wednesdayOpeningString));
        _wednesdayOpeningHour = _wednesdayOpeningTime;

        final _wednesdayClosingString = widget.profile!.wednesdayClosingHours!;
        TimeOfDay _wednesdayClosingTime = TimeOfDay.fromDateTime(
            DateFormat.jm().parse(_wednesdayClosingString));
        _wednesdayClosingHour = _wednesdayClosingTime;
      } else {
        _isWednesdayOpen = false;
        _wednesdayOpeningHour = null;
        _wednesdayClosingHour = null;
      }
      // Thursday
      if (widget.profile!.isThursdayOpen != null &&
          widget.profile!.isThursdayOpen!) {
        final _thursdayOpeningString = widget.profile!.thursdayOpeningHours!;
        TimeOfDay _thursdayOpeningTime = TimeOfDay.fromDateTime(
            DateFormat.jm().parse(_thursdayOpeningString));
        _thursdayOpeningHour = _thursdayOpeningTime;

        final _thursdayClosingString = widget.profile!.thursdayClosingHours!;
        TimeOfDay _thursdayClosingTime = TimeOfDay.fromDateTime(
            DateFormat.jm().parse(_thursdayClosingString));
        _thursdayClosingHour = _thursdayClosingTime;
      } else {
        _isThursdayOpen = false;
        _thursdayOpeningHour = null;
        _thursdayClosingHour = null;
      }

      // Friday
      if (widget.profile!.isFridayOpen != null &&
          widget.profile!.isFridayOpen!) {
        final _fridayOpeningString = widget.profile!.fridayOpeningHours!;
        TimeOfDay _fridayOpeningTime =
            TimeOfDay.fromDateTime(DateFormat.jm().parse(_fridayOpeningString));
        _fridayOpeningHour = _fridayOpeningTime;

        final _fridayClosingString = widget.profile!.fridayClosingHours!;
        TimeOfDay _fridayClosingTime =
            TimeOfDay.fromDateTime(DateFormat.jm().parse(_fridayClosingString));
        _fridayClosingHour = _fridayClosingTime;
      } else {
        _isFridayOpen = false;
        _fridayOpeningHour = null;
        _fridayClosingHour = null;
      }

      // Saturday
      if (widget.profile!.isSaturdayOpen != null &&
          widget.profile!.isSaturdayOpen!) {
        final _saturdayOpeningString = widget.profile!.saturdayOpeningHours!;
        TimeOfDay _saturdayOpeningTime = TimeOfDay.fromDateTime(
            DateFormat.jm().parse(_saturdayOpeningString));
        _saturdayOpeningHour = _saturdayOpeningTime;

        final _saturdayClosingString = widget.profile!.saturdayClosingHours!;
        TimeOfDay _saturdayClosingTime = TimeOfDay.fromDateTime(
            DateFormat.jm().parse(_saturdayClosingString));
        _saturdayClosingHour = _saturdayClosingTime;
      } else {
        _isSaturdayOpen = false;
        _saturdayOpeningHour = null;
        _saturdayClosingHour = null;
      }

      // Sunday
      if (widget.profile!.isSundayOpen != null &&
          widget.profile!.isSundayOpen!) {
        final _sundayOpeningString = widget.profile!.sundayOpeningHours!;
        TimeOfDay _sundayOpeningTime =
            TimeOfDay.fromDateTime(DateFormat.jm().parse(_sundayOpeningString));
        _sundayOpeningHour = _sundayOpeningTime;

        final _sundayClosingString = widget.profile!.sundayClosingHours!;
        TimeOfDay _sundayClosingTime =
            TimeOfDay.fromDateTime(DateFormat.jm().parse(_sundayClosingString));
        _sundayClosingHour = _sundayClosingTime;
      } else {
        _isSundayOpen = false;
        _sundayOpeningHour = null;
        _sundayClosingHour = null;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final AuthenticationProvider _authProvider =
    //     Provider.of<AuthenticationProvider>(context);
    final _businessProfileProvider =
        Provider.of<AddBusinessProfileProvider>(context);
    final ProfileProvider _profileProvider =
        Provider.of<ProfileProvider>(context);
    final _currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: (widget.profile == null)
          ? AppBar(
              actions: [
                TextButton(
                  onPressed: () {
                    // declare a varible of type map
                    // final Map<String, dynamic> _operatingTimeData = {};
                    // Check if day is open
                    // Add time for the day
                    String? _mondayOpeningTime;
                    String? _mondayClosingTime;
                    String? _tuesdayOpeningTime;
                    String? _tuesdayClosingTime;
                    String? _wednesdayOpeningTime;
                    String? _wednesdayClosingTime;
                    String? _thursdayOpeningTime;
                    String? _thursdayClosingTime;
                    String? _fridayOpeningTime;
                    String? _fridayClosingTime;
                    String? _saturdayOpeningTime;
                    String? _saturdayClosingTime;
                    String? _sundayOpeningTime;
                    String? _sundayClosingTime;

                    // if (_isMondayOpen) {}

                    if (_mondayOpeningHour != null) {
                      _mondayOpeningTime = _mondayOpeningHour!.format(context);
                    }
                    if (_mondayClosingHour != null) {
                      _mondayClosingTime = _mondayClosingHour!.format(context);
                    }

                    if (_tuesdayOpeningHour != null) {
                      _tuesdayOpeningTime =
                          _tuesdayOpeningHour!.format(context);
                    }
                    if (_tuesdayClosingHour != null) {
                      _tuesdayClosingTime =
                          _tuesdayClosingHour!.format(context);
                    }
                    if (_wednesdayOpeningHour != null) {
                      _wednesdayOpeningTime =
                          _wednesdayOpeningHour!.format(context);
                    }
                    if (_wednesdayClosingHour != null) {
                      _wednesdayClosingTime =
                          _wednesdayClosingHour!.format(context);
                    }
                    if (_thursdayOpeningHour != null) {
                      _thursdayOpeningTime =
                          _thursdayOpeningHour!.format(context);
                    }
                    if (_thursdayClosingHour != null) {
                      _thursdayClosingTime =
                          _thursdayClosingHour!.format(context);
                    }
                    if (_fridayOpeningHour != null) {
                      _fridayOpeningTime = _fridayOpeningHour!.format(context);
                    }
                    if (_fridayClosingHour != null) {
                      _fridayClosingTime = _fridayClosingHour!.format(context);
                    }
                    if (_saturdayOpeningHour != null) {
                      _saturdayOpeningTime =
                          _saturdayOpeningHour!.format(context);
                    }
                    if (_saturdayClosingHour != null) {
                      _saturdayClosingTime =
                          _saturdayClosingHour!.format(context);
                    }
                    if (_sundayOpeningHour != null) {
                      _sundayOpeningTime = _sundayOpeningHour!.format(context);
                    }
                    if (_sundayClosingHour != null) {
                      _sundayClosingTime = _sundayClosingHour!.format(context);
                    }

                    // Save business Operating hours
                    _businessProfileProvider.addOperatingTime(
                      mondayOpeningTime: _mondayOpeningTime,
                      mondayClosingTime: _mondayClosingTime,
                      tuesdayOpeningTime: _tuesdayOpeningTime,
                      tuesdayClosingTime: _tuesdayClosingTime,
                      wednesdayOpeningTime: _wednesdayOpeningTime,
                      wednesdayClosingTime: _wednesdayClosingTime,
                      thursdayOpeningTime: _thursdayOpeningTime,
                      thursdayClosingTime: _thursdayClosingTime,
                      fridayOpeningTime: _fridayOpeningTime,
                      fridayClosingTime: _fridayClosingTime,
                      saturdayOpeningTime: _saturdayOpeningTime,
                      saturdayClosingTime: _saturdayClosingTime,
                      sundayOpeningTime: _sundayOpeningTime,
                      sundayClosingTime: _sundayClosingTime,
                      isMondayOpen: _isMondayOpen,
                      isTuesdayOpen: _isTuesdayOpen,
                      isWednesdayOpen: _isWednesdayOpen,
                      isThursdayOpen: _isThursdayOpen,
                      isFridayOpen: _isFridayOpen,
                      isSaturdayOpen: _isSaturdayOpen,
                      isSundayOpen: _isSundayOpen,
                    );
                    // Navigate to Add Location Screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddLocationMap(),
                        settings: RouteSettings(name: 'AddLocationMapScreen'),
                      ),
                    );
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              title: Text('Operating Hours'),
            )
          : AppBar(
              actions: [
                TextButton(
                  onPressed: () {
                    String? _mondayOpeningTime;
                    String? _mondayClosingTime;
                    String? _tuesdayOpeningTime;
                    String? _tuesdayClosingTime;
                    String? _wednesdayOpeningTime;
                    String? _wednesdayClosingTime;
                    String? _thursdayOpeningTime;
                    String? _thursdayClosingTime;
                    String? _fridayOpeningTime;
                    String? _fridayClosingTime;
                    String? _saturdayOpeningTime;
                    String? _saturdayClosingTime;
                    String? _sundayOpeningTime;
                    String? _sundayClosingTime;

                    if (_mondayOpeningHour != null) {
                      _mondayOpeningTime = _mondayOpeningHour!.format(context);
                    }
                    if (_mondayClosingHour != null) {
                      _mondayClosingTime = _mondayClosingHour!.format(context);
                    }

                    if (_tuesdayOpeningHour != null) {
                      _tuesdayOpeningTime =
                          _tuesdayOpeningHour!.format(context);
                    }
                    if (_tuesdayClosingHour != null) {
                      _tuesdayClosingTime =
                          _tuesdayClosingHour!.format(context);
                    }
                    if (_wednesdayOpeningHour != null) {
                      _wednesdayOpeningTime =
                          _wednesdayOpeningHour!.format(context);
                    }
                    if (_wednesdayClosingHour != null) {
                      _wednesdayClosingTime =
                          _wednesdayClosingHour!.format(context);
                    }
                    if (_thursdayOpeningHour != null) {
                      _thursdayOpeningTime =
                          _thursdayOpeningHour!.format(context);
                    }
                    if (_thursdayClosingHour != null) {
                      _thursdayClosingTime =
                          _thursdayClosingHour!.format(context);
                    }
                    if (_fridayOpeningHour != null) {
                      _fridayOpeningTime = _fridayOpeningHour!.format(context);
                    }
                    if (_fridayClosingHour != null) {
                      _fridayClosingTime = _fridayClosingHour!.format(context);
                    }
                    if (_saturdayOpeningHour != null) {
                      _saturdayOpeningTime =
                          _saturdayOpeningHour!.format(context);
                    }
                    if (_saturdayClosingHour != null) {
                      _saturdayClosingTime =
                          _saturdayClosingHour!.format(context);
                    }
                    if (_sundayOpeningHour != null) {
                      _sundayOpeningTime = _sundayOpeningHour!.format(context);
                    }
                    if (_sundayClosingHour != null) {
                      _sundayClosingTime = _sundayClosingHour!.format(context);
                    }
                    _profileProvider.editOperatingHours(
                      isMondayOpen: _isMondayOpen,
                      isTuesdayOpen: _isTuesdayOpen,
                      isWednesdayOpen: _isWednesdayOpen,
                      isThursdayOpen: _isThursdayOpen,
                      isFridayOpen: _isFridayOpen,
                      isSaturdayOpen: _isSaturdayOpen,
                      isSundayOpen: _isSundayOpen,
                      userId: _currentUser!.uid,
                      mondayOpeningHours: _mondayOpeningTime,
                      mondayClosingHours: _mondayClosingTime,
                      tuesdayOpeningHours: _tuesdayOpeningTime,
                      tuesdayClosingHours: _tuesdayClosingTime,
                      wednesdayOpeningHours: _wednesdayOpeningTime,
                      wednesdayClosingHours: _wednesdayClosingTime,
                      thursdayOpeningHours: _thursdayOpeningTime,
                      thursdayClosingHours: _thursdayClosingTime,
                      fridayOpeningHours: _fridayOpeningTime,
                      fridayClosingHours: _fridayClosingTime,
                      saturdayOpeningHours: _saturdayOpeningTime,
                      saturdayClosingHours: _saturdayClosingTime,
                      sundayOpeningHours: _sundayOpeningTime,
                      sundayClosingHours: _sundayClosingTime,
                    );

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.pink,
                    ),
                  ),
                )
              ],
              title: Text('Edit Operating Hours'),
            ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.all(10),
            child: Text(
              "You can change operating hours later",
              style: GoogleFonts.gelasio(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20,
              left: 15,
            ),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FractionColumnWidth(.2),
                3: FractionColumnWidth(.08),
                5: FractionColumnWidth(.08),
              },
              children: [
                TableRow(
                  children: [
                    Text(
                      'Day',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Open',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Opening Time',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(),
                    Text(
                      'Closing Time',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Monday'),
                    Container(
                      alignment: Alignment.topLeft,
                      child: CupertinoSwitch(
                        activeColor: Colors.green,
                        value: _isMondayOpen,
                        onChanged: (bool value) {
                          setState(() {
                            _isMondayOpen = value;
                            if (value == false) {
                              _mondayOpeningHour = null;
                              _mondayClosingHour = null;
                            } else {
                              _mondayOpeningHour = TimeOfDay(hour: 08, minute: 00);
                              _mondayClosingHour = TimeOfDay(hour: 20, minute: 00);
                            }
                          });
                        },
                      ),
                    ),
                    (_isMondayOpen)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                            ),
                            onPressed: () async {
                              final TimeOfDay? _time =
                                  await selectTimeOfDay(context, _mondayOpeningHour!);
                              if (_time != null) {
                                setState(() {
                                  _mondayOpeningHour = _time;
                                });
                              }
                            },
                            child: Text(
                              _mondayOpeningHour!.format(context),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(),
                    (_isMondayOpen)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                            ),
                            onPressed: () async {
                              final TimeOfDay? _time =
                                  await selectTimeOfDay(context, _mondayClosingHour!);
                              if (_time != null) {
                                setState(() {
                                  _mondayClosingHour = _time;
                                });
                              }
                            },
                            child: Text(
                              _mondayClosingHour!.format(context),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Tuesday'),
                    Container(
                      alignment: Alignment.topLeft,
                      child: CupertinoSwitch(
                        activeColor: Colors.green,
                        value: _isTuesdayOpen,
                        onChanged: (bool value) {
                          setState(() {
                            _isTuesdayOpen = value;
                            if (value == false) {
                              _tuesdayOpeningHour = null;
                              _tuesdayClosingHour = null;
                            } else {
                              _tuesdayOpeningHour = TimeOfDay(hour: 08, minute: 00);
                              _tuesdayClosingHour = TimeOfDay(hour: 20, minute: 00);
                            }
                          });
                        },
                      ),
                    ),
                    (_isTuesdayOpen)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                            ),
                            onPressed: () async {
                              final TimeOfDay? _time = await selectTimeOfDay(
                                  context, _tuesdayOpeningHour!);
                              if (_time != null) {
                                setState(() {
                                  _tuesdayOpeningHour = _time;
                                });
                              }
                            },
                            child: Text(
                              _tuesdayOpeningHour!.format(context),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(),
                    (_isTuesdayOpen)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                            ),
                            onPressed: () async {
                              final TimeOfDay? _time = await selectTimeOfDay(
                                  context, _tuesdayClosingHour!);
                              if (_time != null) {
                                setState(() {
                                  _tuesdayClosingHour = _time;
                                });
                              }
                            },
                            child: Text(
                              _tuesdayClosingHour!.format(context),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Wednesday'),
                    Container(
                      alignment: Alignment.topLeft,
                      child: CupertinoSwitch(
                        activeColor: Colors.green,
                        value: _isWednesdayOpen,
                        onChanged: (bool value) {
                          setState(() {
                            _isWednesdayOpen = value;
                            if (value == false) {
                              _wednesdayOpeningHour = null;
                              _wednesdayClosingHour = null;
                            } else {
                              _wednesdayOpeningHour = TimeOfDay(hour: 08, minute: 00);
                              _wednesdayClosingHour = TimeOfDay(hour: 20, minute: 00);
                            }
                          });
                        },
                      ),
                    ),
                    (_isWednesdayOpen)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                            ),
                            onPressed: () async {
                              final TimeOfDay? _time = await selectTimeOfDay(
                                  context, _wednesdayOpeningHour!);
                              if (_time != null) {
                                setState(() {
                                  _wednesdayOpeningHour = _time;
                                });
                              }
                            },
                            child: Text(
                              _wednesdayOpeningHour!.format(context),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(),
                    (_isWednesdayOpen)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                            ),
                            onPressed: () async {
                              final TimeOfDay? _time = await selectTimeOfDay(
                                  context, _wednesdayClosingHour!);
                              if (_time != null) {
                                setState(() {
                                  _wednesdayClosingHour = _time;
                                });
                              }
                            },
                            child: Text(
                              _wednesdayClosingHour!.format(context),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Thursday'),
                    Container(
                      alignment: Alignment.topLeft,
                      child: CupertinoSwitch(
                        activeColor: Colors.green,
                        value: _isThursdayOpen,
                        onChanged: (bool value) {
                          setState(() {
                            _isThursdayOpen = value;
                            if (value == false) {
                              _thursdayOpeningHour = null;
                              _thursdayClosingHour = null;
                            } else {
                              _thursdayOpeningHour = TimeOfDay(hour: 08, minute: 00);
                              _thursdayClosingHour = TimeOfDay(hour: 20, minute: 00);
                            }
                          });
                        },
                      ),
                    ),
                    (_isThursdayOpen)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                            ),
                            onPressed: () async {
                              final TimeOfDay? _time = await selectTimeOfDay(
                                  context, _thursdayOpeningHour!);
                              if (_time != null) {
                                setState(() {
                                  _thursdayOpeningHour = _time;
                                });
                              }
                            },
                            child: Text(
                              _thursdayOpeningHour!.format(context),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(),
                    (_isThursdayOpen)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                            ),
                            onPressed: () async {
                              final TimeOfDay? _time = await selectTimeOfDay(
                                  context, _thursdayClosingHour!);
                              if (_time != null) {
                                setState(() {
                                  _thursdayClosingHour = _time;
                                });
                              }
                            },
                            child: Text(
                              _thursdayClosingHour!.format(context),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Friday'),
                    Container(
                      alignment: Alignment.topLeft,
                      child: CupertinoSwitch(
                        activeColor: Colors.green,
                        value: _isFridayOpen,
                        onChanged: (bool value) {
                          setState(() {
                            _isFridayOpen = value;
                            if (value == false) {
                              _fridayOpeningHour = null;
                              _fridayClosingHour = null;
                            } else {
                              _fridayOpeningHour = TimeOfDay(hour: 08, minute: 00);
                              _fridayClosingHour = TimeOfDay(hour: 20, minute: 00);
                            }
                          });
                        },
                      ),
                    ),
                    (_isFridayOpen)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                            ),
                            onPressed: () async {
                              final TimeOfDay? _time =
                                  await selectTimeOfDay(context, _fridayOpeningHour!);
                              if (_time != null) {
                                setState(() {
                                  _fridayOpeningHour = _time;
                                });
                              }
                            },
                            child: Text(
                              _fridayOpeningHour!.format(context),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(),
                    (_isFridayOpen)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                            ),
                            onPressed: () async {
                              final TimeOfDay? _time =
                                  await selectTimeOfDay(context, _fridayClosingHour!);
                              if (_time != null) {
                                setState(() {
                                  _fridayClosingHour = _time;
                                });
                              }
                            },
                            child: Text(
                              _fridayClosingHour!.format(context),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Saturday'),
                    Container(
                      alignment: Alignment.topLeft,
                      child: CupertinoSwitch(
                        activeColor: Colors.green,
                        value: _isSaturdayOpen,
                        onChanged: (bool value) {
                          setState(() {
                            _isSaturdayOpen = value;
                            if (value == false) {
                              _saturdayOpeningHour = null;
                              _saturdayClosingHour = null;
                            } else {
                              _saturdayOpeningHour = TimeOfDay(hour: 08, minute: 00);
                              _saturdayClosingHour = TimeOfDay(hour: 20, minute: 00);
                            }
                          });
                        },
                      ),
                    ),
                    (_isSaturdayOpen)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                            ),
                            onPressed: () async {
                              final TimeOfDay? _time = await selectTimeOfDay(
                                  context, _saturdayOpeningHour!);
                              if (_time != null) {
                                setState(() {
                                  _saturdayOpeningHour = _time;
                                });
                              }
                            },
                            child: Text(
                              _saturdayOpeningHour!.format(context),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(),
                    (_isSaturdayOpen)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                            ),
                            onPressed: () async {
                              final TimeOfDay? _time = await selectTimeOfDay(
                                  context, _saturdayClosingHour!);
                              if (_time != null) {
                                setState(() {
                                  _saturdayClosingHour = _time;
                                });
                              }
                            },
                            child: Text(
                              _saturdayClosingHour!.format(context),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Sunday'),
                    Container(
                      alignment: Alignment.topLeft,
                      child: CupertinoSwitch(
                        activeColor: Colors.green,
                        value: _isSundayOpen,
                        onChanged: (bool value) {
                          setState(() {
                            _isSundayOpen = value;
                            if (value == false) {
                              _sundayOpeningHour = null;
                              _sundayClosingHour = null;
                            } else {
                              _sundayOpeningHour = TimeOfDay(hour: 08, minute: 00);
                              _sundayClosingHour = TimeOfDay(hour: 20, minute: 00);
                            }
                          });
                        },
                      ),
                    ),
                    (_isSundayOpen)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                            ),
                            onPressed: () async {
                              final TimeOfDay? _time =
                                  await selectTimeOfDay(context, _sundayOpeningHour!);
                              if (_time != null) {
                                setState(() {
                                  _sundayOpeningHour = _time;
                                });
                              }
                            },
                            child: Text(
                              _sundayOpeningHour!.format(context),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(),
                    (_isSundayOpen)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(3),
                            ),
                            onPressed: () async {
                              final TimeOfDay? _time =
                                  await selectTimeOfDay(context, _sundayClosingHour!);
                              if (_time != null) {
                                setState(() {
                                  _sundayClosingHour = _time;
                                });
                              }
                            },
                            child: Text(
                              _sundayClosingHour!.format(context),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
