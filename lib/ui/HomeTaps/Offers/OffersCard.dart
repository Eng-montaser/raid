import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/ProductData.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/widget/CustomWidgets.dart';

class OfferCard extends StatefulWidget {
  final ProductOffer productOffer;
  const OfferCard({Key key, this.productOffer}) : super(key: key);
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<OfferCard> {
  double percent = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      percent =
          (widget.productOffer.newPrice / widget.productOffer.oldPrice) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      //  height: size.height * 2 / 7,
      width: size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(10),
            horizontal: ScreenUtil().setWidth(10)),
        child: Stack(
          children: [
            Card(
              shadowColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.productOffer.name,
                            style: FCITextStyle().bold16(),
                          ),
                          FittedBox(
                            child: Container(
                                width: ScreenUtil().setWidth(280),
                                child: Text(
                                  widget.productOffer.description,
                                  style: FCITextStyle().normal13(),
                                )),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(10),
                          ),
                          Row(
                            children: [
                              Text(
                                "${widget.productOffer.newPrice} جنيه",
                                style:
                                    FCITextStyle(color: Colors.red).normal14(),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(20),
                              ),
                              widget.productOffer.oldPrice != null
                                  ? Text(
                                      "${widget.productOffer.oldPrice.toString()} جنيه",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.black,
                                        decorationThickness: 1,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                      ),
                                    )
                                  : Container(),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(5),
                          horizontal: ScreenUtil().setWidth(10),
                        ),
                        child: CustomWidgets().CustomImage(
                          fileImage: null,
                          assetsImagePath: 'assets/images/place.png',
                          networkImageUrl: widget.productOffer.image,
                          height: ScreenUtil().setHeight(150),
                          width: ScreenUtil().setWidth(140),
                        ),
                      ),
                    ],
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
                              Text("Save".tr())
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
                    'عرض المفرمة',
                    style: FCITextStyle(color: Colors.white).normal16(),
                  ),
                ),
              ),
              alignment: Alignment.topRight,
            ),
            Positioned(
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
                    "خصم ${percent.toStringAsFixed(2)} %",
                    style: FCITextStyle(color: Colors.white).normal13(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
