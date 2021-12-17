import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/style/FCITextStyles.dart';

import 'ServiceCard.dart';

class MyServicesScreen2 extends StatefulWidget {
  @override
  _MyServicesScreenState createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen2> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    var provider = Provider.of<GetProvider>(context, listen: false);

    return provider.busy
        ? loading()
        : Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(5),
                horizontal: ScreenUtil().setWidth(30)),
            child: ListView.builder(
                itemCount: provider.serviceData.length + 1,
                itemBuilder: (context, index) => index == 0
                    ? Column(
                        children: [
                          Text(
                            'خدماتى',
                            textScaleFactor: 1.5,
                            style: FCITextStyle(color: AccentColor).bold20(),
                          ),
//                    Text(
//                      'Flutter is Googles UI toolkit for building beautiful, natively compiled applications for mobile, web, desktop, and embedded devices from a single codebase. ',
//                      style: FCITextStyle(color: AccentColor).normal10(),
//                      textAlign: TextAlign.center,
//                    ),
//                    SizedBox(
//                      height: ScreenUtil().setHeight(40),
//                    )
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(20)),
                        child: ServiceCard(
                          servicesData: provider.serviceData[index - 1],
                        ),
                      )),
          );
  }
}
