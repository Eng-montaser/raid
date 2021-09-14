
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raid/style/FCITextStyles.dart';



class RoundedButton extends StatelessWidget {
  final Function onTap;
  final Color color;
  final String text;
  const RoundedButton({
    Key key,
    this.onTap, this.color, this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Container(
       // width: double.infinity,

        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(20),
            vertical: ScreenUtil().setHeight(5)),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(7)),
        child: Text(text,style: FCITextStyle(color: Colors.white).normal16(),),
      ),
    );
  }
}
