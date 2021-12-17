import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:provider/provider.dart';
import 'package:raid/model/CodeData.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/ui/Profile/CustomerProfile.dart';
import 'package:raid/widget/CustomWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';

class CodeSearch extends StatefulWidget {
  Company data;

  CodeSearch({Key key, this.data}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ConcSearch();
  }
}

class _ConcSearch extends State<CodeSearch> {
  TextEditingController _codeEditingController = TextEditingController();
  String codeData = '';

  List<String> searchResult = [];
  List<CodeCat> search = [];
  List<CodeName> searchCodes = [];
  List<String> tempsearchResult = [];
  bool isLoading = true;
  bool isLoadingData = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      /* widget.data.integrations.forEach((element) {
        //if(element.tags.contains(brandData) || element.tags.contains(brandData))
        //setState(() {
        print('${element.name.split(' ')[1]}');
        String temp = ',';
        searchResult.addAll(element.tags.split(temp).toList());
        tempsearchResult.addAll(element.tags.split(temp).toList());

        //  });
      });*/
      await Provider.of<GetProvider>(context, listen: false)
          .getCodCat()
          .then((value) {
        if (value != null) {
          setState(() {
            search = value;
            isLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(.9),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '${widget.data.name}',
            style: FCITextStyle(color: Colors.white).bold20(),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CustomerProfile()));
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                child: CustomWidgets().CircleImage(
                    fileImage: null,
                    assetsImagePath: 'assets/images/defult_profile.png',
                    networkImageUrl:
                        'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                    radius: 20),
              ),
            ),
          ],
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/white.png'),
              scale: 3,
            )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                getCategories(),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Expanded(
                  child: isLoadingData
                      ? loading()
                      : searchCodes.length > 0
                          ? ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) => Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(15)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ScreenUtil().setWidth(15)),
                                      child: Text(
                                        '${searchCodes[index].title}',
                                        style: FCITextStyle(color: primaryColor)
                                            .bold18(),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        if (await canLaunch(
                                            "tel:${removeAllHtmlTags(searchCodes[index].description)}")) {
                                          await launch(
                                              "${removeAllHtmlTags(searchCodes[index].description)}");
                                        } else {
                                          throw 'Could not launch ${removeAllHtmlTags(searchCodes[index].description)}';
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: ScreenUtil().setHeight(5),
                                            horizontal:
                                                ScreenUtil().setWidth(10)),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            border: Border.all(
                                                width: 1,
                                                color: primaryColor
                                                    .withOpacity(.3))),
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                ScreenUtil().setWidth(15),
                                            vertical:
                                                ScreenUtil().setHeight(5)),
                                        child: Icon(
                                          Icons.call,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              shrinkWrap: true,
                              itemCount: searchCodes.length,
                            )
                          : Text(
                              "لا توجد اكواد",
                              style: FCITextStyle(color: Colors.black45)
                                  .normal18()
                                  .copyWith(fontStyle: FontStyle.italic),
                            ),
                )
              ],
            ),
          ),
        ),
        bottomSheet: InkWell(
          onTap: () {
            //if(element.tags.contains(brandData) || element.tags.contains(brandData))
            setState(() {
              searchResult = [];
              _codeEditingController.text = '';
            });
          },
          child: Container(
            height: ScreenUtil().setHeight(50),
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
            color: primaryColor,
            width: double.infinity,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'ابحث',
                style: FCITextStyle(color: Colors.white).bold18(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCategories() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xfff1f1f1), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      //  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
      width: MediaQuery.of(context).size.width * 0.95,
      height: ScreenUtil().setHeight(60),
      child: TypeAheadField<CodeCat>(
        suggestionsCallback: (pattern) async {
          List<CodeCat> data = [];

          search.forEach((element) {
            if (element.name.toUpperCase().contains(pattern.toUpperCase())) {
              if (!data.contains(element)) data.add(element);
            }
          });
          return data;
        },
        itemBuilder: (context, CodeCat suggestion) {
          return ListTile(
            title: Text(
              suggestion != null ? suggestion.name : '',
              style: FCITextStyle().bold16(),
            ),
            /* subtitle: Text(
                        suggestion.phone != null ? '(${suggestion.phone})' : '',
                        style: FCITextStyle(color: Colors.grey).normal16(),
                      ),*/
          );
        },
        textFieldConfiguration: TextFieldConfiguration(
            enabled: !isLoading,
            style: FCITextStyle(color: primaryColor).normal18().copyWith(),
            onTap: () {
              setState(() {
                _codeEditingController.text = '';
              });
            },
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
              labelText: 'اختر نوع الخدمة',
              border: OutlineInputBorder(),
            ),
            textAlign: TextAlign.end,
            controller: _codeEditingController),
        onSuggestionSelected: (suggestion) async {
          setState(() {
            isLoadingData = true;
            _codeEditingController.text = suggestion.name;
            codeData = suggestion.name;
            searchResult = [];
          });
          await Provider.of<GetProvider>(context, listen: false)
              .getCompanyCodCat(widget.data.id, suggestion.id)
              .then((value) {
            if (value != null) {
              setState(() {
                searchCodes = value;
              });
            }
          });
          setState(() {
            isLoadingData = false;
          });
          //setData();
          //   print(suggestion.name);
        },
      ),
    );
  }
}
