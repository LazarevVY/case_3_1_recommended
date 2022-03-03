import 'dart:core';

import 'package:flutter/material.dart';

class Settings {
  final int userNameMaxLength = 16;
  final int phoneMaxLength    = 10;
  final int passSafeLength    = 8;
  final int passMaxLength     = 10;
  final routeStartScreen      = '/';
  final routeAuthScreen       = '/auth';
  final routeRegisterScreen   = '/register';
  final routeHomeScreen       = '/home';
  final String   userDataFile = "userdata";
  bool      registered        = false;
  bool      userLoggedIn      = true;//false;
  String?   userData;
  String? userName;
  bool userDataReady          = false;
}