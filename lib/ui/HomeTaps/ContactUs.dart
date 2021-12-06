import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/provider/PostProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController message = new TextEditingController();
  String _platformVersion = 'Unknown';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var getProvider = Provider.of<GetProvider>(context, listen: false);
    var postProvider = Provider.of<PostProvider>(context, listen: false);
    return Container(
      child: getProvider.busy
          ? loading()
          : Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: size.height - ScreenUtil().setHeight(240),
                  width: size.width,
                  child: Image.asset(
                    "assets/images/Path.png",
                    fit: BoxFit.fill,
                  ),
                  margin: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(20),
                      vertical: ScreenUtil().setHeight(5)),
                  padding: EdgeInsets.symmetric(
//                horizontal: ScreenUtil().setWidth(20),
                      vertical: ScreenUtil().setHeight(5)),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: ScreenUtil().setHeight(120),
                          width: ScreenUtil().setWidth(200),
                          child: Image.asset(
                            kLogoBlack,
                            fit: BoxFit.fill,
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(20),
                              vertical: ScreenUtil().setHeight(5)),
                          padding: EdgeInsets.symmetric(
//                horizontal: ScreenUtil().setWidth(20),
                              vertical: ScreenUtil().setHeight(5)),
                        ),
                        Container(
                          width: size.width * .8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setHeight(5)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: AccentColor,
                                      size: ScreenUtil().setWidth(25),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(10),
                                    ),
                                    Container(
                                      width: size.width * 2 / 3 -
                                          ScreenUtil().setWidth(35),
                                      child: FittedBox(
                                          fit: BoxFit.fitWidth,
//
                                          child: Text(
                                            getProvider.settingData?.address,
                                            style: FCITextStyle().normal18(),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _launchInWebViewWithJavaScript(
                                      getProvider.settingData.facebook);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(5)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.facebook,
                                        color: AccentColor,
                                        size: ScreenUtil().setWidth(25),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(10),
                                      ),
                                      Container(
                                        width: size.width * .70,
                                        child: FittedBox(
                                          child: Text(
                                            getProvider.settingData.facebook,
                                            //  maxLines: 2,
                                            style: FCITextStyle().normal16(),
                                            textDirection: TextDirection.ltr,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  FlutterOpenWhatsapp.sendSingleMessage(
                                      '+2${getProvider.settingData.whatsapp}',
                                      "السلام عليكم");
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(5)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.whatsapp,
                                        color: AccentColor,
                                        size: ScreenUtil().setWidth(25),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(10),
                                      ),
                                      Text(
                                        getProvider.settingData.whatsapp,
                                        style: FCITextStyle().normal18(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _launchInWebViewWithJavaScript(
                                      getProvider.settingData.telegram);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(5)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.telegram,
                                        color: AccentColor,
                                        size: ScreenUtil().setWidth(25),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(10),
                                      ),
                                      Text(
                                        getProvider.settingData.telegram,
                                        style: FCITextStyle().normal18(),
                                        textDirection: TextDirection.ltr,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _makePhoneCall(
                                      'tel:+2${getProvider.settingData.phone}');
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(5)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: AccentColor,
                                        size: ScreenUtil().setWidth(25),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(10),
                                      ),
                                      Text(
                                        getProvider.settingData.phone,
                                        style: FCITextStyle().normal18(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(15),
                              horizontal: ScreenUtil().setWidth(15)),
                          width: MediaQuery.of(context).size.width * 0.80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "للشكاوى والاقتراحات",
                                style:
                                    FCITextStyle(color: AccentColor).normal18(),
                              ),
                              TextField(
                                controller: message,
//                onChanged: userTyped,
                                keyboardType: TextInputType.text,

                                onSubmitted: (value) {},
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintStyle: FCITextStyle(color: AccentColor)
                                      .normal18(),
                                  border: InputBorder.none,
                                  hintText:
                                      '.................................................................................................................................................................................................................................................................................................................................................................................',
                                ),
                                minLines: 4,
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(5),
                        ),
                        !postProvider.busy
                            ? InkWell(
                                onTap: () {
                                  if (message.text.isNotEmpty) sendComplaint();
                                },
                                child: Container(
                                    height: ScreenUtil().setHeight(30),
                                    width: ScreenUtil().setWidth(60),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: PrimaryColor, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'ارسال',
                                      style: FCITextStyle(color: Colors.red)
                                          .bold14(),
                                    )),
                              )
                            : loadingTow(40)
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  ///---------------------------
  ///      Send  Complaint     -
  /// --------------------------
  sendComplaint() async {
    await Provider.of<PostProvider>(context, listen: false)
        .sendComplaints(message.text)
        .then((response) {
      if (response) {
        AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            dismissOnBackKeyPress: true,
            dismissOnTouchOutside: true,
            title: "الشكاوى والاقتراحات",
            desc: "تم الارسال بنجاح",
//                        body: Column(
//                          crossAxisAlignment:
//                          CrossAxisAlignment.center,
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: [
//                            Text(
//                              "send INTEGRATION",
//                              style: TextStyle(
//                                  fontSize: 18,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            Text("INTEGRATION Successful",
//                              style: TextStyle(
//                                  fontSize: 16,
//                                  fontWeight: FontWeight.normal,
//                                  color: Colors.grey),
//                            ),
//                            Text(
//                              "order.successful.desc".tr(),
//                              style: TextStyle(
//                                  fontSize: 16,
//                                  fontWeight: FontWeight.normal,
//                                  color: Colors.black),
//                              textAlign: TextAlign.center,
//                            )
//                          ],
//                        ),
            btnOkText: "حسنا",
            btnOkColor: Colors.red,
            btnOkOnPress: () {},
            onDissmissCallback: (type) {})
          ..show();
        message.clear();
      }
    });
  }
}
