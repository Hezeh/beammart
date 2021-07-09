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
    if (mondayOpeningTime.contains("AM") || mondayOpeningTime.contains("PM")) {
      _mondayOpeningTime = toDouble(
          TimeOfDay.fromDateTime(DateFormat.jm().parse(mondayOpeningTime)));
    } else {
      _mondayOpeningTime = toDouble(
        TimeOfDay(
          hour: int.parse(mondayOpeningTime.split(":")[0]),
          minute: int.parse(mondayOpeningTime.split(":")[1]),
        ),
      );
    }
  }
  if (mondayClosingTime != null) {
    if (mondayClosingTime.contains("AM") || mondayClosingTime.contains("PM")) {
      _mondayClosingTime = toDouble(
          TimeOfDay.fromDateTime(DateFormat.jm().parse(mondayClosingTime)));
    } else {
      _mondayClosingTime = toDouble(
        TimeOfDay(
          hour: int.parse(mondayClosingTime.split(":")[0]),
          minute: int.parse(mondayClosingTime.split(":")[1]),
        ),
      );
    }
  }
  if (tuesdayOpeningTime != null) {
    if (tuesdayOpeningTime.contains("AM") ||
        tuesdayOpeningTime.contains("PM")) {
      _tuesdayOpeningTime = toDouble(
          TimeOfDay.fromDateTime(DateFormat.jm().parse(tuesdayOpeningTime)));
    } else {
      _tuesdayOpeningTime = toDouble(
        TimeOfDay(
          hour: int.parse(tuesdayOpeningTime.split(":")[0]),
          minute: int.parse(tuesdayOpeningTime.split(":")[1]),
        ),
      );
    }
  }
  if (tuesdayClosingTime != null) {
    if (tuesdayClosingTime.contains("AM") ||
        tuesdayClosingTime.contains("PM")) {
      _tuesdayClosingTime = toDouble(
          TimeOfDay.fromDateTime(DateFormat.jm().parse(tuesdayClosingTime)));
    } else {
      _tuesdayClosingTime = toDouble(
        TimeOfDay(
          hour: int.parse(tuesdayClosingTime.split(":")[0]),
          minute: int.parse(tuesdayClosingTime.split(":")[1]),
        ),
      );
    }
  }
  if (wednesdayOpeningTime != null) {
    if (wednesdayOpeningTime.contains("AM") ||
        wednesdayOpeningTime.contains("PM")) {
      _wednesdayOpeningTime = toDouble(
          TimeOfDay.fromDateTime(DateFormat.jm().parse(wednesdayOpeningTime)));
    } else {
      _wednesdayOpeningTime = toDouble(
        TimeOfDay(
          hour: int.parse(wednesdayOpeningTime.split(":")[0]),
          minute: int.parse(wednesdayOpeningTime.split(":")[1]),
        ),
      );
    }
  }
  if (wednesdayClosingTime != null) {
    if (wednesdayClosingTime.contains("AM") ||
        wednesdayClosingTime.contains("PM")) {
      _wednesdayClosingTime = toDouble(
          TimeOfDay.fromDateTime(DateFormat.jm().parse(wednesdayClosingTime)));
    } else {
      _wednesdayClosingTime = toDouble(
        TimeOfDay(
          hour: int.parse(wednesdayClosingTime.split(":")[0]),
          minute: int.parse(wednesdayClosingTime.split(":")[1]),
        ),
      );
    }
  }
  if (thursdayOpeningTime != null) {
    if (thursdayOpeningTime.contains("AM") ||
        thursdayOpeningTime.contains("PM")) {
      _thursdayOpeningTime = toDouble(
          TimeOfDay.fromDateTime(DateFormat.jm().parse(thursdayOpeningTime)));
    } else {
      _thursdayOpeningTime = toDouble(
        TimeOfDay(
          hour: int.parse(thursdayOpeningTime.split(":")[0]),
          minute: int.parse(thursdayOpeningTime.split(":")[1]),
        ),
      );
    }
  }
  if (thursdayClosingTime != null) {
    if (thursdayClosingTime.contains("AM") ||
        thursdayClosingTime.contains("PM")) {
      _thursdayClosingTime = toDouble(
          TimeOfDay.fromDateTime(DateFormat.jm().parse(thursdayClosingTime)));
    } else {
      _thursdayClosingTime = toDouble(
        TimeOfDay(
          hour: int.parse(thursdayClosingTime.split(":")[0]),
          minute: int.parse(thursdayClosingTime.split(":")[1]),
        ),
      );
    }
  }
  if (fridayOpeningTime != null) {
    if (fridayOpeningTime.contains("AM") || fridayOpeningTime.contains("PM")) {
      _fridayOpeningTime = toDouble(
          TimeOfDay.fromDateTime(DateFormat.jm().parse(fridayOpeningTime)));
    } else {
      _fridayOpeningTime = toDouble(
        TimeOfDay(
          hour: int.parse(fridayOpeningTime.split(":")[0]),
          minute: int.parse(fridayOpeningTime.split(":")[1]),
        ),
      );
    }
  }
  if (fridayClosingTime != null) {
    if (fridayClosingTime.contains("AM") || fridayClosingTime.contains("PM")) {
      _fridayClosingTime = toDouble(
          TimeOfDay.fromDateTime(DateFormat.jm().parse(fridayClosingTime)));
    } else {
      _fridayClosingTime = toDouble(
        TimeOfDay(
          hour: int.parse(fridayClosingTime.split(":")[0]),
          minute: int.parse(fridayClosingTime.split(":")[1]),
        ),
      );
    }
  }
  if (saturdayOpeningTime != null) {
    if (saturdayOpeningTime.contains("AM") ||
        saturdayOpeningTime.contains("PM")) {
      _saturdayOpeningTime = toDouble(
          TimeOfDay.fromDateTime(DateFormat.jm().parse(saturdayOpeningTime)));
    } else {
      _saturdayOpeningTime = toDouble(
        TimeOfDay(
          hour: int.parse(saturdayOpeningTime.split(":")[0]),
          minute: int.parse(saturdayOpeningTime.split(":")[1]),
        ),
      );
    }
  }
  if (saturdayClosingTime != null) {
    if (saturdayClosingTime.contains("AM") ||
        saturdayClosingTime.contains("PM")) {
      _saturdayClosingTime = toDouble(
          TimeOfDay.fromDateTime(DateFormat.jm().parse(saturdayClosingTime)));
    } else {
      _saturdayClosingTime = toDouble(
        TimeOfDay(
          hour: int.parse(saturdayClosingTime.split(":")[0]),
          minute: int.parse(saturdayClosingTime.split(":")[1]),
        ),
      );
    }
  }
  if (sundayOpeningTime != null) {
    if (sundayOpeningTime.contains("AM") || sundayOpeningTime.contains("PM")) {
      _sundayOpeningTime = toDouble(
          TimeOfDay.fromDateTime(DateFormat.jm().parse(sundayOpeningTime)));
    } else {
      _sundayOpeningTime = toDouble(
        TimeOfDay(
          hour: int.parse(sundayOpeningTime.split(":")[0]),
          minute: int.parse(sundayOpeningTime.split(":")[1]),
        ),
      );
    }
  }
  if (sundayClosingTime != null) {
    if (sundayClosingTime.contains("AM") || sundayClosingTime.contains("PM")) {
      _sundayClosingTime = toDouble(
          TimeOfDay.fromDateTime(DateFormat.jm().parse(sundayClosingTime)));
    } else {
      _sundayClosingTime = toDouble(
        TimeOfDay(
          hour: int.parse(sundayClosingTime.split(":")[0]),
          minute: int.parse(sundayClosingTime.split(":")[1]),
        ),
      );
    }
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
