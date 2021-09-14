import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class UserData {
  String token;
  String name;
  String email;
  String phone;
  int role_id;
  UserData({this.token, this.name, this.email, this.phone, this.role_id});
  UserData.fromLoginJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['user'] != null) {
      name = json['user']['name'];
      email = json['user']['email'];
      phone = json['user']['phone'];
      role_id = json['user']['role_id'];
    }
  }
  updateUserData(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
  }
}

class AuthenticationData {
  String name;
  String email;
  String phone;
  String password;
  AuthenticationData({this.email, this.name, this.password, this.phone});
  getSignUpBody() {
    return {
      "name": name,
      "email": email,
      "password": password,
    };
  }

  getLoginBody() {
    return {
      "email": email,
      "password": password,
    };
  }

  getUpdateBody() {
    return {
      "name": name,
      "phone": phone,
    };
  }
}

class AuthenticationResult {
  bool success;
  String message;
  UserData data;
  AuthenticationResult({this.success, this.message, this.data});
  successMessage(context) {
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        title: "تسجيل الدخول",
        desc: "تم تسجيل الدخول بنجاح",
        btnOkText: "حسنا",
        btnOkColor: Colors.red,
        btnOkOnPress: () {},
        onDissmissCallback: (type) {})
      ..show();
  }

  failMessage(context, message) {
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.ERROR,
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: true,
        title: "تسجيل الدخول",
        desc: message,
        btnOkText: "حسنا",
        btnOkColor: Colors.red,
        btnOkOnPress: () {},
        onDissmissCallback: (type) {})
      ..show();
  }

  successUpdateMessage(context) {
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        title: "تعديل البانات",
        desc: "تم تعديل البيانات بنجاح",
        btnOkText: "حسنا",
        btnOkColor: Colors.red,
        btnOkOnPress: () {},
        onDissmissCallback: (type) {})
      ..show();
  }

  failUpdateMessage(context) {
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.ERROR,
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: true,
        title: "تعديل البانات",
        desc: "هناك خطا فى تعديل البانات",
        btnOkText: "حسنا",
        btnOkColor: Colors.red,
        btnOkOnPress: () {},
        onDissmissCallback: (type) {})
      ..show();
  }
}
