import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/Customers.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/style/FCITextStyles.dart';

class Summary extends StatefulWidget {
  Summary({Key key}) : super(key: key);

  @override
  _Summary createState() => _Summary();
}

class _Summary extends State<Summary> with TickerProviderStateMixin {
  CustomersReportData customersReportData;
  final List<Tab> reportTabs = <Tab>[
    new Tab(text: 'مبيعات'),
    new Tab(text: 'الدفع'),
    new Tab(text: 'الكمية'),
    new Tab(text: 'المرتجع'),
  ];
  int _selctedIndex = 0;

  /// TabController
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: reportTabs.length);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<GetProvider>(context, listen: false)
          .getCustomers()
          .then((value) {
        print(value.length);
      });
    });

    super.initState();
  }

  TextEditingController _customerEditingController = TextEditingController();
  CustomersData customerData;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<GetProvider>(context, listen: true);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          title: Center(
            child: Text(
              'summary'.tr(),
              textScaleFactor: 1.1,
              style: FCITextStyle(color: Colors.white).bold18(),
            ),
          ),
          actions: [
            Image.asset(
              "assets/images/white.png",
              fit: BoxFit.contain,
              height: ScreenUtil().setHeight(70),
              width: ScreenUtil().setHeight(70),
            ),
          ],
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.white,
              size: ScreenUtil().setSp(25),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            //  mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ///******************************
              Expanded(
                  child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        ///---------------------------------
                        ///select range of date
                        ///---------------------------------
                        Container(
                          width: size.width * 4 / 5,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "اختر التاريخ من",
                                style: FCITextStyle().normal16(),
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(5)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Color(0xfff1f1f1), width: 2),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(10)),
                                  child: InkWell(
                                      onTap: () {
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            minTime: DateTime(2020, 1, 1),
                                            maxTime: DateTime(2050, 12, 30),
                                            onChanged: (date) {},
                                            onConfirm: (date) {
                                          _startDate = date;
                                          setData();
                                        },
                                            currentTime: _startDate != null
                                                ? _startDate
                                                : DateTime.now(),
                                            locale: LocaleType.ar);
                                      },
                                      child: Text(
                                        DateFormat('yyyy-MM-dd')
                                            .format(_startDate)
                                            .toString(),
                                        style: FCITextStyle().normal16(),
                                      ))),
                              Text(
                                "الى",
                                style: FCITextStyle().normal16(),
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(5)),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Color(0xfff1f1f1), width: 2),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(10)),
                                  child: InkWell(
                                      onTap: () {
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            minTime: DateTime(2021, 1, 1),
                                            maxTime: DateTime(2050, 12, 30),
                                            onChanged: (date) {},
                                            onConfirm: (date) {
                                          _endDate = date;
                                          setData();
                                        },
                                            currentTime: _endDate != null
                                                ? _endDate
                                                : DateTime.now(),
                                            locale: LocaleType.ar);
                                      },
                                      child: Text(
                                        DateFormat('yyyy-MM-dd')
                                            .format(_endDate)
                                            .toString(),
                                        style: FCITextStyle().normal16(),
                                      )))
                            ],
                          ),
                        ),

                        ///---------------------------------
                        ///  select customer id
                        ///  -------------------------------
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(5)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Color(0xfff1f1f1), width: 2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(10)),
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: ScreenUtil().setHeight(50),
                          child: TypeAheadField<CustomersData>(
                            suggestionsCallback: (pattern) async {
                              List<CustomersData> data = [];
                              provider.customersData.forEach((element) {
                                if (element.name.contains(pattern))
                                  data.add(element);
                                print(pattern);
                              });
                              return data;
                            },
                            itemBuilder: (context, CustomersData suggestion) {
                              return ListTile(
                                title: Text(
                                  suggestion.name != null
                                      ? suggestion.name
                                      : '',
                                  style: FCITextStyle().bold16(),
                                ),
                                subtitle: Text(
                                  suggestion.phone != null
                                      ? '(${suggestion.phone})'
                                      : '',
                                  style: FCITextStyle(color: Colors.grey)
                                      .normal16(),
                                ),
                              );
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                                decoration: InputDecoration(
                                  hintText: 'اختر العميل',
                                ),
                                textAlign: TextAlign.center,
                                controller: _customerEditingController),
                            onSuggestionSelected: (suggestion) {
                              setState(() {
                                _customerEditingController.text =
                                    '';
                                customerData = suggestion;
                              });
                              setData();
                              print(suggestion.name);
                            },
                          ),
                        ),
                        Expanded(
                          child: Card(
                            shadowColor: Colors.grey,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(10),
                                right: ScreenUtil().setWidth(10),
                                bottom: ScreenUtil().setHeight(10)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///------------------------------
                                ///   Customer Data
                                ///------------------------------
                                headerRow(
                                    'company'.tr(),
                                    customerData != null
                                        ? customerData.company_name
                                        : ''),
                                headerRow(
                                    'address'.tr(),
                                    customerData != null
                                        ? customerData.address
                                        : ''),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    headerRow(
                                        'city'.tr(),
                                        customerData != null
                                            ? customerData.address
                                            : ''),
                                    headerRow(
                                        'phone'.tr(),
                                        customerData != null
                                            ? customerData.phone
                                            : ''),
                                  ],
                                ),

                                ///*******************************
                                customersReportData != null
                                    ? Container(
                                        height: size.height * 2 / 3,
                                        width: size.width,
                                        child: DefaultTabController(
                                          initialIndex: _selctedIndex,
                                          length: reportTabs.length,
                                          child: SizedBox(
                                            width: size.width,
                                            child: Column(
                                              children: <Widget>[
                                                ///------------------------------
                                                ///   Tapes
                                                ///------------------------------
                                                Stack(
                                                  fit: StackFit.passthrough,
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: [
                                                    ///------------------------------
                                                    ///   indicator
                                                    ///------------------------------
                                                    Container(
                                                      width: size.width,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors
                                                                  .grey[200],
                                                              width: 10),
                                                        ),
                                                      ),
                                                    ),

                                                    ///------------------------------
                                                    ///   Tabes
                                                    ///------------------------------
                                                    TabBar(
                                                      controller:
                                                          _tabController,
                                                      //  isScrollable: true,
                                                      labelColor: Colors.red,
                                                      unselectedLabelColor:
                                                          Colors.black,
                                                      unselectedLabelStyle:
                                                          FCITextStyle()
                                                              .normal16(),
                                                      labelStyle: FCITextStyle(
                                                              color:
                                                                  PrimaryColor)
                                                          .bold16(),
                                                      indicatorColor:
                                                          PrimaryColor,
                                                      // labelColor: getColors.red,
                                                      indicatorWeight: 10,
                                                      indicatorSize:
                                                          TabBarIndicatorSize
                                                              .tab,
                                                      onTap: (val) {
                                                        setState(() {
                                                          _selctedIndex = val;
                                                        });
                                                      },
                                                      // automaticIndicatorColorAdjustment: true,
                                                      tabs: List.generate(
                                                          reportTabs.length,
                                                          (index) {
                                                        return Container(
                                                            height: ScreenUtil()
                                                                .setHeight(35),
                                                            // width: size.width / 3,
                                                            alignment: Alignment
                                                                .center,
                                                            color: Colors.white,
                                                            child: FittedBox(
                                                              child: Text(
                                                                  '${reportTabs[index].text}'),
                                                            ));
                                                      }),
                                                    ),
                                                  ],
                                                ),

                                                ///------------------------------
                                                ///   Body of Tapes
                                                ///------------------------------
                                                Expanded(
                                                  child: TabBarView(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      controller:
                                                          _tabController,
                                                      children: [
                                                        ///------------------------------
                                                        ///   Sales
                                                        ///------------------------------
                                                        Column(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                              height:
                                                                  ScreenUtil()
                                                                      .setHeight(
                                                                          28),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            ScreenUtil().setWidth(7)),
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                    child: Text(
                                                                      'التاريخ',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            150),
                                                                    child: Text(
                                                                      'رقم المرجع',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
//                                                            Container(
//                                                              width: ScreenUtil().setWidth(150),
//                                                              child: Text(
//                                                                'المستودع',
//                                                                style: TextStyle(color: Colors.white),
//                                                              ),
//                                                            ),
//                                                            Container(
//                                                              width: ScreenUtil().setWidth(80),
//                                                              child: Text(
//                                                                'المنتج',
//                                                                style: TextStyle(color: Colors.white),
//                                                              ),
//                                                            ),

                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                    child: Text(
                                                                      'total'
                                                                          .tr(),
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                    child: Text(
                                                                      'الحالة',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              height:
                                                                  size.height /
                                                                      3,
                                                              child: customersReportData
                                                                          .sales
                                                                          .length >
                                                                      0
                                                                  ? ListView
                                                                      .builder(
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Container(
                                                                          margin:
                                                                              EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(7)),
                                                                          color:
                                                                              Colors.white,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7)),
                                                                                width: ScreenUtil().setWidth(80),
                                                                                child: Text(
                                                                                  customersReportData.sales[index].date,
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                width: ScreenUtil().setWidth(150),
                                                                                child: Text(
                                                                                  customersReportData.sales[index].reference_no.toString(),
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                width: ScreenUtil().setWidth(80),
                                                                                child: Text(
                                                                                  customersReportData.sales[index].price.toString(),
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                width: ScreenUtil().setWidth(80),
                                                                                child: Text(
                                                                                  customersReportData.sales[index].status == 1 ? 'Complete' : '',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount: customersReportData
                                                                          .sales
                                                                          .length,
                                                                    )
                                                                  : Center(
                                                                      child: Text(
                                                                          "لا توجد بيانات متوفرة")),
                                                            ),
                                                            getTotal(
                                                                Reports.Sales)
                                                          ],
                                                        ),

                                                        ///------------------------------
                                                        ///   Payment
                                                        ///------------------------------
                                                        Column(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                              height:
                                                                  ScreenUtil()
                                                                      .setHeight(
                                                                          28),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            ScreenUtil().setWidth(7)),
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                    child: Text(
                                                                      'التاريخ',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                    child: Text(
                                                                      'اشارة الدفع',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                    child: Text(
                                                                      'اشارة البيع',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                    child: Text(
                                                                      'الكمية',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                    child: Text(
                                                                      'طريقة الدفع',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              height:
                                                                  size.height /
                                                                      3,
                                                              child: customersReportData
                                                                          .payments
                                                                          .length >
                                                                      0
                                                                  ? ListView
                                                                      .builder(
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Container(
                                                                          margin:
                                                                              EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(7)),
                                                                          color:
                                                                              Colors.white,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7)),
                                                                                width: ScreenUtil().setWidth(80),
                                                                                child: Text(
                                                                                  customersReportData.payments[index].date ?? '',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                width: ScreenUtil().setWidth(80),
                                                                                child: Text(
                                                                                  customersReportData.payments[index].sale_reference.toString() ?? '',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                width: ScreenUtil().setWidth(80),
                                                                                child: Text(
                                                                                  customersReportData.payments[index].payment_reference.toString() ?? '',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                width: ScreenUtil().setWidth(80),
                                                                                child: Text(
                                                                                  customersReportData.payments[index].amount.toString() ?? '',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                width: ScreenUtil().setWidth(80),
                                                                                child: Text(
                                                                                  customersReportData.payments[index].paying_method ?? '',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount: customersReportData
                                                                          .payments
                                                                          .length,
                                                                    )
                                                                  : Center(
                                                                      child: Text(
                                                                          "لا توجد بيانات متوفرة")),
                                                            )
                                                          ],
                                                        ),

                                                        ///------------------------------
                                                        ///   Quotations
                                                        ///------------------------------
                                                        Column(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                              height:
                                                                  ScreenUtil()
                                                                      .setHeight(
                                                                          28),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            ScreenUtil().setWidth(7)),
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            90),
                                                                    child: Text(
                                                                      'التاريخ',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            140),
                                                                    child: Text(
                                                                      'رقم المرجع',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                    child: Text(
                                                                      'السعر',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                    child: Text(
                                                                      'الحالة',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              height:
                                                                  size.height /
                                                                      3,
                                                              child: customersReportData
                                                                          .quotations
                                                                          .length >
                                                                      0
                                                                  ? ListView
                                                                      .builder(
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Container(
                                                                          margin:
                                                                              EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(7)),
                                                                          color:
                                                                              Colors.white,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7)),
                                                                                width: ScreenUtil().setWidth(90),
                                                                                child: Text(
                                                                                  customersReportData.quotations[index].date ?? '',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                width: ScreenUtil().setWidth(140),
                                                                                child: Text(
                                                                                  customersReportData.quotations[index].reference_no.toString() ?? '',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                width: ScreenUtil().setWidth(80),
                                                                                child: Text(
                                                                                  customersReportData.quotations[index].price.toString() ?? '',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                width: ScreenUtil().setWidth(80),
                                                                                child: Text(
                                                                                  customersReportData.quotations[index].quotation_status.toString() ?? '',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount: customersReportData
                                                                          .quotations
                                                                          .length,
                                                                    )
                                                                  : Center(
                                                                      child: Text(
                                                                          "لا توجد بيانات متوفرة")),
                                                            ),
                                                            getTotal(Reports
                                                                .Quotations)
                                                          ],
                                                        ),

                                                        ///------------------------------
                                                        ///   Returns
                                                        ///------------------------------
                                                        Column(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                              height:
                                                                  ScreenUtil()
                                                                      .setHeight(
                                                                          28),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            ScreenUtil().setWidth(7)),
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            90),
                                                                    child: Text(
                                                                      'التاريخ',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            140),
                                                                    child: Text(
                                                                      'رقم المرجع',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                    child: Text(
                                                                      'السعر',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: ScreenUtil()
                                                                        .setWidth(
                                                                            80),
                                                                    child: Text(
                                                                      'الفاتورة',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              height:
                                                                  size.height /
                                                                      3,
                                                              child: customersReportData
                                                                          .returns
                                                                          .length >
                                                                      0
                                                                  ? ListView
                                                                      .builder(
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Container(
                                                                          margin:
                                                                              EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(7)),
                                                                          color:
                                                                              Colors.white,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7)),
                                                                                width: ScreenUtil().setWidth(90),
                                                                                child: Text(
                                                                                  customersReportData.returns[index].date ?? '',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                width: ScreenUtil().setWidth(140),
                                                                                child: Text(
                                                                                  customersReportData.returns[index].reference_no.toString() ?? '',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                width: ScreenUtil().setWidth(80),
                                                                                child: Text(
                                                                                  customersReportData.returns[index].total_price.toString() ?? '',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                width: ScreenUtil().setWidth(80),
                                                                                child: Text(
                                                                                  customersReportData.returns[index].biller.toString() ?? '',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount: customersReportData
                                                                          .returns
                                                                          .length,
                                                                    )
                                                                  : Center(
                                                                      child: Text(
                                                                          "لا توجد بيانات متوفرة")),
                                                            ),
                                                            getTotal(
                                                                Reports.Returns)
                                                          ],
                                                        ),
                                                      ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Text("لا توجد بيانات متوفرة"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
            ],
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

  Widget getTotal(Reports reports) {
    String price = '';
    String tax = '';
    String discount = '';
    String total = '';
    switch (reports) {
      case Reports.Sales:
        price = customersReportData != null
            ? customersReportData.totalPriceSales.toString()
            : '0';
        tax = customersReportData != null
            ? customersReportData.totalTaxSales.toString()
            : '0';
        discount = customersReportData != null
            ? customersReportData.totalDiscountSales.toString()
            : '0';
        total = customersReportData != null
            ? (customersReportData.totalTaxSales +
                    customersReportData.totalPriceSales -
                    customersReportData.totalDiscountSales)
                .toString()
            : '0';
        break;
      case Reports.Payment:
        break;
      case Reports.Quotations:
        price = customersReportData != null
            ? customersReportData.totalPriceQuotations.toString()
            : '0';
        tax = customersReportData != null
            ? customersReportData.totalTaxQuotations.toString()
            : '0';
        discount = customersReportData != null
            ? customersReportData.totalDiscountQuotations.toString()
            : '0';
        total = customersReportData != null
            ? (customersReportData.totalTaxQuotations +
                    customersReportData.totalPriceQuotations -
                    customersReportData.totalDiscountQuotations)
                .toString()
            : '0';
        break;
      case Reports.Returns:
        // TODO: Handle this case.
        break;
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: Container()),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('total.sub'.tr(),
                                  style: TextStyle(color: Colors.black54)),
                              Text(
                                price,
                                style: TextStyle(color: Colors.black54),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Commission.account'.tr(),
                                  style: TextStyle(color: Colors.black54)),
                              Text(
                                tax,
                                style: TextStyle(color: Colors.black54),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('discount'.tr(),
                                  style: TextStyle(color: Colors.black54)),
                              Text(
                                discount,
                                style: TextStyle(color: Colors.black54),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(10)),
                      child: Row(
                        children: [
                          Text('total'.tr(), style: FCITextStyle().bold16()),
                          Expanded(
                              child: SizedBox(
                            width: ScreenUtil().setWidth(25),
                          )),
                          Text(
                            total,
                            style: FCITextStyle().bold16(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  setData() async {
    Map<String, dynamic> data = {
      "customer_id": "1",
      "start_date": "2020-01-01",
      "end_date": "2021-08-06",
      "sales": [
        {
          "id": 290,
          "reference_no": "sr-20210524-071512",
          "user_id": 1,
          "cash_register_id": 3,
          "customer_id": 1,
          "warehouse_id": 1,
          "biller_id": 1,
          "item": 1,
          "total_qty": 1,
          "total_discount": 0,
          "total_tax": 0,
          "total_price": 120,
          "grand_total": 120,
          "order_tax_rate": 0,
          "order_tax": 0,
          "order_discount": 0,
          "coupon_id": null,
          "coupon_discount": null,
          "shipping_cost": 0,
          "sale_status": 1,
          "payment_status": 4,
          "document": null,
          "paid_amount": 120,
          "sale_note": null,
          "staff_note": null,
          "created_at": "2021-05-24 13:15:12",
          "updated_at": "2021-05-24 13:46:47",
          "warehouse": {
            "id": 1,
            "name": "warehouse 1",
            "phone": "2312121",
            "email": "war1@lion.com",
            "address": "khatungonj, chittagong",
            "is_active": 1,
            "created_at": "2018-05-12 07:51:44",
            "updated_at": "2019-03-02 15:40:17"
          }
        },
        {
          "id": 282,
          "reference_no": "sr-20210318-054729",
          "user_id": 1,
          "cash_register_id": 3,
          "customer_id": 1,
          "warehouse_id": 2,
          "biller_id": 1,
          "item": 1,
          "total_qty": 1,
          "total_discount": 0,
          "total_tax": 0,
          "total_price": 2,
          "grand_total": 2,
          "order_tax_rate": 0,
          "order_tax": 0,
          "order_discount": 0,
          "coupon_id": null,
          "coupon_discount": null,
          "shipping_cost": 0,
          "sale_status": 1,
          "payment_status": 2,
          "document": null,
          "paid_amount": null,
          "sale_note": null,
          "staff_note": null,
          "created_at": "2021-03-17 23:47:29",
          "updated_at": "2021-03-20 04:59:57",
          "warehouse": {
            "id": 2,
            "name": "warehouse 2",
            "phone": "1234",
            "email": null,
            "address": "boropul, chittagong",
            "is_active": 1,
            "created_at": "2018-05-12 08:09:03",
            "updated_at": "2018-06-19 22:30:38"
          }
        },
        {
          "id": 280,
          "reference_no": "sr-20210317-041411",
          "user_id": 1,
          "cash_register_id": 3,
          "customer_id": 1,
          "warehouse_id": 1,
          "biller_id": 1,
          "item": 1,
          "total_qty": 1,
          "total_discount": 0,
          "total_tax": 0,
          "total_price": 2,
          "grand_total": 2,
          "order_tax_rate": 0,
          "order_tax": 0,
          "order_discount": null,
          "coupon_id": null,
          "coupon_discount": null,
          "shipping_cost": null,
          "sale_status": 1,
          "payment_status": 1,
          "document": null,
          "paid_amount": null,
          "sale_note": null,
          "staff_note": null,
          "created_at": "2021-03-16 22:14:11",
          "updated_at": "2021-03-16 22:14:11",
          "warehouse": {
            "id": 1,
            "name": "warehouse 1",
            "phone": "2312121",
            "email": "war1@lion.com",
            "address": "khatungonj, chittagong",
            "is_active": 1,
            "created_at": "2018-05-12 07:51:44",
            "updated_at": "2019-03-02 15:40:17"
          }
        },
        {
          "id": 279,
          "reference_no": "sr-20210311-014034",
          "user_id": 1,
          "cash_register_id": 3,
          "customer_id": 1,
          "warehouse_id": 1,
          "biller_id": 1,
          "item": 1,
          "total_qty": 2,
          "total_discount": 0,
          "total_tax": 0,
          "total_price": 4,
          "grand_total": 4,
          "order_tax_rate": 0,
          "order_tax": 0,
          "order_discount": null,
          "coupon_id": null,
          "coupon_discount": null,
          "shipping_cost": null,
          "sale_status": 1,
          "payment_status": 1,
          "document": null,
          "paid_amount": null,
          "sale_note": null,
          "staff_note": null,
          "created_at": "2021-03-11 07:40:34",
          "updated_at": "2021-03-11 07:40:34",
          "warehouse": {
            "id": 1,
            "name": "warehouse 1",
            "phone": "2312121",
            "email": "war1@lion.com",
            "address": "khatungonj, chittagong",
            "is_active": 1,
            "created_at": "2018-05-12 07:51:44",
            "updated_at": "2019-03-02 15:40:17"
          }
        },
        {
          "id": 270,
          "reference_no": "sr-20210111-014535",
          "user_id": 1,
          "cash_register_id": 3,
          "customer_id": 1,
          "warehouse_id": 1,
          "biller_id": 1,
          "item": 2,
          "total_qty": 2,
          "total_discount": 0,
          "total_tax": 137.57,
          "total_price": 1388,
          "grand_total": 1388,
          "order_tax_rate": 0,
          "order_tax": 0,
          "order_discount": 0,
          "coupon_id": null,
          "coupon_discount": null,
          "shipping_cost": 0,
          "sale_status": 1,
          "payment_status": 2,
          "document": null,
          "paid_amount": null,
          "sale_note": null,
          "staff_note": null,
          "created_at": "2021-01-11 07:45:35",
          "updated_at": "2021-01-11 07:58:44",
          "warehouse": {
            "id": 1,
            "name": "warehouse 1",
            "phone": "2312121",
            "email": "war1@lion.com",
            "address": "khatungonj, chittagong",
            "is_active": 1,
            "created_at": "2018-05-12 07:51:44",
            "updated_at": "2019-03-02 15:40:17"
          }
        },
        {
          "id": 262,
          "reference_no": "1111",
          "user_id": 1,
          "cash_register_id": 3,
          "customer_id": 1,
          "warehouse_id": 1,
          "biller_id": 1,
          "item": 1,
          "total_qty": 2,
          "total_discount": 0,
          "total_tax": 3000,
          "total_price": 23000,
          "grand_total": 23000,
          "order_tax_rate": 0,
          "order_tax": 0,
          "order_discount": 0,
          "coupon_id": null,
          "coupon_discount": null,
          "shipping_cost": 0,
          "sale_status": 1,
          "payment_status": 1,
          "document": null,
          "paid_amount": null,
          "sale_note": null,
          "staff_note": null,
          "created_at": "2020-11-28 23:21:30",
          "updated_at": "2020-11-28 23:21:30",
          "warehouse": {
            "id": 1,
            "name": "warehouse 1",
            "phone": "2312121",
            "email": "war1@lion.com",
            "address": "khatungonj, chittagong",
            "is_active": 1,
            "created_at": "2018-05-12 07:51:44",
            "updated_at": "2019-03-02 15:40:17"
          }
        },
        {
          "id": 231,
          "reference_no": "sr-20201018-111333",
          "user_id": 9,
          "cash_register_id": 2,
          "customer_id": 1,
          "warehouse_id": 1,
          "biller_id": 5,
          "item": 1,
          "total_qty": 1,
          "total_discount": 0,
          "total_tax": 40,
          "total_price": 440,
          "grand_total": 440,
          "order_tax_rate": 0,
          "order_tax": 0,
          "order_discount": null,
          "coupon_id": null,
          "coupon_discount": null,
          "shipping_cost": null,
          "sale_status": 1,
          "payment_status": 2,
          "document": null,
          "paid_amount": 250,
          "sale_note": null,
          "staff_note": null,
          "created_at": "2020-10-18 05:13:33",
          "updated_at": "2020-10-18 05:17:24",
          "warehouse": {
            "id": 1,
            "name": "warehouse 1",
            "phone": "2312121",
            "email": "war1@lion.com",
            "address": "khatungonj, chittagong",
            "is_active": 1,
            "created_at": "2018-05-12 07:51:44",
            "updated_at": "2019-03-02 15:40:17"
          }
        },
        {
          "id": 224,
          "reference_no": "sr-20200826-080139",
          "user_id": 1,
          "cash_register_id": null,
          "customer_id": 1,
          "warehouse_id": 1,
          "biller_id": 1,
          "item": 1,
          "total_qty": 3,
          "total_discount": 30,
          "total_tax": 117,
          "total_price": 1287,
          "grand_total": 1287,
          "order_tax_rate": 0,
          "order_tax": 0,
          "order_discount": null,
          "coupon_id": null,
          "coupon_discount": null,
          "shipping_cost": null,
          "sale_status": 1,
          "payment_status": 1,
          "document": null,
          "paid_amount": null,
          "sale_note": null,
          "staff_note": null,
          "created_at": "2020-08-26 14:01:39",
          "updated_at": "2020-08-26 14:01:39",
          "warehouse": {
            "id": 1,
            "name": "warehouse 1",
            "phone": "2312121",
            "email": "war1@lion.com",
            "address": "khatungonj, chittagong",
            "is_active": 1,
            "created_at": "2018-05-12 07:51:44",
            "updated_at": "2019-03-02 15:40:17"
          }
        },
        {
          "id": 206,
          "reference_no": "sr-20200311-045230",
          "user_id": 1,
          "cash_register_id": null,
          "customer_id": 1,
          "warehouse_id": 1,
          "biller_id": 1,
          "item": 1,
          "total_qty": 1,
          "total_discount": 0,
          "total_tax": 0,
          "total_price": 120,
          "grand_total": 120,
          "order_tax_rate": 0,
          "order_tax": 0,
          "order_discount": 0,
          "coupon_id": null,
          "coupon_discount": null,
          "shipping_cost": 0,
          "sale_status": 1,
          "payment_status": 2,
          "document": null,
          "paid_amount": null,
          "sale_note": null,
          "staff_note": null,
          "created_at": "2020-03-11 10:52:30",
          "updated_at": "2020-03-11 10:54:04",
          "warehouse": {
            "id": 1,
            "name": "warehouse 1",
            "phone": "2312121",
            "email": "war1@lion.com",
            "address": "khatungonj, chittagong",
            "is_active": 1,
            "created_at": "2018-05-12 07:51:44",
            "updated_at": "2019-03-02 15:40:17"
          }
        }
      ],
      "payments": [
        {
          "id": 339,
          "payment_reference": "spr-20210524-074647",
          "user_id": 1,
          "purchase_id": null,
          "sale_id": 290,
          "cash_register_id": 3,
          "account_id": 1,
          "amount": -130,
          "change": 0,
          "paying_method": "Cash",
          "payment_note": null,
          "created_at": "2021-05-24 13:46:47",
          "updated_at": "2021-05-24 13:46:47",
          "sale_reference": "sr-20210524-071512"
        },
        {
          "id": 338,
          "payment_reference": "spr-20210524-074506",
          "user_id": 1,
          "purchase_id": null,
          "sale_id": 290,
          "cash_register_id": 3,
          "account_id": 1,
          "amount": 250,
          "change": 0,
          "paying_method": "Cash",
          "payment_note": null,
          "created_at": "2021-05-24 13:45:06",
          "updated_at": "2021-05-24 13:45:06",
          "sale_reference": "sr-20210524-071512"
        },
        {
          "id": 295,
          "payment_reference": "spr-20201018-111724",
          "user_id": 9,
          "purchase_id": null,
          "sale_id": 231,
          "cash_register_id": 2,
          "account_id": 1,
          "amount": 50,
          "change": 0,
          "paying_method": "Cheque",
          "payment_note": null,
          "created_at": "2020-10-18 05:17:24",
          "updated_at": "2020-10-18 05:17:24",
          "sale_reference": "sr-20201018-111333"
        },
        {
          "id": 294,
          "payment_reference": "spr-20201018-111651",
          "user_id": 9,
          "purchase_id": null,
          "sale_id": 231,
          "cash_register_id": 2,
          "account_id": 1,
          "amount": 50,
          "change": 0,
          "paying_method": "Credit Card",
          "payment_note": null,
          "created_at": "2020-10-18 05:16:51",
          "updated_at": "2020-10-18 05:16:51",
          "sale_reference": "sr-20201018-111333"
        },
        {
          "id": 293,
          "payment_reference": "spr-20201018-111426",
          "user_id": 9,
          "purchase_id": null,
          "sale_id": 231,
          "cash_register_id": 2,
          "account_id": 1,
          "amount": 50,
          "change": 0,
          "paying_method": "Gift Card",
          "payment_note": null,
          "created_at": "2020-10-18 05:14:26",
          "updated_at": "2020-10-18 05:14:26",
          "sale_reference": "sr-20201018-111333"
        },
        {
          "id": 292,
          "payment_reference": "spr-20201018-111333",
          "user_id": 9,
          "purchase_id": null,
          "sale_id": 231,
          "cash_register_id": 2,
          "account_id": 1,
          "amount": 100,
          "change": 0,
          "paying_method": "Cash",
          "payment_note": null,
          "created_at": "2020-10-18 05:13:33",
          "updated_at": "2020-10-18 05:13:33",
          "sale_reference": "sr-20201018-111333"
        }
      ],
      "quotations": [
        {
          "id": 11,
          "reference_no": "qr-20201024-090814",
          "user_id": 1,
          "biller_id": 1,
          "supplier_id": null,
          "customer_id": 1,
          "warehouse_id": 1,
          "item": 1,
          "total_qty": 2,
          "total_discount": 0,
          "total_tax": 3000,
          "total_price": 23000,
          "order_tax_rate": 0,
          "order_tax": 0,
          "order_discount": 0,
          "shipping_cost": 0,
          "grand_total": 23000,
          "quotation_status": 1,
          "document": null,
          "note": null,
          "created_at": "2020-10-24 03:08:14",
          "updated_at": "2020-10-24 03:28:35",
          "warehouse": {
            "id": 1,
            "name": "warehouse 1",
            "phone": "2312121",
            "email": "war1@lion.com",
            "address": "khatungonj, chittagong",
            "is_active": 1,
            "created_at": "2018-05-12 07:51:44",
            "updated_at": "2019-03-02 15:40:17"
          }
        }
      ],
      "returns": [
        {
          "id": 25,
          "reference_no": "rr-20210524-073950",
          "user_id": 1,
          "cash_register_id": 3,
          "customer_id": 1,
          "warehouse_id": 1,
          "biller_id": 1,
          "account_id": 1,
          "item": 1,
          "total_qty": 1,
          "total_discount": 0,
          "total_tax": 0,
          "total_price": 2,
          "order_tax_rate": 0,
          "order_tax": 0,
          "grand_total": 2,
          "document": null,
          "return_note": null,
          "staff_note": null,
          "created_at": "2021-05-24 13:39:50",
          "updated_at": "2021-05-24 13:39:50",
          "warehouse": {
            "id": 1,
            "name": "warehouse 1",
            "phone": "2312121",
            "email": "war1@lion.com",
            "address": "khatungonj, chittagong",
            "is_active": 1,
            "created_at": "2018-05-12 07:51:44",
            "updated_at": "2019-03-02 15:40:17"
          },
          "biller": {
            "id": 1,
            "name": "yousuf",
            "image": "aks.jpg",
            "company_name": "aks",
            "vat_number": "31123",
            "email": "yousuf@kds.com",
            "phone_number": "442343324",
            "address": "halishahar",
            "city": "chittagong",
            "state": null,
            "postal_code": null,
            "country": "sdgs",
            "is_active": 1,
            "created_at": "2018-05-12 21:49:30",
            "updated_at": "2019-03-02 05:20:38"
          }
        },
        {
          "id": 18,
          "reference_no": "rr-20201118-070218",
          "user_id": 1,
          "cash_register_id": 4,
          "customer_id": 1,
          "warehouse_id": 2,
          "biller_id": 1,
          "account_id": 1,
          "item": 1,
          "total_qty": 1,
          "total_discount": 0,
          "total_tax": 1500,
          "total_price": 11500,
          "order_tax_rate": 0,
          "order_tax": 0,
          "grand_total": 11500,
          "document": null,
          "return_note": null,
          "staff_note": null,
          "created_at": "2020-11-18 01:02:18",
          "updated_at": "2020-11-18 01:02:18",
          "warehouse": {
            "id": 2,
            "name": "warehouse 2",
            "phone": "1234",
            "email": null,
            "address": "boropul, chittagong",
            "is_active": 1,
            "created_at": "2018-05-12 08:09:03",
            "updated_at": "2018-06-19 22:30:38"
          },
          "biller": {
            "id": 1,
            "name": "yousuf",
            "image": "aks.jpg",
            "company_name": "aks",
            "vat_number": "31123",
            "email": "yousuf@kds.com",
            "phone_number": "442343324",
            "address": "halishahar",
            "city": "chittagong",
            "state": null,
            "postal_code": null,
            "country": "sdgs",
            "is_active": 1,
            "created_at": "2018-05-12 21:49:30",
            "updated_at": "2019-03-02 05:20:38"
          }
        },
        {
          "id": 14,
          "reference_no": "rr-20201013-053954",
          "user_id": 9,
          "cash_register_id": 1,
          "customer_id": 1,
          "warehouse_id": 1,
          "biller_id": 1,
          "account_id": 1,
          "item": 1,
          "total_qty": 1,
          "total_discount": 0,
          "total_tax": 40,
          "total_price": 440,
          "order_tax_rate": 0,
          "order_tax": 0,
          "grand_total": 440,
          "document": null,
          "return_note": null,
          "staff_note": null,
          "created_at": "2020-10-13 11:39:54",
          "updated_at": "2020-10-13 11:39:54",
          "warehouse": {
            "id": 1,
            "name": "warehouse 1",
            "phone": "2312121",
            "email": "war1@lion.com",
            "address": "khatungonj, chittagong",
            "is_active": 1,
            "created_at": "2018-05-12 07:51:44",
            "updated_at": "2019-03-02 15:40:17"
          },
          "biller": {
            "id": 1,
            "name": "yousuf",
            "image": "aks.jpg",
            "company_name": "aks",
            "vat_number": "31123",
            "email": "yousuf@kds.com",
            "phone_number": "442343324",
            "address": "halishahar",
            "city": "chittagong",
            "state": null,
            "postal_code": null,
            "country": "sdgs",
            "is_active": 1,
            "created_at": "2018-05-12 21:49:30",
            "updated_at": "2019-03-02 05:20:38"
          }
        },
        {
          "id": 13,
          "reference_no": "rr-20200816-102502",
          "user_id": 1,
          "cash_register_id": null,
          "customer_id": 1,
          "warehouse_id": 2,
          "biller_id": 2,
          "account_id": 1,
          "item": 1,
          "total_qty": 1,
          "total_discount": 0,
          "total_tax": 1500,
          "total_price": 11500,
          "order_tax_rate": 0,
          "order_tax": 0,
          "grand_total": 11500,
          "document": null,
          "return_note": null,
          "staff_note": null,
          "created_at": "2020-08-16 16:25:02",
          "updated_at": "2020-08-16 16:25:02",
          "warehouse": {
            "id": 2,
            "name": "warehouse 2",
            "phone": "1234",
            "email": null,
            "address": "boropul, chittagong",
            "is_active": 1,
            "created_at": "2018-05-12 08:09:03",
            "updated_at": "2018-06-19 22:30:38"
          },
          "biller": {
            "id": 2,
            "name": "tariq",
            "image": null,
            "company_name": "big tree",
            "vat_number": null,
            "email": "tariq@bigtree.com",
            "phone_number": "321312",
            "address": "khulshi",
            "city": "chittagong",
            "state": null,
            "postal_code": null,
            "country": null,
            "is_active": 1,
            "created_at": "2018-05-12 21:57:54",
            "updated_at": "2018-06-15 00:07:11"
          }
        }
      ]
    };
    print({
      "customerData.id": customerData != null ? customerData.id : '',
      "_startDate": _startDate,
      "_endDate": _endDate
    });
    if (customerData != null) {
      await Provider.of<GetProvider>(context, listen: false)
          .getCustomersReports(
              customerData.id,
              DateFormat('yyyy-MM-dd').format(_startDate).toString(),
              DateFormat('yyyy-MM-dd').format(_endDate).toString())
          .then((value) {
        setState(() {
          customersReportData = value;
        });
      });
//    customersReportData=CustomersReportData.fromJson(data);
//    print("Count ${customersReportData.quotations.length}");
    }
  }

  Widget headerRow(String title, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
      child: Row(
        children: [
          Text(
            title,
            style: FCITextStyle(color: Colors.black54).bold13(),
          ),
          SizedBox(
            width: 20,
          ),
          Text(text)
        ],
      ),
    );
  }
}

enum Reports { Sales, Payment, Quotations, Returns }
