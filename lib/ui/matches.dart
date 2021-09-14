import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/widget/rounded_input_field.dart';

class Matches extends StatefulWidget {
  Matches({Key key}) : super(key: key);

  @override
  _OurService createState() => _OurService();
}

class _OurService extends State<Matches> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<GetProvider>(context, listen: false)
          .getIntegrations();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomTextInput(
              obscure: false,
              suffixicon: Icon(Icons.keyboard_arrow_down_sharp),
              hintText: 'search'.tr(),
              leading: Icons.filter_alt_sharp,
            ),
            cards('screens'),
            cards('touches')
          ],
        ),
      ),
    );
  }

  Widget cards(String header) {
    return Card(
      margin: EdgeInsets.all(15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              header.tr(),
              style: FCITextStyle().bold20(),
            ),
          ),
          Container(
            color: Colors.grey,
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 6,
              addRepaintBoundaries: true,
              crossAxisSpacing: .5,
              mainAxisSpacing: .5,

              //physics:BouncingScrollPhysics(),
//              padding: EdgeInsets.symmetric(
//                  horizontal: ScreenUtil().setWidth(30)),
              children: List.generate(36, (index) {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ite $index',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        if (index % 6 == 0)
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            size: ScreenUtil().setSp(12),
                            color: Colors.grey,
                          )
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Container(
            color: Colors.grey.withOpacity(.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: Icon(
                    Icons.favorite,
                    color: primaryColor,
                  ),
                  label: Text('125'),
                ),
                TextButton.icon(
                  icon: Icon(
                    Icons.bookmark,
                    color: Colors.grey,
                  ),
                  label: Text('Save'.tr()),
                ),
                TextButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.shareAlt,
                    color: Colors.grey,
                  ),
                  label: Text('Share'.tr()),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
