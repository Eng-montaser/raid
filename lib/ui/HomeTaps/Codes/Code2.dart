import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/CodeData.dart';
import 'package:raid/provider/GetProvider.dart';

import 'search_page.dart';

class CodeScreen2 extends StatefulWidget {
  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen2> {
  TextEditingController searchController = new TextEditingController(text: '');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<GetProvider>(context, listen: false);
    return Column(
      children: [
        provider.busy
            ? loading()
            : Expanded(
                child: Container(
                  // color: done ? Colors.grey : Colors.transparent,
                  margin: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(30),
                      vertical: ScreenUtil().setHeight(30)),
                  child: AnimationLimiter(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      addRepaintBoundaries: false,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: .3,
                      //physics:BouncingScrollPhysics(),

                      children:
                          List.generate(provider.companies.length, (index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          columnCount: 2,
                          duration: const Duration(milliseconds: 500),
                          child: ScaleAnimation(
                            scale: 0.5,
                            child: FadeInAnimation(
                              delay: const Duration(milliseconds: 200),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CodeSearch(
                                                  data:
                                                      provider.companies[index],
                                                )));
                                  },
                                  child: Container(
                                    //    color: Colors.white,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        gettemp(provider.companies[index]),
                                        Container(
                                          width: ScreenUtil().setWidth(150),
                                          height: ScreenUtil().setWidth(40),
                                          alignment: Alignment.center,
                                          /* margin: EdgeInsets.symmetric(
                                              vertical:
                                                  ScreenUtil().setHeight(5)),*/
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setWidth(20),
                                              vertical:
                                                  ScreenUtil().setHeight(5)),
                                          decoration: BoxDecoration(
                                              color: primaryColor,
                                              /*  border: Border.all(
                                                  color: primaryColor,
                                                  width: .5),*/
                                              borderRadius:
                                                  BorderRadius.circular(0)),
                                          child: FittedBox(
                                            child: Text(
                                              '${provider.companies[index].name}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget gettemp(Company data) {
    return Stack(
      children: <Widget>[
        //image code

        //top grey shadow

        //bottom grey shadow
        Center(
          child: CachedNetworkImage(
            imageUrl: data.image ?? '/',

            fit: BoxFit.fill,
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/place.png',
              fit: BoxFit.contain,
            ),

            // colorBlendMode: BlendMode.src,
            width: ScreenUtil().setWidth(150),
            height: ScreenUtil().setWidth(130),
          ),
        ),
      ],
    );
  }
}

//class CodeScreen extends StatefulWidget {
//  @override
//  _CodeScreenState createState() => _CodeScreenState();
//}
//
//class _CodeScreenState extends State<CodeScreen> {
//  TextEditingController searchController = new TextEditingController(text: '');
//  String searchText = '';
//  @override
//  void initState() {
//    super.initState();
//    searchController.addListener(() {
//      setState(() {
//        searchText = searchController.text;
//      });
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    Size size = MediaQuery.of(context).size;
//    var provider = Provider.of<GetProvider>(context, listen: false);
//    return provider.busy
//        ? loading()
//        : ListView.builder(
//            itemCount: provider.codesData
//                    .where((element) =>
//                        element.description.contains(searchController.text))
//                    .length +
//                1,
//            itemBuilder: (context, index) => index == 0
//                ? Padding(
//                    padding: EdgeInsets.symmetric(
//                        vertical: ScreenUtil().setHeight(10),
//                        horizontal: ScreenUtil().setWidth(100)),
//                    child: CustomTextInput(
//                      obscure: false,
//                      controller: searchController,
//                      suffixicon: Icon(Icons.keyboard_arrow_down_sharp),
//                      hintText: 'search'.tr(),
//                      leading: Icons.filter_alt_sharp,
//                    ))
//                : CodeCard(
//                    codeData: provider.codesData[index - 1],
//                    searchText: searchText,
//                  ));
//  }
//}
