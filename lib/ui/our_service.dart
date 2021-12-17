import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/SettingData.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/ui/Home.dart';
import 'package:raid/ui/Profile/Profile.dart';
import 'package:raid/widget/background.dart';

class OurService extends StatefulWidget {
  OurService({Key key}) : super(key: key);

  @override
  _OurService createState() => _OurService();
}

class _OurService extends State<OurService> {
  SettingData _settingData;
  bool done = false;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      done = true;
    });
//    WidgetsBinding.instance.addPostFrameCallback((_) async {
//      _settingData =
//      await Provider.of<GetProvider>(context, listen: false)
//          .getSetting();
//    });
  }

  var productData = [
    {
      'category': "product",
      'image': "assets/images/item_XL_101.png",
      'id': 0,
    },
    {
      'category': "matches",
      'image': "assets/images/trade_in.png",
      'id': 1,
    },
    {
      'category': "brand",
      'image': "assets/images/Top_10.png",
      'id': 2,
    },
    {
      'category': "offers",
      'image': "assets/images/cam.png",
      'id': 3,
    },
    {
      'category': "myservices",
      'image': "assets/images/mobiles.jpeg",
      'id': 4,
    },
    {
      'category': "videos",
      'image': "assets/images/mauvio-100858234-orig-1.png",
      'id': 5,
    },
    {
      'category': "codes",
      'image': "assets/images/transfer.png",
      'id': 6,
    },
    {
      'category': "contactus",
      'image': "assets/images/portrait-call-center-woman_23-2148094920.png",
      'id': 7,
    },
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        show: false,
        child: Center(
          child: Column(
            //  mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(25),
                    vertical: ScreenUtil().setHeight(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Profile()));
                      },
                      child: CircleAvatar(
                        child: Image.asset('assets/images/man-300x300.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Text(
                'ourservice'.tr(),
                textScaleFactor: 2,
                style: FCITextStyle(color: Colors.white).bold25(),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Expanded(
                child: Container(
                  color: done ? Colors.grey : Colors.transparent,
                  margin: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(30)),
                  child: AnimationLimiter(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      addRepaintBoundaries: false,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: .3,
                      //physics:BouncingScrollPhysics(),

                      children: List.generate(productData.length, (index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          columnCount: 2,
                          duration: const Duration(milliseconds: 500),
                          child: ScaleAnimation(
                            scale: 0.5,
                            child: FadeInAnimation(
                              delay: const Duration(milliseconds: 200),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home(
                                                  initialIndex:
                                                      productData[index]['id'],
                                                )));
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: gettemp(productData[index]),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical:
                                                  ScreenUtil().setHeight(5)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setWidth(20),
                                              vertical:
                                                  ScreenUtil().setHeight(5)),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: primaryColor,
                                                  width: .5),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Text(
                                            '${productData[index]['category'].toString().tr()}',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(13),
                                                color: primaryColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }

  Widget gettemp(var data) {
    return Stack(
      children: <Widget>[
        //image code
        Center(
          child: Image(
            image: AssetImage(
              data['image'],
            ),
            fit: BoxFit.fill,
            // colorBlendMode: BlendMode.src,
            width: ScreenUtil().setWidth(150),
            height: ScreenUtil().setWidth(150),
          ),
        ),
        //top grey shadow

        //bottom grey shadow
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
            width: ScreenUtil().setWidth(150),
            height: ScreenUtil().setWidth(150),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: new LinearGradient(
                end: const Alignment(0, -.3),
                begin: const Alignment(0, 0),
                colors: <Color>[
                  const Color(0x50000000),
                  Colors.black12.withOpacity(0.0)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getImage(var data) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.white,
                  Color(0xff828282),
                  Color(0xff828282),
                ],
                stops: [
                  0.4,
                  0.8,
                  1.0
                ]),
            //  backgroundBlendMode: BlendMode.dstATop,

            borderRadius: BorderRadius.circular(10),

//
          ),
          child: Image.asset(
            data['image'],
            fit: BoxFit.fill,
            colorBlendMode: BlendMode.src,
            width: ScreenUtil().setWidth(150),
            height: ScreenUtil().setWidth(150),
          ),
        ),
        Container(
          width: ScreenUtil().setWidth(150),
          height: ScreenUtil().setWidth(150),
          decoration: BoxDecoration(),
        )
      ],
    );
  }
}
