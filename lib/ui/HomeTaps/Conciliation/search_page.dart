import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:provider/provider.dart';
import 'package:raid/model/ConciliationData.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/ui/Profile/CustomerProfile.dart';
import 'package:raid/widget/CustomWidgets.dart';

import '../../../constants.dart';

class ConcSearch extends StatefulWidget {
  ConciliationData data;

  ConcSearch({Key key, this.data}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ConcSearch();
  }
}

class _ConcSearch extends State<ConcSearch> {
  TextEditingController _brandEditingController = TextEditingController();
  String brandData = '';
  TextEditingController _modelEditingController = TextEditingController();
  String modelData = '';
  List<String> searchResult = [];
  List<String> searchBrands = [];
  List<Integrations> searchIntegr = [];
  List<String> tempsearchResult = [];

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
      searchBrands = await Provider.of<GetProvider>(context, listen: false)
          .getSearchBrand(widget.data.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            ' توفيقات ${widget.data.name}',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              searchBrands.length > 0
                  ? getBrands(searchBrands)
                  : Text('تحميل...'),
              searchIntegr.length > 0
                  ? getModels(searchIntegr)
                  : _brandEditingController.text.isNotEmpty
                      ? Text('تحميل...')
                      : Container(),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              Expanded(
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(15)),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(15)),
                      child: Text(
                        '${searchResult[index]}',
                        style: FCITextStyle(color: primaryColor).bold20(),
                      ),
                    ),
                  ),
                  shrinkWrap: true,
                  itemCount: searchResult.length,
                ),
              )
            ],
          ),
        ),
        bottomSheet: InkWell(
          onTap: () {
            //if(element.tags.contains(brandData) || element.tags.contains(brandData))
            setState(() {
              searchResult = [];
              _brandEditingController.text = '';
              _modelEditingController.text = '';
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

  Widget getBrands(List<String> Brands) {
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
      child: TypeAheadField<String>(
        suggestionsCallback: (pattern) async {
          List<String> data = [];

          Brands.forEach((element) {
            if (element.toUpperCase().contains(pattern.toUpperCase())) {
              if (!data.contains(element)) data.add(element);
            }
          });
          return data;
        },
        itemBuilder: (context, String suggestion) {
          return ListTile(
            title: Text(
              suggestion != null ? suggestion : '',
              style: FCITextStyle().bold16(),
            ),
            /* subtitle: Text(
                        suggestion.phone != null ? '(${suggestion.phone})' : '',
                        style: FCITextStyle(color: Colors.grey).normal16(),
                      ),*/
          );
        },
        textFieldConfiguration: TextFieldConfiguration(
            style: FCITextStyle(color: primaryColor).normal18().copyWith(),
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
              labelText: 'اختر الماركة من هنا',
              border: OutlineInputBorder(),
            ),
            textAlign: TextAlign.end,
            controller: _brandEditingController),
        onSuggestionSelected: (suggestion) async {
          setState(() {
            _brandEditingController.text = suggestion;
            brandData = suggestion;
          });
          searchIntegr = await Provider.of<GetProvider>(context, listen: false)
              .getSearchModel(suggestion, widget.data.id);
          //setData();
          //   print(suggestion.name);
        },
      ),
    );
  }

  Widget getModels(List<Integrations> integrations) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xfff1f1f1), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      //padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
      width: MediaQuery.of(context).size.width * 0.95,
      height: ScreenUtil().setHeight(60),
      child: TypeAheadField<Integrations>(
        suggestionsCallback: (pattern) async {
          List<Integrations> data = [];

          integrations.forEach((element) {
            if (element.name.toUpperCase().contains(pattern.toUpperCase()))
              data.add(element);

            print(pattern);
          });
          return data;
        },
        itemBuilder: (context, Integrations suggestion) {
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
            style: FCITextStyle(color: primaryColor).normal18().copyWith(),
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),
                labelText: 'اختر الموديل من هنا',
                border: OutlineInputBorder()),
            textAlign: TextAlign.end,
            controller: _modelEditingController),
        onSuggestionSelected: (suggestion) {
          setState(() {
            _modelEditingController.text = suggestion.name;
            modelData = suggestion.name;
            searchResult = suggestion.tags.split(',').toList();
          });
          //setData();
          //   print(suggestion.name);
        },
      ),
    );
  }
}
