import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/SercicesData.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/widget/CustomWidgets.dart';

class ServiceCard extends StatefulWidget {
  final ServicesData servicesData;

  const ServiceCard({Key key, this.servicesData}) : super(key: key);
  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
              height: size.height / 7,
              width: size.width,
              decoration: BoxDecoration(
                  color: PrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CustomWidgets().CustomImage(
                  height: size.height / 7,
                  width: size.width,
                  networkImageUrl: widget.servicesData.image,
                  assetsImagePath: 'assets/images/place.png',
                ),
              )),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
        Text(
          widget.servicesData.description,
          style: FCITextStyle(color: AccentColor).normal10(),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
        InkWell(
          onTap: () {},
          child: Container(
              height: ScreenUtil().setHeight(24),
              width: ScreenUtil().setWidth(60),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: PrimaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              alignment: Alignment.center,
              child: Text(
                'للمزيد',
                style: FCITextStyle(color: Colors.red).normal14(),
              )),
        )
      ],
    );
  }
}
