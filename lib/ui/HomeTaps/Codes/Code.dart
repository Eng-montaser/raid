import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/widget/rounded_input_field.dart';

import 'CodeCard.dart';

class CodeScreen extends StatefulWidget {
  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  TextEditingController searchController = new TextEditingController(text: '');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<GetProvider>(context, listen: false);
    return provider.busy
        ? loading()
        : ListView.builder(
            itemCount: provider.codesData.length + 1,
            itemBuilder: (context, index) {
              if (searchController.text.isEmpty) {
                if (index == 0)
                  return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(10),
                          horizontal: ScreenUtil().setWidth(100)),
                      child: CustomTextInput(
                        obscure: false,
                        controller: searchController,
                        suffixicon: Icon(Icons.keyboard_arrow_down_sharp),
                        hintText: 'search'.tr(),
                        leading: Icons.filter_alt_sharp,
                      ));
                else
                  CodeCard(
                    codeData: provider.codesData[index - 1],
                    searchText: searchController.text,
                  );
              } else {
                if (index == 0)
                  return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(10),
                          horizontal: ScreenUtil().setWidth(100)),
                      child: CustomTextInput(
                        obscure: false,
                        controller: searchController,
                        suffixicon: Icon(Icons.keyboard_arrow_down_sharp),
                        hintText: 'search'.tr(),
                        leading: Icons.filter_alt_sharp,
                      ));
                else
                  CodeCard(
                    codeData: provider.codesData[index - 1],
                    searchText: searchController.text,
                  );
              }
            });
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
