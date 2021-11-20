import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/ConciliationData.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/provider/PostProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/ui/HomeTaps/Conciliation/search_page.dart';
import 'package:raid/widget/rounded_input_field.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'ConciliationCard.dart';

class ConciliationScreen extends StatefulWidget {
  @override
  _ConciliationScreenState createState() => _ConciliationScreenState();
}

class _ConciliationScreenState extends State<ConciliationScreen> {
  //List<ConciliationData> conciliationData = [];
  ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController(text: '');
  //List<ConciliationData> temp = [], temp2 = [];
  ConciliationData searchConciliationData;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      /*  temp = await Provider.of<GetProvider>(context, listen: false)
          .getIntegrations();*/
    });
    searchController.addListener(() {
      setState(() {
        searchtext = searchController.text;
      });
    });
  }

  String searchtext = '';
  //01143271160
  bool moreDetails = false;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    var getProvider = Provider.of<GetProvider>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    searchtext = searchController.text;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(30),
            ScreenUtil().setHeight(5),
            ScreenUtil().setWidth(30),
            ScreenUtil().setHeight(70)),
        child: getProvider.busy
            ? loading()
            : ListView.builder(
                controller: _scrollController,
                itemCount: getProvider.conciliationData.length + 1,
                itemBuilder: (context, index) => index == 0
                    ? !moreDetails
                        ? Column(
                            children: [
                              Text(
                                'التوفيقات',
                                textScaleFactor: 1.5,
                                style:
                                    FCITextStyle(color: AccentColor).bold20(),
                              ),
                              /*  Text(
                            'Flutter is Googles UI toolkit for building beautiful, natively compiled applications for mobile, web, desktop, and embedded devices from a single codebase. ',
                            style: FCITextStyle(color: AccentColor).normal10(),
                            textAlign: TextAlign.center,
                          ),*/
//                        SizedBox(
//                          height: ScreenUtil().setHeight(40),
//                        )
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(10),
                                horizontal: ScreenUtil().setWidth(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (moreDetails)
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        moreDetails = false;
                                      });
                                    },
                                    child: Icon(Icons.arrow_back_ios_outlined),
                                  ),
                                InkWell(
                                  onTap: () {
                                    if (searchConciliationData != null)
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => ConcSearch(
                                                    data:
                                                        searchConciliationData,
                                                  )));
                                  },
                                  child: CustomTextInput(
                                    obscure: false,
                                    enabled: false,
                                    suffixicon:
                                        Icon(Icons.keyboard_arrow_down_sharp),
                                    hintText: 'search'.tr(),
                                    leading: Icons.filter_alt_sharp,
                                    controller: searchController,
                                  ),
                                ),
                              ],
                            ))
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(20)),
                        child: /* !moreDetails
                            ? */
                            ConciliationCard(
                          conciliationData:
                              getProvider.conciliationData[index - 1],
                          isOdd: index % 2 == 0 ? false : true,
                          moreChange: (val) {
                            /* setState(() {
                                    moreDetails = val;
                                    searchConciliationData =
                                        getProvider.conciliationData[index - 1];
                                  });
//                                  */
                            if (getProvider.conciliationData[index - 1] != null)
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ConcSearch(
                                        data: getProvider
                                            .conciliationData[index - 1],
                                      )));
                          },
                        )
                        /*: ConciliationDetailsCard(
                                conciliationData: getProvider
                                    .conciliationData[index - 1].integrations
                                    .where((element) => element.tags
                                        .contains(searchController.text))
                                    .toList(),
                                name: getProvider
                                    .conciliationData[index - 1].name,
                                searchText: searchtext,
                              )*/
                        )),
      ),
      bottomSheet: Container(
          width: size.width,
          height: ScreenUtil().setWidth(80),
          child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => sendSuggestion(context));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: ScreenUtil().setHeight(150),
                  alignment: Alignment.center,
                  height: ScreenUtil().setHeight(50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red,
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text(
                    "اقتراح توفيق",
                    style: FCITextStyle(color: Colors.white).bold18(),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void _moveDown(GlobalKey myKey) {
    final keyContext = myKey.currentContext;

    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      _scrollController.animateTo(_scrollController.offset + box.size.height,
          duration: Duration(milliseconds: 100), curve: Curves.linear);
    }
  }

  ///------------------------------------------
  ///      Send New Suggestion Integration    -
  /// -----------------------------------------
  String _selectedIntegrationCategory;
  int _selectedIntegrationCategoryId;
  List<String> _selectedIntegrationTages = [];
  TextEditingController integrationName = new TextEditingController();
  TextEditingController integrationTag = new TextEditingController();
  Widget sendSuggestion(context) {
    Size size = MediaQuery.of(context).size;
    var getProvider = Provider.of<GetProvider>(context, listen: false);

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      content: Container(
          width: size.width,
          height: size.shortestSide,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "اقتراح توفيقات",
                style: FCITextStyle(color: accentColor).bold22(),
              ),
              InkWell(
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                          title: Text(
                            "Select.Integration".tr(),
                            style: FCITextStyle(color: accentColor).normal18(),
                          ),
                          actions: List.generate(
                            getProvider.conciliationData.length,
                            (int index) {
                              return CupertinoActionSheetAction(
                                child: Text(
                                  "${getProvider.conciliationData[index].name}",
                                  style: FCITextStyle(color: primaryColor)
                                      .normal18(),
                                ),
                                isDefaultAction: true,
                                onPressed: () {
                                  setState(() {
                                    _selectedIntegrationCategory = getProvider
                                        .conciliationData[index].name;
                                    _selectedIntegrationCategoryId =
                                        getProvider.conciliationData[index].id;
                                  });
                                  Navigator.of(context).pop();
                                },
                              );
                            },
//                    <Widget>[
//                      CupertinoActionSheetAction(
//                        child: Text("Action 1"),
//                        isDefaultAction: true,
//                        onPressed: () {
//                          print("Action 1 is been clicked");
//                        },
//                      ),
//                      CupertinoActionSheetAction(
//                        child: Text("Action 2"),
//                        isDestructiveAction: true,
//                        onPressed: () {
//                          print("Action 2 is been clicked");
//                        },
//                      )
//                    ],
                          )));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(10)),
                  width: size.width,
                  alignment: Alignment.center,
                  height: ScreenUtil().setHeight(50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.white,
                      border: Border.all(color: accentColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedIntegrationCategory == null
                            ? "Select.Integration".tr()
                            : _selectedIntegrationCategory,
                        style: FCITextStyle(color: accentColor).bold18(),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: accentColor,
                        size: ScreenUtil().setWidth(25),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: size.width,
                alignment: Alignment.center,
                height: ScreenUtil().setHeight(50),
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: accentColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10)),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: integrationName,
                  onSubmitted: (value) {},
                  autofocus: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Integration.Name".tr(),
                    hintStyle: FCITextStyle(color: Colors.grey).normal18(),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: size.width,
