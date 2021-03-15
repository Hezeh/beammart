import 'package:flutter/foundation.dart';

String closingOpeningTimeUtil({
  @required bool isOpen,
  @required String today,
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
  if (today == 'Monday') {
    if (isOpen) {
      return 'Closes @ $mondayClosingTime';
    } else {
      return 'Opens @ $mondayOpeningTime';
    }
  } else if (today == 'Tuesday') {
    if (isOpen) {
      return 'Closes @ $tuesdayClosingTime';
    } else {
      return 'Opens @ $tuesdayOpeningTime';
    }
  } else if (today == 'Wednesday') {
    if (isOpen) {
      return 'Closes @ $wednesdayClosingTime';
    } else {
      return 'Opens @ $wednesdayOpeningTime';
    }
  } else if (today == 'Thursday') {
    if (isOpen) {
      return 'Closes @ $thursdayClosingTime';
    } else {
      return 'Opens @ $thursdayOpeningTime';
    }
  } else if (today == 'Friday') {
    if (isOpen) {
      return 'Closes @ $fridayClosingTime';
    } else {
      return 'Opens @ $fridayOpeningTime';
    }
  } else if (today == 'Saturday') {
    if (isOpen) {
      return 'Closes @ $saturdayClosingTime';
    } else {
      return 'Opens @ $saturdayOpeningTime';
    }
  } else if (today == 'Sunday') {
    if (isOpen) {
      return 'Closes @ $sundayClosingTime';
    } else {
      return 'Opens @ $sundayOpeningTime';
    }
  } else {
    return 'Operating Time Unknown';
  }
}
