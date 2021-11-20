import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///***************************************
///    Ahmed Ashour Constant             *
///***************************************
const String BaseUrl = 'http://hrms.fsdmarketing.com/api/v1/';

//String Culture = 'en';
const String MAPAPIKEY = 'AIzaSyCdVIteMWFxbV6WMKh-8FopoExTanQCCIg';
const String kLogo = "assets/images/white.png";
const String kLogoBlack = "assets/images/logo_black.png";
const primaryColor = Color(0xffff0d0d);
const accentColor = Color(0xff77838f);

/// Colors   ----------------------------------------
hexColor(String _colorHexCode) {
  String colornew = '0xff' + _colorHexCode;
  colornew = colornew.replaceAll('#', '');
  int colorInt = int.parse(colornew);
  return colorInt;
}

Color PrimaryColor = Color(hexColor("#ff0d0d"));
Color AccentColor = Color(hexColor("#77838f"));

Widget loading() {
  return Center(
    child: Image.asset(
      'assets/images/loading.gif',
      width: ScreenUtil().setWidth(100),
      height: ScreenUtil().setHeight(100),
      fit: BoxFit.fill,
    ),
  );
}

enum UserType { customer, salesPerson }
bool emailIsValid(String email) {
  return !RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

Widget loadingTow(width) {
  return Center(
    child: Image.asset(
      'assets/images/loading.gif',
      width: ScreenUtil().setWidth(width),
      height: ScreenUtil().setWidth(width),
      fit: BoxFit.fill,
    ),
  );
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  return htmlText
      .replaceAll(exp, '\n')
      .replaceAll('\n\n', '\n')
      .replaceAll('\n\n', '\n');
}
