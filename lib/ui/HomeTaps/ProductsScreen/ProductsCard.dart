import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/ProductData.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/widget/CustomWidgets.dart';

class ProductCard extends StatefulWidget {
  final ProductData productData;
  const ProductCard({Key key, this.productData}) : super(key: key);
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 2 / 7,
      width: size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(10),
            horizontal: ScreenUtil().setWidth(10)),
        child: Stack(
          children: [
            Card(
              margin: EdgeInsets.all(5),
              shadowColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(10),
                            horizontal: ScreenUtil().setWidth(10),
                          ),
                          child: CustomWidgets().CustomImage(
                            fileImage: null,
                            assetsImagePath: 'assets/images/place.png',
                            networkImageUrl: widget.productData.image,
                            height: ScreenUtil().setHeight(150),
                            width: ScreenUtil().setWidth(140),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Text(
                                widget.productData.category,
                                style: FCITextStyle().normal16(),
                              ),
                              Expanded(
                                child: FittedBox(
                                  child: Container(
                                      width: ScreenUtil().setWidth(280),
                                      height: ScreenUtil().setWidth(100),
                                      child: Html(
                                        data: widget.productData.description,
                                      )
//                                Text(
//                                  ,
//                                  style: FCITextStyle().normal13(),
//                                )
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),
                              Text(
                                "${widget.productData.price.toString()} جنيه",
                                style:
                                    FCITextStyle(color: Colors.red).normal13(),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    width: size.width,
                    height: ScreenUtil().setHeight(35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.favorite_outlined,
                                color: Colors.red,
                                size: ScreenUtil().setWidth(20),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(5),
                              ),
                              Text("125")
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.bookmark,
                                color: AccentColor,
                                size: ScreenUtil().setWidth(20),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(5),
                              ),
                              Text("Save")
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.share,
                                color: AccentColor,
                                size: ScreenUtil().setWidth(20),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(5),
                              ),
                              Text("Share".tr())
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              child: FittedBox(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(5)),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(10)),
                  decoration: BoxDecoration(
                      color: PrimaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        topRight: Radius.circular(5),
                      )),
                  alignment: Alignment.center,
                  height: ScreenUtil().setHeight(25),
//                  width: ScreenUtil().setWidth(100),
                  child: Text(
                    widget.productData.name,
                    style: FCITextStyle(color: Colors.white).normal14(),
                  ),
                ),
              ),
              alignment: Alignment.topRight,
            ),
            widget.productData.offer != null
                ? Positioned(
                    left: 0,
                    top: ScreenUtil().setHeight(10),
                    child: FittedBox(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(2)),
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(2)),
                        decoration: BoxDecoration(
                            color: PrimaryColor,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(25),
                              topRight: Radius.circular(25),
                            )),
                        alignment: Alignment.center,
                        height: ScreenUtil().setHeight(25),
//                  width: ScreenUtil().setWidth(100),
                        child: Text(
                          "Offer ${widget.productData.offer} %",
                          style: FCITextStyle(color: Colors.white).normal10(),
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
