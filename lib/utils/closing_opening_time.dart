import 'package:flutter/foundation.dart';

String closingOpeningTimeUtil({
  @required bool isOpen,
  @required String today,
  @required bool mondayIsOpen,
  @required bool tuesdayIsOpen,
  @required bool wednesdayIsOpen,
  @required bool thursdayIsOpen,
  @required bool fridayIsOpen,
  @required bool saturdayIsOpen,
  @required bool sundayIsOpen,
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
  // Check what the day it is
  // If the merchant opens on that date show opening/closing time
  // depending on the date current isOpen status
  // Else check whether the merchant is open the next day
  // Showing the opening time of that day
  if (today == 'Monday') {
    if (mondayIsOpen) {
      if (isOpen) {
        return 'Closes @ $mondayClosingTime';
      } else {
        return 'Opens @ $mondayOpeningTime';
      }
    } else if (tuesdayIsOpen) {
      return 'Opens Tomorrow @ $tuesdayOpeningTime';
    } else if (wednesdayIsOpen) {
      return 'Opens Wednesday @ $wednesdayOpeningTime';
    } else if (thursdayIsOpen) {
      return 'Opens Thursday @ $thursdayOpeningTime';
    } else if (fridayIsOpen) {
      return 'Opens Friday @ $fridayOpeningTime';
    } else if (saturdayIsOpen) {
      return 'Opens Saturday @ $saturdayOpeningTime';
    } else if (sundayIsOpen) {
      return 'Opens Sunday @ $sundayOpeningTime';
    } else {
      return 'No Operating Time';
    }
  } else if (today == 'Tuesday') {
    if (tuesdayIsOpen) {
      if (isOpen) {
        return 'Closes @ $tuesdayClosingTime';
      } else {
        return 'Opens @ $tuesdayOpeningTime';
      }
    } else if (wednesdayIsOpen) {
      return 'Opens Tomorrow @ $wednesdayOpeningTime';
    } else if (thursdayIsOpen) {
      return 'Opens Thursday @ $thursdayOpeningTime';
    } else if (fridayIsOpen) {
      return 'Opens Friday @ $fridayOpeningTime';
    } else if (saturdayIsOpen) {
      return 'Opens Saturday @ $saturdayOpeningTime';
    } else if (sundayIsOpen) {
      return 'Opens Sunday @ $sundayOpeningTime';
    } else if (mondayIsOpen) {
      return 'Opens Monday @ $mondayOpeningTime';
    } else {
      return 'No Operating Time';
    }
  } else if (today == 'Wednesday') {
    if (wednesdayIsOpen) {
      if (isOpen) {
        return 'Closes @ $wednesdayClosingTime';
      } else {
        return 'Opens @ $wednesdayOpeningTime';
      }
    } else if (thursdayIsOpen) {
      return 'Opens Tomorrow @ $thursdayOpeningTime';
    } else if (fridayIsOpen) {
      return 'Opens Friday @ $fridayOpeningTime';
    } else if (saturdayIsOpen) {
      return 'Opens Saturday @ $saturdayOpeningTime';
    } else if (sundayIsOpen) {
      return 'Opens Sunday @ $sundayOpeningTime';
    } else if (mondayIsOpen) {
      return 'Opens Monday @ $mondayOpeningTime';
    } else if (tuesdayIsOpen) {
      return 'Opens Tuesday @ $tuesdayOpeningTime';
    } else {
      return 'No Operating Time';
    }
  } else if (today == 'Thursday') {
    if (thursdayIsOpen) {
      if (isOpen) {
        return 'Closes @ $thursdayClosingTime';
      } else {
        return 'Opens @ $thursdayOpeningTime';
      }
    } else if (fridayIsOpen) {
      return 'Opens Tomorrow @ $fridayOpeningTime';
    } else if (saturdayIsOpen) {
      return 'Opens Saturday @ $saturdayOpeningTime';
    } else if (sundayIsOpen) {
      return 'Opens Sunday @ $sundayOpeningTime';
    } else if (mondayIsOpen) {
      return 'Opens Monday @ $mondayOpeningTime';
    } else if (tuesdayIsOpen) {
      return 'Opens Tuesday @ $tuesdayOpeningTime';
    } else if (wednesdayIsOpen) {
      return 'Opens Wednesday @ $wednesdayOpeningTime';
    } else {
      return 'No Operating Time';
    }
  } else if (today == 'Friday') {
    if (fridayIsOpen) {
      if (isOpen) {
        return 'Closes @ $fridayClosingTime';
      } else {
        return 'Opens @ $fridayOpeningTime';
      }
    } else if (saturdayIsOpen) {
      return 'Opens Tomorrow @ $saturdayOpeningTime';
    } else if (sundayIsOpen) {
      return 'Opens Sunday @ $sundayOpeningTime';
    } else if (mondayIsOpen) {
      return 'Opens Monday @ $mondayOpeningTime';
    } else if (tuesdayIsOpen) {
      return 'Opens Tuesday @ $tuesdayOpeningTime';
    } else if (wednesdayIsOpen) {
      return 'Opens Wednesday @ $wednesdayOpeningTime';
    } else if (thursdayIsOpen) {
      return 'Opens Thursday @ $thursdayOpeningTime';
    } else {
      return 'No Operating Time';
    }
  } else if (today == 'Saturday') {
    if (saturdayIsOpen) {
      if (isOpen) {
        return 'Closes @ $saturdayClosingTime';
      } else {
        return 'Opens @ $saturdayOpeningTime';
      }
    } else if (sundayIsOpen) {
      return 'Opens Tomorrow @ $sundayOpeningTime';
    } else if (mondayIsOpen) {
      return 'Opens Monday @ $mondayOpeningTime';
    } else if (tuesdayIsOpen) {
      return 'Opens Tuesday @ $tuesdayOpeningTime';
    } else if (wednesdayIsOpen) {
      return 'Opens Wednesday @ $wednesdayOpeningTime';
    } else if (thursdayIsOpen) {
      return 'Opens Thursday @ $thursdayOpeningTime';
    } else if (fridayIsOpen) {
      return 'Opens Friday @ $fridayOpeningTime';
    } else {
      return 'No Operating Time';
    }
  } else if (today == 'Sunday') {
    if (sundayIsOpen) {
      if (isOpen) {
        return 'Closes @ $sundayClosingTime';
      } else {
        return 'Opens @ $sundayOpeningTime';
      }
    } else if (mondayIsOpen) {
      return 'Opens Tomorrow @ $mondayOpeningTime';
    } else if (tuesdayIsOpen) {
      return 'Opens Tuesday @ $tuesdayOpeningTime';
    } else if (wednesdayIsOpen) {
      return 'Opens Wednesday @ $wednesdayOpeningTime';
    } else if (thursdayIsOpen) {
      return 'Opens Thursday @ $thursdayOpeningTime';
    } else if (fridayIsOpen) {
      return 'Opens Friday @ $fridayOpeningTime';
    } else if (saturdayIsOpen) {
      return 'Opens Saturday @ $saturdayOpeningTime';
    } else {
      return 'No Operating Time';
    }
  } else {
    return 'Operating Time Unknown';
  }
}
