import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/UserData.dart';
import 'package:raid/provider/AuthProvider.dart';
import 'package:raid/widget/button_animated.dart';
import 'package:raid/widget/rounded_input_field.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with TickerProviderStateMixin {
  bool isLoading;
  AnimationController _loginButtonController;
  TextEditingController _nameTextEditingController;
  TextEditingController _phoneTextEditingController;
  File imageData;
  @override
  void initState() {
    isLoading = false;
    _loginButtonController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    setData();
  }

  setData() async {
    var provider = Provider.of<AuthProvider>(context, listen: false);
    _nameTextEditingController =
        new TextEditingController(text: provider.userData.name);
    _phoneTextEditingController =
        new TextEditingController(text: provider.userData.phone);
    //print(provider.userData.token);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final _scafoldKey = GlobalKey<ScaffoldState>();

  String phoneFormat(String phone) {
    String res = '';
    if (phone != null) if (phone.length > 8) {
      String first = phone.substring(0, 3);
      String last = phone.substring(6);
      String middle = phone.substring(3, 6);
      res = last + ' ' + middle + ' ' + first;
    }
    return res;
  }

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _loginButtonController.forward();
    } on TickerCanceled {
      // printLog('[_playAnimation] error');
    }
  }

  Future<Null> _stopAnimation() async {
    try {
      await _loginButtonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {
      //  printLog('[_stopAnimation] error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context);
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.white),
      child: SafeArea(
        child: Scaffold(
          key: _scafoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: ScreenUtil().setHeight(100),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(35),
                  horizontal: ScreenUtil().setWidth(10)),
              child: Container(
                height: ScreenUtil().setHeight(5),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(4),
                    vertical: ScreenUtil().setHeight(4)),
                //margin: EdgeInsets.all( ),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(7)),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back_ios_sharp,
                    color: Colors.black,
                    size: ScreenUtil().setSp(20),
                  ),
                ),
              ),
            ),
            title: Image.asset(
              "assets/images/black.png",
              height: ScreenUtil().setHeight(150),
              width: ScreenUtil().setWidth(150),
              fit: BoxFit.contain,
            ),
          ),
          body: SingleChildScrollView(
              // color: kPrimaryColor,
              child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height -
                  ScreenUtil().setHeight(120),
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircleAvatar(
                    radius: 70,
                    child: Image.asset(
                      'assets/images/man-300x300.png',
                      height: ScreenUtil().setHeight(150),
                      width: ScreenUtil().setWidth(150),
                      fit: BoxFit.contain,
                    ),
                    backgroundColor: Colors.white,
                  ),
                  CustomTextInput(
                    hintText: 'الاسم',
                    leading: Icons.person,
                    obscure: false,
                    controller: _nameTextEditingController,
                  ),
                  CustomTextInput(
                    hintText: 'رقم الجوال',
                    leading: Icons.phone_android,
                    obscure: false,
                    controller: _phoneTextEditingController,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(50),
                  ),
                  StaggerAnimation(
                    titleButton: "تعديل",
                    foreground: Colors.white,
                    background: primaryColor,
                    buttonController: _loginButtonController.view,
                    onTap: () async {
                      if (_nameTextEditingController.text.isNotEmpty &&
                          _phoneTextEditingController.text.isNotEmpty) {
                        await _playAnimation();
                        AuthenticationData authenticationData =
                            new AuthenticationData(
                                name: _nameTextEditingController.text,
                                phone: _phoneTextEditingController.text);
                        await provider
                            .updateUserData(authenticationData)
                            .then((response) {
                          if (response.success) {
                            response.successUpdateMessage(context);
//                            Timer(Duration(seconds: 3), () {
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) => Profile()));
//                            });
                          } else {
                            response.failUpdateMessage(context);
                          }
                        });
                      }
                      await _stopAnimation();
                    },
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
