import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final IconData leading;
  final Function userTyped;
  final bool obscure;
  final TextInputType keyboard;
  final TextEditingController controller;
  final Color color;
  final bool enabled;
  final Widget suffixicon;
  final FocusNode focusNode;

  CustomTextInput(
      {this.hintText,
      this.leading,
      this.userTyped,
      this.obscure = false,
      this.keyboard = TextInputType.text,
      this.color,
      this.suffixicon = null,
      this.controller = null,
      this.enabled = true,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xfff1f1f1), width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
      width: MediaQuery.of(context).size.width * 0.70,
      child: TextField(
        onChanged: userTyped,
        keyboardType: keyboard,
        controller: controller,
        enabled: enabled,
        focusNode: focusNode,
        onSubmitted: (value) {},
        autofocus: false,
        obscureText: obscure ? true : false,
        decoration: InputDecoration(
          suffixIcon: suffixicon,
          icon: Icon(
            leading,
            color: color,
          ),
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}
