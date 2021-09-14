import 'package:easy_localization/easy_localization.dart' as T;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/provider/AuthProvider.dart';
import 'package:raid/provider/CasheManger.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/ui/Profile/edit_profile.dart';
import '../onboard.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<AuthProvider>(context, listen: false);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.white),
      child: Scaffold(
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
                  color: Colors.grey[200], borderRadius: BorderRadius.circular(7)),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop()
                ,
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfile()));
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
                            "Edit".tr(),
                            style: FCITextStyle(color: Colors.red).normal16()
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                    ),

                    ///-------------------------------------end
                    ///-------------------- Edit Profile Button
                    Container(
                        alignment: Alignment.center,
                        //  height: ScreenUtil().setHeight(300),
                        padding: EdgeInsets.symmetric(
                          // horizontal: ScreenUtil().setWidth(60),
                          vertical: ScreenUtil().setHeight(15),
                        ),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${provider.userData!=null?
                              provider.userData.name!=null?provider.userData.name:''
                                  :''}',
                              style: FCITextStyle(color: Colors.white).bold22(),
                            ),
                            Text('${provider.userData!=null?
                            provider.userData.phone!=null?provider.userData.phone:'':''}',
                              style: FCITextStyle(color: Colors.white).bold22()),
                            SizedBox(
                              height: ScreenUtil().setHeight(10),
                            ),
                            CircleAvatar(
                              radius: 70,
                              child: Image.asset('assets/images/man-300x300.png',
                                height: ScreenUtil().setHeight(150),
                                width: ScreenUtil().setWidth(150),
                                fit: BoxFit.contain,),
                              backgroundColor: Colors.white,
                            ),
                          ],
                        ))
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(10)),
                  child: InkWell(
                    onTap: () async {
                      CacheManger().removeData(CacheType.userData);
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          OnBoard()), (Route<dynamic> route) => false);
                    },
                    child: Row(
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
                          child: Icon(
                            Icons.logout,
                            color: Colors.black54,
                            size: ScreenUtil().setSp(30),
                          ),
                        ),
                        Text(
                          'تسجيل خروج',
                          style: FCITextStyle().bold16(),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }


}
