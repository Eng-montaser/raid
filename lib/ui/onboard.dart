import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/provider/AuthProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/ui/auth_page.dart';
import 'package:raid/widget/background.dart';
import 'package:raid/widget/rounded_button.dart';

class OnBoard extends StatefulWidget {
  OnBoard({Key key}) : super(key: key);

  @override
  _OnBoard createState() => _OnBoard();
}

class _OnBoard extends State<OnBoard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: Background(
        child: Center(
          child: Column(
            //  mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: ScreenUtil().setHeight(60),
              ),
              Image.asset(
                "assets/images/white.png",
                fit: BoxFit.contain,
                height: size.height * .11,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(75),
              ),
              Text(
                'مرحبـــــا',
                textScaleFactor: 1.5,
                style: FCITextStyle(color: Colors.black38).bold20(),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),
              RotationAnimatedWidget.tween(
                enabled:
                    true, //update this boolean to forward/reverse the animation
                rotationDisabled: Rotation.deg(z: 180),
                rotationEnabled: Rotation.deg(z: 360),
                child: Image.asset(
                  "assets/images/Group_1.png",
                  fit: BoxFit.contain,
                  height: size.height * .4,
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(30),
              ),
              Row(
                //mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RoundedButton(
                    onTap: () {
                      Navigator.of(context).pushNamed('ourservice');
                      /*  authProvider.setUserDataFromCache().then((response) {
                        if(response)
                          Navigator.of(context).pushNamed('ourservice');
                        else
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AuthPage(userType: UserType.customer,)));
                      });*/
                    },
                    color: Color(0xffff0d0d),
                    text: ' الدخول كعميل',
                  ),
                  RoundedButton(
                    onTap: () {
                      authProvider.setUserDataFromCache().then((response) {
                        if (response)
                          Navigator.of(context).pushNamed('sales_person');
                        else
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthPage(
                                      userType: UserType.salesPerson)));
                      });
                    },
                    color: Color(0xff788390),
                    text: 'الدخول كمندوب',
                  ),
                ],
              )
            ],
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }
}
