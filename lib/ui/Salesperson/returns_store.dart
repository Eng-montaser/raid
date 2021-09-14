import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raid/constants.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/widget/background.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:raid/widget/rounded_input_field.dart';

class ReturnStore extends StatefulWidget {
  ReturnStore({Key key}) : super(key: key);

  @override
  _Summary createState() => _Summary();
}

class _Summary extends State<ReturnStore> {
  var productData = [
    {
      'title': "Title1",
      'desc': "assets/images/item_XL_101.png",
      'qty': 1,
      'unit':2,
      'total':3
    },
    {
      'title': "Title2",
      'desc': "assets hghj kjahsjdgboj ihdkjhdj khjkhjhm ",
      'qty': 1,
      'unit':4,
      'total':5
    },
    {
      'title': "Title3",
      'desc': "assets hghj kjahsjdgboj ihdkjhdj khjkhjhm ",
      'qty': 1,
      'unit':2,
      'total':3
    },
    {
      'title': "Title4",
      'desc': "assets hghj kjahsjdgboj ihdkjhdj khjkhjhm ",
      'qty': 2,
      'unit':2,
      'total':4
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
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding:  EdgeInsets.symmetric(vertical:ScreenUtil().setHeight(15) ,
                    horizontal: ScreenUtil().setWidth(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_sharp ,
                        color: Colors.white,
                        size: ScreenUtil().setSp(25),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Image.asset(
                "assets/images/white.png",
                fit: BoxFit.contain,
                height: size.height * .11,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(35),
              ),
              Text(
                'store'.tr(),
                textScaleFactor: 1.1,
                style: FCITextStyle(color: primaryColor).bold18(),
              ),
              CustomTextInput(
                hintText: 'store.name'.tr(),
              ),

              titleScreen(),
              SizedBox(height: ScreenUtil().setWidth(30),),

              Row(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(60)),
                    child: Text('stores'.tr(),style: FCITextStyle().bold20(),),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(itemBuilder: (Context,index){
                  return headerRow('10:00', '88');

                },
                  itemCount: 3,
                  shrinkWrap: true,
                ),
              ),

            ],
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }


 Widget headerRow(String title, String text) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time_sharp,size: ScreenUtil().setSp(20),color: Colors.grey),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                    child: Text('${title} ',style: FCITextStyle(color: Colors.black).bold16(),),
                  ),
                  Icon(FontAwesomeIcons.arrowsAltH,size:ScreenUtil().setSp(20),color: Colors.grey,),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                    child: Text('10:30',style: FCITextStyle(color: Colors.black).bold16(),),
                  ),

                ],
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                child: Text(text,style: FCITextStyle(color: Colors.black).bold16()),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined,color: Colors.grey),
                  Text('Loerm ',style: FCITextStyle(color: Colors.black).bold16(),),


                ],
              ),
              Container(
                  padding:  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(12)),

                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5),

                  ),
                  child: Text('select'.tr(),style: FCITextStyle(color: Colors.white).bold16(),)),
            ],
          ),
          Divider(
            thickness: 2,
          )
        ],
      ),
    );
 }
  Widget titleScreen(){


    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(50),
          vertical: ScreenUtil().setHeight(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: Icon(Icons.location_pin,
                    color: Colors.red,size: ScreenUtil().setSp(30),),
                  horizontalTitleGap: 20,
                  title: Text("from".tr()),
                  subtitle: Text('..................'),
                ),



                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(75)),
                  child: Divider(
                    height: 3,thickness: 3,),
                ),
                ListTile(
                  leading: Icon(Icons.location_pin,
                    color: Colors.orangeAccent,size: ScreenUtil().setSp(30),),
                  horizontalTitleGap: 20,
                  title: Text('to'.tr()),
                  subtitle: Text('...................'),
                ),

              ],
            ),
          ),

        ],
      ),
    );

  }
}
