
import 'package:flutter/cupertino.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/string.dart';

import '../../../AppLocalizations.dart';

enum VALIDATION_TYPE { EMAIL, TEXT, PASSWORD, CONFIRM_PASSWORD }

BuildContext buildContext;

RegExp _emailReg = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

String isRequired(String val, String fieldName) {
  if (val == null || val == '') {
    return "$fieldName";
  }
  return null;
}

String checkPasswordLength(String val) {
  if (val.length < 6) {
    return AppLocalizations.of(buildContext)
        .translate(Strings.PASSWORD_VALIDATION);
  }
  return null;
}

String checkFieldValidation(
    {String val,
      String fieldName,
      VALIDATION_TYPE fieldType,
      String password,
      BuildContext context}) {
  buildContext = context;
  String errorMsg;

  if (fieldType == VALIDATION_TYPE.TEXT) {
    errorMsg = isRequired(val, fieldName);
  }
  if (fieldType == VALIDATION_TYPE.EMAIL) {
    if (isRequired(val, fieldName) != null) {
      errorMsg = isRequired(val, fieldName);
    } else if (!_emailReg.hasMatch(val)) {
      errorMsg =
          AppLocalizations.of(buildContext).translate(Strings.EMAIL_VALIDATION);
    }
  }
  if (fieldType == VALIDATION_TYPE.PASSWORD) {
    if (isRequired(val, fieldName) != null) {
      errorMsg = isRequired(val, fieldName);
    } else if (checkPasswordLength(val) != null) {
      errorMsg = checkPasswordLength(val);
    }
  }
  if (fieldType == VALIDATION_TYPE.CONFIRM_PASSWORD) {
    if (isRequired(val, fieldName) != null) {
      errorMsg = isRequired(val, fieldName);
    } else if (checkPasswordLength(val) != null) {
      errorMsg = checkPasswordLength(val);
    } else if (password != val) {
      errorMsg = AppLocalizations.of(buildContext)
          .translate(Strings.CONFIRM_PASSWORD_VALIDATION);
    }
  }

  return (errorMsg != null) ? errorMsg : null;
}
