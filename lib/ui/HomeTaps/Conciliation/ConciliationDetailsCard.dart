import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raid/model/ConciliationData.dart';
import 'package:raid/style/FCITextStyles.dart';

import '../../../constants.dart';

class ConciliationDetailsCard extends StatefulWidget {
   List<Integrations> conciliationData;
   String name;
   String searchText;

   ConciliationDetailsCard({Key key, this.conciliationData, this.name, this.searchText}) : super(key: key);

  @override
  _ConciliationDetailsCardState createState() =>
      _ConciliationDetailsCardState();
}

class _ConciliationDetailsCardState extends State<ConciliationDetailsCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.conciliationData.length > 0
        ? Card(
            shadowColor: Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.name,
                    style: FCITextStyle().bold20(),
                  ),
                ),
                Table(
                  defaultColumnWidth: IntrinsicColumnWidth(),
                  columnWidths: <int, TableColumnWidth>{
                    0: FixedColumnWidth(ScreenUtil().setWidth(120)),
                    1: const FlexColumnWidth(3),
                  },
                  border: TableBorder.all(color: Colors.grey),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: List.generate(
                      widget.conciliationData
                          .where((element) =>
                              element.tags.contains(widget.searchText))
                          .toList()
                          .length, (indx) {
                    List<String> commas =
                        widget.conciliationData[indx].tags.split(',');
                    return TableRow(
                      children: [
                        FittedBox(
                          //  width: ScreenUtil().setWidth(120),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                ' ${widget.conciliationData[indx].name}',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .fontSize,
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          children: List.generate(
                            commas.length,
                            (index) {
                              return Text(
                                '${commas[index]}',
                                style: Theme.of(context).textTheme.caption,
                              );
                            },
                          ),
                          spacing: 3,
                        )
                      ],
                    );
                  }),
                ),
                /*Wrap(
                  // color: Colors.grey,
                  // margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
                  children: conciliationData != null
                      ? List.generate(conciliationData.integrations.length,
                          (index) {
                          return Container(
                            color: Colors.grey,
                            child: Container(
                              margin: EdgeInsets.all(1),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${conciliationData.integrations[index].name}   >',
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  Wrap(
                                    spacing: ScreenUtil().setWidth(25),
                                    alignment: WrapAlignment.center,
                                    children: List.generate(
                                      conciliationData.integrations[index].tags
                                          .split(',')
                                          .length,
                                      (indx) => Text(
                                        '${conciliationData.integrations[index].tags.split(',')[indx]}',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                      : Container(),
                ),*/
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
          )
        : Container();
  }
}
