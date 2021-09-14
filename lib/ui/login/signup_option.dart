import 'package:flutter/material.dart';
import 'package:raid/constants.dart';

class SignUpOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      //  crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "أو",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Container(
          height: 50,
          width: size.width * .75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "تسجيل مستخدم",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                //  color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
