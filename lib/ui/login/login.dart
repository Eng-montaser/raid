import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/UserData.dart';
import 'package:raid/provider/AuthProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/ui/Salesperson/sales_person.dart';
import 'package:raid/widget/button_animated.dart';
import 'package:raid/widget/rounded_input_field.dart';

import '../our_service.dart';

class Login extends StatefulWidget {
  final GlobalKey<ScaffoldState> loginScaffoldKey;
  final UserType userType;
  final bool isSalesPerson;
  Login({this.loginScaffoldKey, this.userType, this.isSalesPerson});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = new TextEditingController(text: '');
  TextEditingController _passwordController =
      new TextEditingController(text: '');
  int _loginValidate;
  var focusNode = FocusNode();
  @override
  void dispose() {
    _loginButtonController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          "assets/images/logo_black.png",
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * .1,
        ),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        Text(
          'تسجيل الدخول',
          style: FCITextStyle(color: primaryColor.withOpacity(.8)).bold18(),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(16),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xfff1f1f1), width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
          width: MediaQuery.of(context).size.width * 0.70,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/egy.png",
                fit: BoxFit.contain,
                height: ScreenUtil().setHeight(30),
                width: ScreenUtil().setWidth(50),
              ),
              Text(
                'مصر   ',
                style: FCITextStyle().bold16(),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.40,
                child: TextField(
                  maxLength: 14,
                  //  leading: Icons.phone_enabled_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.phone,
                  focusNode: _loginValidate == 1 || _loginValidate == 2
                      ? focusNode
                      : null,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'رقم التليفون',
                      counterText: ""),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
        CustomTextInput(
          hintText: 'كلمة الســـر',
          leading: Icons.lock_outline,
          obscure: true,
          controller: _passwordController,
          focusNode: _loginValidate == 3 ? focusNode : null,
        ),
        SizedBox(
          height: ScreenUtil().setHeight(24),
        ),
        StaggerAnimation(
          titleButton: "دخول",
          foreground: Colors.white,
          background: primaryColor,
          buttonController: _loginButtonController.view,
          onTap: () async {
            ///--------------
//            Navigator.of(context).pushNamed('ourservice');
            ///--------------
            setState(() {
              _loginValidate = loginValidate();
            });
            if (_loginValidate == 0) {
              await _playAnimation();
              AuthenticationData authenticationData = new AuthenticationData(
                  email: _emailController.text,
                  password: _passwordController.text);
              await Provider.of<AuthProvider>(context, listen: false)
                  .login(authenticationData)
                  .then((value) {
                if (value.success) {
                  if (widget.userType == UserType.salesPerson &&
                      value.data.role_id < 5)
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SalesPerson()),
                        (Route<dynamic> route) => false);
                  else
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => OurService()),
                        (Route<dynamic> route) => false);
                } else
                  value.failMessage(context, value.message);
              });
            }
            await _stopAnimation();
          },
        ),
        SizedBox(
          height: ScreenUtil().setHeight(16),
        ),
      ],
    );
  }

  int loginValidate() {
    if (_emailController.text.isEmpty) {
      focusNode = new FocusNode();
      focusNode.requestFocus();
      _showScaffold('برجاء ادخال بيانات تسجيل الدخول');
      return 1;
    }
    if (_emailController.text.length < 11) {
      focusNode = new FocusNode();
      focusNode.requestFocus();
      _showScaffold('برجاء ادخال رقم تليفون صحيح');
      return 2;
    }
    if (_passwordController.text.isEmpty) {
      focusNode = new FocusNode();
      focusNode.requestFocus();
      _showScaffold('برجاء ادخال بيانات تسجيل الدخول');
      return 3;
    }
    return 0;
  }

  void _showScaffold(String message) {
    widget.loginScaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.grey,
      duration: Duration(milliseconds: 3000),
      content: Text(message,
          textAlign: TextAlign.center, style: FCITextStyle().normal16()),
    ));
  }
}
