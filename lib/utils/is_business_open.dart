import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

bool isBusinessOpen({
  @required String today,
  @required String mondayOpeningTime,
  @required String mondayClosingTime,
  @required String tuesdayOpeningTime,
  @required String tuesdayclosingTime,
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
  final double _currentTime = toDouble(TimeOfDay.now());
  final double _mondayOpeningTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(mondayOpeningTime)));
  final double _mondayClosingTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(mondayOpeningTime)));
  final double _tuesdayOpeningTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(tuesdayOpeningTime)));
  final double _tuesdayClosingTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(tuesdayOpeningTime)));
  final double _wednesdayOpeningTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(wednesdayOpeningTime)));
  final double _wednesdayClosingTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(wednesdayOpeningTime)));
  final double _thursdayOpeningTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(thursdayOpeningTime)));
  final double _thursdayClosingTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(thursdayOpeningTime)));
  final double _fridayOpeningTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(fridayOpeningTime)));
  final double _fridayClosingTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(fridayOpeningTime)));
  final double _saturdayOpeningTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(saturdayOpeningTime)));
  final double _saturdayClosingTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(saturdayOpeningTime)));
  final double _sundayOpeningTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(sundayOpeningTime)));
  final double _sundayClosingTime = toDouble(
      TimeOfDay.fromDateTime(DateFormat.jm().parse(sundayOpeningTime)));
  if (today == 'Monday') {
    if (_currentTime > _mondayOpeningTime &&
        _currentTime < _mondayClosingTime) {
      return true;
    } else {
      return false;
    }
  } else if (today == 'Tuesday') {
    if (_currentTime > _tuesdayOpeningTime &&
        _currentTime < _tuesdayClosingTime) {
      return true;
    } else {
      return false;
    }
  } else if (today == 'Wednesday') {
    if (_currentTime > _wednesdayOpeningTime &&
        _currentTime < _wednesdayClosingTime) {
      return true;
    } else {
      return false;
    }
  } else if (today == 'Thursday') {
    if (_currentTime > _thursdayOpeningTime &&
        _currentTime < _thursdayClosingTime) {
      return true;
    } else {
      return false;
    }
  } else if (today == 'Friday') {
    if (_currentTime > _fridayOpeningTime &&
        _currentTime < _fridayClosingTime) {
      return true;
    } else {
      return false;
    }
  } else if (today == 'Saturday') {
    if (_currentTime > _saturdayOpeningTime &&
        _currentTime < _saturdayClosingTime) {
      return true;
    } else {
      return false;
    }
  } else if (today == 'Sunday') {
    if (_currentTime > _sundayOpeningTime &&
        _currentTime < _sundayClosingTime) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
