import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/BrandData.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/style/FCITextStyles.dart';

class BrandsScreen extends StatefulWidget {
  @override
  _BrandsScreenState createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    var provider = Provider.of<GetProvider>(context, listen: false);

    return provider.busy
        ? loading()
        : Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(25),
                horizontal: ScreenUtil().setWidth(10)),
            child: GridView.builder(
              itemCount: provider.brandsData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (orientation == Orientation.portrait) ? 3 : 3),
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  height: ScreenUtil().setHeight(110),
                  width: ScreenUtil().setWidth(100),
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        height: ScreenUtil().setHeight(100),
                        width: ScreenUtil().setWidth(100),
                        imageUrl: provider.brandsData[index].image,
                        fit: BoxFit.fill,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/loading.gif',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Text(
                        "${provider.brandsData[index].title}",
                        style: FCITextStyle(color: AccentColor).bold16(),
                      )
                    ],
                  ),
                );
              },
            ),
          );
  }
}