//                alignment: Alignment.center,
//                height: ScreenUtil().setHeight(50),
//                margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: accentColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(10)),
                  child: Column(
                    children: [
                      TextField(
                        textAlign: TextAlign.center,
                        controller: integrationTag,
                        onSubmitted: (value) {},
                        autofocus: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffix: IconButton(
                            icon: Icon(Icons.add,
                                size: ScreenUtil().setWidth(25)),
                            onPressed: () {
                              if (integrationTag.text.isNotEmpty) {
                                _selectedIntegrationTages
                                    .add(integrationTag.text);
                                integrationTag.clear();
                              }
                            },
                          ),
                          hintText: "TAGS".tr(),
                          hintStyle:
                              FCITextStyle(color: Colors.grey).normal18(),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(10)),
                          height: ScreenUtil().setHeight(150),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Wrap(
                              spacing: 8.0,
                              direction: Axis.horizontal,
                              runSpacing: 4.0, // gap between lines
                              children: <Widget>[
                                ..._selectedIntegrationTages
                                    .map((tag) => Chip(
                                          labelStyle: FCITextStyle().normal18(),
                                          label: Text(tag),
                                          deleteIcon: Icon(Icons.clear),
                                          onDeleted: () {
                                            setState(() {
                                              _selectedIntegrationTages
                                                  .remove(tag);
                                            });
                                          },
                                        ))
                                    .toList()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RoundedLoadingButton(
                child: Text('send'.tr(),
                    style: FCITextStyle(color: Colors.white).normal18()),
                width: ScreenUtil().setWidth(100),
                color: primaryColor,
                controller: _btnController,
                onPressed: () {
                  sendSuggestionIntegration();
                },
              ),
            ],
          )),
    );
  }

  sendSuggestionIntegration() async {
    if (_selectedIntegrationCategoryId != null &&
        integrationName.text.isNotEmpty &&
        _selectedIntegrationTages.length != 0) {
      await Provider.of<PostProvider>(context, listen: false)
          .sendSuggestionIntegration(_selectedIntegrationCategoryId,
              integrationName.text, setTags(_selectedIntegrationTages))
          .then((response) {
        if (response) {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.SUCCES,
              dismissOnBackKeyPress: true,
              dismissOnTouchOutside: true,
              title: "Suggestion.Integration".tr(),
              desc: "Suggestion.MSG".tr(),
//                        body: Column(
//                          crossAxisAlignment:
//                          CrossAxisAlignment.center,
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: [
//                            Text(
//                              "send INTEGRATION",
//                              style: TextStyle(
//                                  fontSize: 18,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            Text("INTEGRATION Successful",
//                              style: TextStyle(
//                                  fontSize: 16,
//                                  fontWeight: FontWeight.normal,
//                                  color: Colors.grey),
//                            ),
//                            Text(
//                              "order.successful.desc".tr(),
//                              style: TextStyle(
//                                  fontSize: 16,
//                                  fontWeight: FontWeight.normal,
//                                  color: Colors.black),
//                              textAlign: TextAlign.center,
//                            )
//                          ],
//                        ),
              btnOkText: "ok".tr(),
              btnOkColor: Colors.red,
              btnOkOnPress: () {},
              onDissmissCallback: (type) {})
            ..show();
          clearData();
        } else {
          AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.ERROR,
              dismissOnBackKeyPress: true,
              dismissOnTouchOutside: true,
              title: "Suggestion.Integration".tr(),
              desc: "Suggestion.Fail".tr(),
//                        body: Column(
//                          crossAxisAlignment:
//                          CrossAxisAlignment.center,
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: [
//                            Text(
//                              "send INTEGRATION",
//                              style: TextStyle(
//                                  fontSize: 18,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            Text("INTEGRATION Successful",
//                              style: TextStyle(
//                                  fontSize: 16,
//                                  fontWeight: FontWeight.normal,
//                                  color: Colors.grey),
//                            ),
//                            Text(
//                              "order.successful.desc".tr(),
//                              style: TextStyle(
//                                  fontSize: 16,
//                                  fontWeight: FontWeight.normal,
//                                  color: Colors.black),
//                              textAlign: TextAlign.center,
//                            )
//                          ],
//                        ),
              btnOkText: "ok".tr(),
              btnOkColor: Colors.red,
              btnOkOnPress: () {},
              onDissmissCallback: (type) {})
            ..show();
          _btnController.reset();
        }
      });
    } else {
//        showInSnackBar("please fill all required fields");
      _btnController.reset();
    }
  }

  setTags(List<String> tags) {
    String tag = '';
    for (int i = 0; i < tags.length; i++) {
      tag += tags[i];
      if (i != tags.length - 1) tag += ',';
    }
    return tag;
  }

  clearData() {
    _selectedIntegrationCategory = null;
    _selectedIntegrationCategoryId = null;
    _selectedIntegrationTages = [];
    integrationName.clear();
    integrationTag.clear();
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(
        value,
        style: FCITextStyle(color: Colors.white).normal18(),
      ),
      duration: new Duration(milliseconds: 100),
      backgroundColor: primaryColor,
    ));
  }
}
