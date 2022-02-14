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
                    onTap: () async {
                      /* try {
                        SimData simData = await SimDataPlugin.getSimData();
                        for (var s in simData.cards) {
                          print('Serial numbers: ${s.displayName}');
                        }
                      } on PlatformException catch (e) {
                        debugPrint(
                            "error! code: ${e.code} - message: ${e.message}");
                      }
                      if (await Permission.phone.request().isGranted) {
                        int subscriptionId = 1; // sim card subscription ID
                        String code = "*947#"; // ussd code payload
                        try {
                          String ussdResponseMessage =
                              await UssdService.makeRequest(
                            subscriptionId,
                            code,
                            Duration(
                                seconds:
                                    5), // timeout (optional) - default is 10 seconds
                          );
                          print("succes! message: $ussdResponseMessage");
                        } catch (e) {
                          print(
                              "error! code: ${e.code} - message: ${e.message}");
                        }
                      } else {
                        print("Denieds: ");

                        // We didn't ask for permission yet or the permission has been denied before but not permanently.
                      }

                      if (await canLaunch("tel:" +
                          Uri.encodeComponent(removeAllHtmlTags('*123#')))) {
                        await launch("tel:" +
                            Uri.encodeComponent(removeAllHtmlTags('*123#')));
                      }*/
                      authProvider.setUserDataFromCache().then((response) {
                        if (response != null)
                          Navigator.of(context).pushNamed('ourservice');
                        else
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthPage(
                                        userType: UserType.customer,
                                      )));
                      });
                    },
                    color: Color(0xffff0d0d),
                    text: ' الدخول كعميل',
                  ),
                  RoundedButton(
                    onTap: () {
                      authProvider.setUserDataFromCache().then((response) {
                        if (response != null) {
                          if (response.role_id < 5)
                            Navigator.of(context).pushNamed('sales_person');
                          else
                            Navigator.of(context).pushNamed('ourservice');
                        } else
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
