import 'package:animated_widgets/animated_widgets.dart';
import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raid/model/ProductData.dart';

class ServiceCard2 extends StatefulWidget {
  final Mobile servicesData;

  const ServiceCard2({Key key, this.servicesData}) : super(key: key);
  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard2> {
  bool showDetails = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(10),
        right: ScreenUtil().setWidth(10),
        top: ScreenUtil().setHeight(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(15),
              vertical: ScreenUtil().setHeight(10),
            ),
            child: InkWell(
              splashColor: Colors.white,
              onTap: () {
                setState(() {
                  showDetails = !showDetails;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${widget.servicesData.title}"),
                  Icon(showDetails
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down)
                ],
              ),
            ),
          ),
          if (showDetails)
            TranslationAnimatedWidget.tween(
                enabled: showDetails,
                curve: Curves.ease,
                duration: Duration(milliseconds: 300),
                translationDisabled: Offset(0, -50),
                translationEnabled: Offset(0, 1),
                child: OpacityAnimatedWidget.tween(
                    enabled: showDetails,
                    opacityDisabled: 0,
                    opacityEnabled: 1,
                    child: Column(
                      children: [
                        Container(
                          height: (size.height / 2) - 100,
                          width: size.width - 50,
                          child: CachedNetworkImage(
                            imageUrl: "${widget.servicesData.image}",
                            // fit: BoxFit.fill,
//                                                    progressIndicatorBuilder: (context,
//                                                            url,
//                                                            downloadProgress) =>
//                                                        Container(
//                                                            child:
//                                                                CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/place.png",
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(15),
                            vertical: ScreenUtil().setHeight(10),
                          ),
                          child: Text("${widget.servicesData.description}"),
                        ),
                      ],
                    )))
        ],
      ),
    );
  }
}
