import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

bool isBusinessOpen({
  required String today,
  bool? isMondayOpen,
  bool? isTuesdayOpen,
  bool? isWednesdayOpen,
  bool? isThursdayOpen,
  bool? isFridayOpen,
  bool? isSaturdayOpen,
  bool? isSundayOpen,
  required String? mondayOpeningTime,
  required String? mondayClosingTime,
  required String? tuesdayOpeningTime,
  required String? tuesdayClosingTime,
  required String? wednesdayOpeningTime,
  required String? wednesdayClosingTime,
  required String? thursdayOpeningTime,
  required String? thursdayClosingTime,
  required String? fridayOpeningTime,
  required String? fridayClosingTime,
  required String? saturdayOpeningTime,
  required String? saturdayClosingTime,
  required String? sundayOpeningTime,
  required String? sundayClosingTime,
}) {
  print(today);
  final double _currentTime = toDouble(TimeOfDay.now());
  double? _mondayOpeningTime;
  double? _mondayClosingTime;
  double? _tuesdayOpeningTime;
  double? _tuesdayClosingTime;
  double? _wednesdayClosingTime;
  double? _wednesdayOpeningTime;
  double? _thursdayOpeningTime;
  double? _thursdayClosingTime;
  double? _fridayOpeningTime;
  double? _fridayClosingTime;
  double? _saturdayOpeningTime;
  double? _saturdayClosingTime;
  double? _sundayOpeningTime;
  double? _sundayClosingTime;
  if (mondayOpeningTime != null) {
    _mondayOpeningTime = toDouble(
        TimeOfDay.fromDateTime(DateFormat.jm().parse(mondayOpeningTime)));
  }
  if (mondayClosingTime != null) {
    _mondayClosingTime = toDouble(
        TimeOfDay.fromDateTime(DateFormat.jm().parse(mondayClosingTime)));
  }
  if (tuesdayOpeningTime != null) {
    _tuesdayOpeningTime = toDouble(
        TimeOfDay.fromDateTime(DateFormat.jm().parse(tuesdayOpeningTime)));
  }
  if (tuesdayClosingTime != null) {
    _tuesdayClosingTime = toDouble(
        TimeOfDay.fromDateTime(DateFormat.jm().parse(tuesdayClosingTime)));
  }
  if (wednesdayOpeningTime != null) {
    _wednesdayOpeningTime = toDouble(
        TimeOfDay.fromDateTime(DateFormat.jm().parse(wednesdayOpeningTime)));
  }
  if (wednesdayClosingTime != null) {
    _wednesdayClosingTime = toDouble(
        TimeOfDay.fromDateTime(DateFormat.jm().parse(wednesdayClosingTime)));
  }
  if (thursdayOpeningTime != null) {
    _thursdayOpeningTime = toDouble(
        TimeOfDay.fromDateTime(DateFormat.jm().parse(thursdayOpeningTime)));
  }
  if (thursdayClosingTime != null) {
    _thursdayClosingTime = toDouble(
        TimeOfDay.fromDateTime(DateFormat.jm().parse(thursdayClosingTime)));
  }
  if (fridayOpeningTime != null) {
    _fridayOpeningTime = toDouble(
        TimeOfDay.fromDateTime(DateFormat.jm().parse(fridayOpeningTime)));
  }
  if (fridayClosingTime != null) {
    _fridayClosingTime = toDouble(
        TimeOfDay.fromDateTime(DateFormat.jm().parse(fridayClosingTime)));
  }
  if (saturdayOpeningTime != null) {
    _saturdayOpeningTime = toDouble(
        TimeOfDay.fromDateTime(DateFormat.jm().parse(saturdayOpeningTime)));
  }
  if (saturdayClosingTime != null) {
    _saturdayClosingTime = toDouble(
        TimeOfDay.fromDateTime(DateFormat.jm().parse(saturdayClosingTime)));
  }
  if (sundayOpeningTime != null) {
    _sundayOpeningTime = toDouble(
        TimeOfDay.fromDateTime(DateFormat.jm().parse(sundayOpeningTime)));
  }
  if (sundayClosingTime != null) {
    _sundayClosingTime = toDouble(
        TimeOfDay.fromDateTime(DateFormat.jm().parse(sundayClosingTime)));
  }
  if (today == 'Monday') {
    if (_mondayOpeningTime != null && _mondayClosingTime != null) {
      if (isMondayOpen! &&
          _currentTime > _mondayOpeningTime &&
          _currentTime < _mondayClosingTime) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else if (today == 'Tuesday') {
    if (_tuesdayOpeningTime != null && _tuesdayClosingTime != null) {
      if (isTuesdayOpen! &&
          _currentTime > _tuesdayOpeningTime &&
          _currentTime < _tuesdayClosingTime) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else if (today == 'Wednesday') {
    if (_wednesdayOpeningTime != null && _wednesdayClosingTime != null) {
      if (isWednesdayOpen! &&
          _currentTime > _wednesdayOpeningTime &&
          _currentTime < _wednesdayClosingTime) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else if (today == 'Thursday') {
    if (_thursdayOpeningTime != null && _thursdayClosingTime != null) {
      if (isThursdayOpen! &&
          _currentTime > _thursdayOpeningTime &&
          _currentTime < _thursdayClosingTime) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else if (today == 'Friday') {
    if (_fridayOpeningTime != null && _fridayClosingTime != null) {
      if (isFridayOpen! &&
          _currentTime > _fridayOpeningTime &&
          _currentTime < _fridayClosingTime) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else if (today == 'Saturday') {
    if (_saturdayOpeningTime != null && _saturdayClosingTime != null) {
      if (isSaturdayOpen! &&
          _currentTime > _saturdayOpeningTime &&
          _currentTime < _saturdayClosingTime) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else if (today == 'Sunday') {
    if (_sundayOpeningTime != null && _sundayClosingTime != null) {
      if (isSundayOpen! &&
          _currentTime > _sundayOpeningTime &&
          _currentTime < _sundayClosingTime) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } else {
    return false;
  }
}
