import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/provider/CasheManger.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/provider/PostProvider.dart';
import 'package:raid/ui/onboard.dart';
import 'package:raid/widget/button_animated.dart';

class CustomerProfile extends StatefulWidget {
  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile>  with TickerProviderStateMixin {
  AnimationController _logOutButtonController;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<GetProvider>(context, listen: false).getCustomerProfile();
    });
    _logOutButtonController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<GetProvider>(context, listen: false);
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: ScreenUtil().setHeight(100),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          "assets/images/logo_black.png",
          height: ScreenUtil().setHeight(60),
          width: ScreenUtil().setWidth(60),
          fit: BoxFit.contain,
        ),
        leading: Padding(
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(35),
              horizontal: ScreenUtil().setWidth(10)),
          child: Container(
            height: ScreenUtil().setHeight(5),
            padding: EdgeInsets.all(4),
            //margin: EdgeInsets.all( ),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(7)),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_ios_sharp,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
          vertical: ScreenUtil().setHeight(10),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Stack(
                children: [
                  ///-------------------- Edit Profile Button
                  Container(
                    alignment: Alignment.bottomLeft,
                    height: ScreenUtil().setHeight(180),
                    decoration: BoxDecoration(
                      color: PrimaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 2.5,
                          blurRadius: 5.5,
                        )
                      ],
                    ),
                    child: InkWell(
                      onTap: () async {

                      },
                      child: Container(
                        height: ScreenUtil().setHeight(50),
                        width: ScreenUtil().setWidth(90),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 2.5,
                              blurRadius: 5.5,
                            )
                          ],
                        ),
                        child: Text(
                          "Edit",
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                //  height: size.height/4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(10)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(10),
                                    vertical: ScreenUtil().setHeight(10)),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                  color: Colors.grey[100],
                                ),
                                child: Image.asset("assets/images/bell.png"),
                              ),
                              Text(
                                "notification",
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StaggerAnimation(
                            titleButton: 'تسجيل خروج',
                            buttonController: _logOutButtonController.view,
                            onTap: () async {
                             CacheManger().removeData(CacheType.userData);
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => OnBoard()));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 15.0,
                            ),
                            child: Text(
                              'V.0.0.1',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),



            ]),
      ),
    );
  }
}
