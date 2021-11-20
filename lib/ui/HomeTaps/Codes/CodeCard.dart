import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/CodeData.dart';
import 'package:raid/widget/CustomWidgets.dart';
import 'package:raid/widget/hightLight.dart';

class CodeCard extends StatefulWidget {
  CodeData codeData;
  String searchText;
  CodeCard({Key key, this.codeData, this.searchText}) : super(key: key);
  @override
  _CodeCardState createState() => _CodeCardState();
}

class _CodeCardState extends State<CodeCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // height: size.height * 2 / 7,
      width: size.width,
      child: widget.codeData.description
                  .where((element) => element.contains(widget.searchText))
                  .length >
              0
          ? Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(10),
                  horizontal: ScreenUtil().setWidth(10)),
              child: Card(
                shadowColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(5),
                        horizontal: ScreenUtil().setWidth(10),
                      ),
                      child: CustomWidgets().CustomImage(
                        fileImage: null,
                        assetsImagePath: 'assets/images/place.png',
                        networkImageUrl: widget.codeData.image,
                        height: ScreenUtil().setHeight(50),
                        width: ScreenUtil().setWidth(140),
                      ),
                    ),
                    /*Container(
                        //   width: ScreenUtil().setWidth(280),
                        child: Text(
                      '${removeAllHtmlTags(widget.codeData.title)}',
                      style: FCITextStyle().bold18(),
                    )),*/
                    Column(
                      children: List.generate(
                          widget.codeData.description
                              .where((element) =>
                                  element.contains('${widget.searchText}'))
                              .length,
                          (index) => HighlightText(
                                text:
                                    '${removeAllHtmlTags(widget.codeData.description[index])}',
                                highlight: widget.searchText,
                                highlightColor: Colors.blue,
                                ignoreCase: true,
                              )),
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
                                Text("Share")
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
