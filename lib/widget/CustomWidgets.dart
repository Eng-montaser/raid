import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CustomWidgets{
  Widget CircleImage({networkImageUrl, assetsImagePath="assets/images/place.png",
    fileImage, radius=100}){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: ScreenUtil().setWidth(radius*2),
          height: ScreenUtil().setWidth(radius*2),
          child: ClipOval(
              child:fileImage==null?
              networkImageUrl==null?
              Image.asset(assetsImagePath,
                height: ScreenUtil().setWidth(radius*2),
                width: ScreenUtil().setWidth(radius*2),
                fit: BoxFit.fill,
              ):
              CachedNetworkImage(
                width: ScreenUtil().setWidth(radius*2),
                height: ScreenUtil().setWidth(radius*2),
                imageUrl:networkImageUrl,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Container(
                      width: ScreenUtil().setWidth(radius*2),
                      height: ScreenUtil().setWidth(radius*2),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            assetsImagePath,
                            height: ScreenUtil().setWidth(radius*2),
                            width: ScreenUtil().setWidth(radius*2),
                            fit: BoxFit.fill,
                          ),
                          Image.asset(
                            "assets/images/loading.gif",
                            height: ScreenUtil().setWidth(radius),
                            width: ScreenUtil().setWidth(radius),
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                errorWidget: (context, url, error) =>  Image.asset(
                  assetsImagePath,
                  height: ScreenUtil().setWidth(radius*2),
                  width: ScreenUtil().setWidth(radius*2),
                  fit: BoxFit.fill,
                ),
              )
                  :
              Image.file(fileImage,
                height: ScreenUtil().setWidth(radius*2),
                width: ScreenUtil().setWidth(radius*2),
                fit: BoxFit.fill,
              )
          ),
        ),
      ],
    );
  }
  Widget CustomImage({networkImageUrl, assetsImagePath="assets/images/place.png",
    fileImage, width=100,height=100}){
    return  fileImage==null?
    networkImageUrl==null?
    Image.asset(assetsImagePath,
      width: width,
      height: height,
      fit: BoxFit.fill,
    ):
    CachedNetworkImage(
      width: width,
      height: height,
      imageUrl:networkImageUrl,
      fit: BoxFit.fill,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          Container(
            width: width,
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  assetsImagePath,
                  width: width,
                  height: height,
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  "assets/images/loading.gif",
                  width: 50,
                  height: 50,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
      errorWidget: (context, url, error) =>
          Image.asset(
            assetsImagePath,
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),
    )
        :
    Image.file(fileImage,
      width: width,
      height: height,
      fit: BoxFit.fill,
    );
  }

}