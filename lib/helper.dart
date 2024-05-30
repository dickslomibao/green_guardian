import 'package:etr_mark/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// It return true if valid
bool validateRegistrationForm({
  required String fullName,
  required String email,
  required String password,
  required String passwordConfirmation,
}) {
  if (fullName.isEmpty) {
    handleToastError('Full name is required.');
    return false;
  }
  if (email.isEmpty) {
    handleToastError('Email is required.');
    return false;
  }
  if (password.isEmpty) {
    handleToastError('Password is required.');
    return false;
  }
  if (password.length < 8) {
    handleToastError('Your password must be at least 8 characters long.');
    return false;
  }
  if (passwordConfirmation.isEmpty) {
    handleToastError('Password Confirmation is required.');
    return false;
  }
  if (password != passwordConfirmation) {
    handleToastError('Password did not matched.');
    return false;
  }
  return true;
}

/// It return true if valid
bool validateChangePasswordForm({
  required String currentPassword,
  required String password,
  required String passwordConfirmation,
}) {
  if (currentPassword.isEmpty) {
    handleToastError('Current password is required.');
    return false;
  }
  if (password.isEmpty) {
    handleToastError('Password is required.');
    return false;
  }
  if (password.length < 8) {
    handleToastError('Your password must be at least 8 characters long.');
    return false;
  }
  if (passwordConfirmation.isEmpty) {
    handleToastError('Password Confirmation is required.');
    return false;
  }
  if (password != passwordConfirmation) {
    handleToastError('Password did not matched.');
    return false;
  }
  return true;
}

/// It return true if valid
bool validateLoginForm({
  required String email,
  required String password,
}) {
  if (email.isEmpty) {
    handleToastError('Email is required.');
    return false;
  }
  if (password.isEmpty) {
    handleToastError('Password is required.');
    return false;
  }

  return true;
}

String withNullCheckerGetName({
  String? data,
}) {
  return data ?? "User";
}

void firebaseAuthExceptionHandler(e) {
  String message = "Cannot process the operation. Please try again";
  if (e.code == 'weak-password') {
    message = 'The password provided is too weak.';
  } else if (e.code == 'invalid-email') {
    message = 'The Email provided is on invalid format.';
  } else if (e.code == 'email-already-in-use') {
    message = 'The account already exists for that email.';
  } else if (e.code == 'account-exists-with-different-credential') {
    message = 'The account already exists with other social.';
  } else if (e.code == 'user-disabled') {
    message = 'The account has been disabled. Please contact administrator';
  } else if (e.code == 'user-not-found') {
    message = 'Your email provided is not found.';
  } else if (e.code == 'wrong-password') {
    message = 'Your Password is incorrect.';
  } else if (e.code == 'invalid-credential') {
    message = 'Your given credential is invalid.';
  } else if (e.code == 'too-many-requests') {
    message = 'Too many request. Please try again letter';
  } else if (e.code == 'requires-recent-login') {
    message = 'Incorrect current password.';
  }
  handleToastError(message);
}

void handleToastError(message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void handleToastSuccess(message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: primaryColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

String toTitleCase(String title) {
  if (title.isEmpty) return "";
  return title
      .split(' ')
      .map((word) => word.replaceFirst(word[0], word[0].toUpperCase()))
      .join(' ');
}
