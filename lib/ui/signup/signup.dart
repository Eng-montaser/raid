import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/UserData.dart';
import 'package:raid/provider/AuthProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/ui/auth_page.dart';
import 'package:raid/widget/button_animated.dart';
import 'package:raid/widget/rounded_input_field.dart';

class SignUp extends StatefulWidget {
  final GlobalKey<ScaffoldState> registerScaffoldKey;
  final UserType userType;
  final bool isSalesPerson;
  SignUp({this.registerScaffoldKey, this.userType, this.isSalesPerson});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _usernameController =
      new TextEditingController(text: '');
  TextEditingController _emailController = new TextEditingController(text: '');
  @override
  TextEditingController _passwordController =
      new TextEditingController(text: '');
  @override
  TextEditingController _cpasswordController =
      new TextEditingController(text: '');
  int _registerValidate;
  var focusNode = FocusNode();
  @override
  void dispose() {
    _loginButtonController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cpasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _loginButtonController.forward();
    } on TickerCanceled {}
  }

  Future<Null> _stopAnimation() async {
    try {
      await _loginButtonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          "assets/images/white.png",
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * .1,
        ),
        Text(
          "تسجيل كمستخدم",
          style: FCITextStyle(color: Colors.white).bold18(),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(0),
        ),
        CustomTextInput(
          hintText: 'اسم المستخدم',
          leading: Icons.person_outline,
          controller: _usernameController,
          focusNode: _registerValidate == 1 ? focusNode : null,
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
                  focusNode: _registerValidate == 2 || _registerValidate == 3
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
        /*CustomTextInput(
          hintText: 'الايميل',
          leading: Icons.email,
          controller: _emailController,
          focusNode: _registerValidate == 2 || _registerValidate == 3
              ? focusNode
              : null,
        ),*/
        CustomTextInput(
          hintText: 'كلمة السر',
          leading: Icons.lock_outline,
          obscure: true,
          controller: _passwordController,
          focusNode: _registerValidate == 4 ? focusNode : null,
        ),
        CustomTextInput(
          hintText: 'تأكيد كلمة السر',
          leading: Icons.lock_outline,
          obscure: true,
          controller: _cpasswordController,
          focusNode: _registerValidate == 5 || _registerValidate == 6
              ? focusNode
              : null,
        ),
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
        StaggerAnimation(
          titleButton: 'تسجيل',
          foreground: Colors.black,
          background: Colors.white,
          buttonController: _loginButtonController.view,
          onTap: () async {
            setState(() {
              _registerValidate = registerValidate();
            });
            if (_registerValidate == 0) {
              await _playAnimation();
              AuthenticationData authenticationData = new AuthenticationData(
                  email: _emailController.text,
                  password: _passwordController.text,
                  name: _usernameController.text);
              await Provider.of<AuthProvider>(context, listen: false)
                  .register(authenticationData)
                  .then((value) {
                if (value.success) {
                  AwesomeDialog(
                      context: context,
                      animType: AnimType.LEFTSLIDE,
                      headerAnimationLoop: false,
                      dialogType: DialogType.SUCCES,
                      dismissOnBackKeyPress: false,
                      dismissOnTouchOutside: false,
                      title: "تسجيل مستخدم",
                      desc: value.message,
                      btnOkText: "حسنا",
                      btnOkColor: Colors.red,
                      btnOkOnPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AuthPage(userType: widget.userType)));
                      },
                      onDissmissCallback: (type) {})
                    ..show();
                  /*if (widget.userType == UserType.salesPerson)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AuthPage(userType: UserType.salesPerson)));
//                    Navigator.of(context).pushAndRemoveUntil(
//                        MaterialPageRoute(builder: (context) => SalesPerson()),
//                        (Route<dynamic> route) => false);
                  else
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => OurService()),
                        (Route<dynamic> route) => false);*/
                } else
                  value.failMessage(context, value.message);
              });
            }
            await _stopAnimation();
          },
        ),
        SizedBox(
          height: ScreenUtil().setHeight(24),
        ),
      ],
    );
  }

  int registerValidate() {
    if (_usernameController.text.isEmpty) {
      focusNode = new FocusNode();
      focusNode.requestFocus();
      _showScaffold('برجاء ادخال بيانات تسجيل الدخول');
      return 1;
    }
    if (_emailController.text.isEmpty) {
      focusNode = new FocusNode();
      focusNode.requestFocus();
      _showScaffold('برجاء ادخال بيانات تسجيل الدخول');
      return 2;
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
      return 4;
    }
    if (_cpasswordController.text.isEmpty) {
      focusNode = new FocusNode();
      focusNode.requestFocus();
      _showScaffold('برجاء ادخال بيانات تسجيل الدخول');
      return 5;
    }
    if (_passwordController.text != _cpasswordController.text) {
      focusNode = new FocusNode();
      focusNode.requestFocus();
      _showScaffold('كلمة المرور غير متطابقة');
      return 6;
    }
    return 0;
  }

  void _showScaffold(String message) {
    widget.registerScaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.grey,
      duration: Duration(milliseconds: 3000),
      content: Text(message,
          textAlign: TextAlign.center, style: FCITextStyle().normal16()),
    ));
  }
}
