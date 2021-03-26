import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

bool isBusinessOpen({
  @required String today,
  bool isMondayOpen,
  bool isTuesdayOpen,
  bool isWednesdayOpen,
  bool isThursdayOpen,
  bool isFridayOpen,
  bool isSaturdayOpen,
  bool isSundayOpen,
  @required String mondayOpeningTime,
  @required String mondayClosingTime,
  @required String tuesdayOpeningTime,
  @required String tuesdayClosingTime,
  @required String wednesdayOpeningTime,
  @required String wednesdayClosingTime,
  @required String thursdayOpeningTime,
  @required String thursdayClosingTime,
  @required String fridayOpeningTime,
  @required String fridayClosingTime,
  @required String saturdayOpeningTime,
  @required String saturdayClosingTime,
  @required String sundayOpeningTime,
  @required String sundayClosingTime,
}) {
  print(today);
  final double _currentTime = toDouble(TimeOfDay.now());
  final double _mondayOpeningTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(mondayOpeningTime)));
  final double _mondayClosingTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(mondayClosingTime)));
  final double _tuesdayOpeningTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(tuesdayOpeningTime)));
  final double _tuesdayClosingTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(tuesdayClosingTime)));
  final double _wednesdayOpeningTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(wednesdayOpeningTime)));
  final double _wednesdayClosingTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(wednesdayClosingTime)));
  final double _thursdayOpeningTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(thursdayOpeningTime)));
  final double _thursdayClosingTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(thursdayClosingTime)));
  final double _fridayOpeningTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(fridayOpeningTime)));
  final double _fridayClosingTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(fridayClosingTime)));
  final double _saturdayOpeningTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(saturdayOpeningTime)));
  final double _saturdayClosingTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(saturdayClosingTime)));
  final double _sundayOpeningTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(sundayOpeningTime)));
  final double _sundayClosingTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(sundayClosingTime)));
  if (today == 'Monday') {
    if (isMondayOpen && _currentTime > _mondayOpeningTime &&
        _currentTime < _mondayClosingTime) {
      return true;
    } else {
      return false;
    }
  } else if (today == 'Tuesday') {
    if (isTuesdayOpen && _currentTime > _tuesdayOpeningTime &&
        _currentTime < _tuesdayClosingTime) {
      return true;
    } else {
      return false;
    }
  } else if (today == 'Wednesday') {
    if (isWednesdayOpen && _currentTime > _wednesdayOpeningTime &&
        _currentTime < _wednesdayClosingTime) {
      return true;
    } else {
      return false;
    }
  } else if (today == 'Thursday') {
    if (isThursdayOpen && _currentTime > _thursdayOpeningTime &&
        _currentTime < _thursdayClosingTime) {
      return true;
    } else {
      return false;
    }
  } else if (today == 'Friday') {
    if (isFridayOpen && _currentTime > _fridayOpeningTime &&
        _currentTime < _fridayClosingTime) {
      return true;
    } else {
      return false;
    }
  } else if (today == 'Saturday') {
    if (isSaturdayOpen && _currentTime > _saturdayOpeningTime &&
        _currentTime < _saturdayClosingTime) {
      return true;
    } else {
      return false;
    }
  } else if (today == 'Sunday') {
    if (isSundayOpen && _currentTime > _sundayOpeningTime &&
        _currentTime < _sundayClosingTime) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
