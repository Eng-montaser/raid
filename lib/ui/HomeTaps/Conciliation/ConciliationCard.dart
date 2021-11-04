import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/ConciliationData.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/widget/CustomWidgets.dart';

class ConciliationCard extends StatefulWidget {
  final ConciliationData conciliationData;
  final Function moreChange;
  final bool isOdd;
  const ConciliationCard(
      {Key key, this.conciliationData, this.moreChange, this.isOdd})
      : super(key: key);
  @override
  _ConciliationCardState createState() =>
      _ConciliationCardState(this.conciliationData);
}

class _ConciliationCardState extends State<ConciliationCard> {
  ConciliationData conciliationData;
  _ConciliationCardState(this.conciliationData);
  String data = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    conciliationData.integrations.forEach((element) {
      if (element != '') data = data + ' ' + element.tags;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        InkWell(
          onTap: () {
            widget.moreChange(true);
          },
          child: Container(
              height: size.height / 7,
              width: size.width,
              decoration: BoxDecoration(
                  color: PrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                textDirection:
                    widget.isOdd ? TextDirection.ltr : TextDirection.rtl,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(10),
                        horizontal: ScreenUtil().setWidth(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomWidgets().CustomImage(
                          width: ScreenUtil().setWidth(120),
                          height: ScreenUtil().setHeight(120),
                          assetsImagePath: 'assets/images/place.png',
                          networkImageUrl: conciliationData.image,
                        )
                      ],
                    ),
                  ),
                  FittedBox(
                    child: Container(
                        alignment: Alignment.center,
                        width: ScreenUtil().setWidth(150),
                        child: Text(
                          conciliationData.name,
                          textAlign: TextAlign.center,
                          style: FCITextStyle(color: Colors.white).bold30(),
                        )),
                  )
                ],
              )),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        /* if (data.isNotEmpty)
          Text(
            '${data}',
            style: FCITextStyle(color: AccentColor).normal10(),
            textAlign: TextAlign.center,
          ),*/

        InkWell(
          onTap: () {
            widget.moreChange(true);
          },
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
