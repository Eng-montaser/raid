import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/model/NewModels.dart';
import 'package:raid/model/ProductReportData.dart';
import 'package:raid/model/UserData.dart';
import 'package:raid/provider/AuthProvider.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/widget/rounded_input_field.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../constants.dart';

class ProductReport extends StatefulWidget {
  /// Creates the home page.

  @override
  _ProductReportState createState() => _ProductReportState();
}

class _ProductReportState extends State<ProductReport> {
  List<ProductReportData> temp;
  ProductReportDataList _productReportsDataList;
  ProductReportDataSource _productReportDataSource;
  List<WarehousesData> _warehousesDataList;
  UserData userData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userData =
          await Provider.of<AuthProvider>(context, listen: false).userData;
      await Provider.of<GetProvider>(context, listen: false)
          .getWarehousesData()
          .then((value) {
        value.forEach((element) {
          print(element.wId);
        });
        setState(() {
          _warehousesDataList = value;
        });
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<GetProvider>(context, listen: false)
          .getStocksReports(
              DateFormat('yyyy-MM-dd').format(_startDate).toString(),
              DateFormat('yyyy-MM-dd').format(_endDate).toString(),
              1,
              _warehouse.wId)
          .then((value) {
        setState(() {
          _productReportsDataList = value;
          populateData();
        });
      });
    });
//    _searchController.addListener(() {
//      if(temp!=null)
//      _productReportsDataList.productReportDataList = temp
//          .where((element) => element.name.contains(_searchController.text))
//          .toList();
//    });
//    populateData();
  }

  ScrollController _scrollController;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  WarehousesData _warehouse = new WarehousesData(name: 'الكل', wId: 1);
  TextEditingController _searchController = new TextEditingController(text: '');
  bool _loadMoreLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: Center(
          child: Text(
            'رصيد مستودع',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///---------------------------------
            ///      Search
            ///---------------------------------
            Container(
              margin:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
              child: CustomTextInput(
                controller: _searchController,
                hintText: 'search'.tr(),
                leading: Icons.filter_alt_sharp,
                suffixicon: Icon(Icons.keyboard_arrow_down_sharp),
              ),
            ),

            ///---------------------------------
            ///      select range of date
            ///---------------------------------
            Container(
              padding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(2)),
              width: size.width * 4 / 5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "اختر التاريخ من",
                    style: FCITextStyle().normal16(),
                  ),
                  InkWell(
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2020, 1, 1),
                          maxTime: DateTime(2050, 12, 30),
                          onChanged: (date) {}, onConfirm: (date) async {
                        _startDate = date;
                        setData();
                      },
                          currentTime:
                              _startDate != null ? _startDate : DateTime.now(),
                          locale: LocaleType.ar);
                    },
                    child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(2)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Color(0xfff1f1f1), width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10)),
                        child: Text(
                          DateFormat('yyyy-MM-dd')
                              .format(_startDate)
                              .toString(),
                          style: FCITextStyle().normal16(),
                        )),
                  ),
                  Text(
                    "الى",
                    style: FCITextStyle().normal16(),
                  ),
                  InkWell(
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2021, 1, 1),
                          maxTime: DateTime(2050, 12, 30),
                          onChanged: (date) {}, onConfirm: (date) async {
                        _endDate = date;
                        setData();
                      },
                          currentTime:
                              _endDate != null ? _endDate : DateTime.now(),
                          locale: LocaleType.ar);
                    },
                    child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(2)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Color(0xfff1f1f1), width: 2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10)),
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(_endDate).toString(),
                          style: FCITextStyle().normal16(),
                        )),
                  )
                ],
              ),
            ),

            ///---------------------------------
            ///      WarHouse
            ///---------------------------------
            if (userData?.role_id == 1)
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(3)),
                width: size.width * 4 / 5,
                child: Row(
                  children: [
                    Text(
                      "اختر المستودع ",
                      style: FCITextStyle().normal16(),
                    ),
                    InkWell(
                      onTap: () {
                        modalBottomSheetMenu(
                            context: context,
                            data: _warehousesDataList,
                            vacationName: (name) {
                              setState(() {
                                _warehouse.name = name;
                              });
                            },
                            vacationId: (mall_id) {
                              setState(() {
                                _warehouse.wId = mall_id;
                              });
                              setData();
                            });
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(3),
                              horizontal: ScreenUtil().setWidth(5)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Color(0xfff1f1f1), width: 2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(10)),
                          width: ScreenUtil().setWidth(250),
                          alignment: Alignment.center,
                          child: Text(
                            _warehouse.name,
                            style: FCITextStyle(color: Colors.black).normal16(),
                          )),
                    ),
                  ],
                ),
              ),

            ///---------------------------------
            ///      Table of date
            ///---------------------------------
//          _productReportsDataList==null? loadingTow(70):  Text(_test),
            Container(
                height: size.height * 0.65,
                width: size.width,
                alignment: Alignment.center,
                child: _productReportsDataList != null
                    ? _productReportsDataList.productReportDataList.length != 0
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(5)),
                            child: SfDataGrid(
                              verticalScrollController: _scrollController,
                              source: _productReportDataSource,
                              columnWidthMode: ColumnWidthMode.auto,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              rowHeight: ScreenUtil().setWidth(50),
//                    headerCellBuilder: (contex, column) {
//                      return Center(
//                        child: Container(
//                          width: double.infinity,
//                          decoration:
//                          BoxDecoration(color: primaryColor),
//                          child: Center(
//                            child: Text(
//                              '${column.headerText}',
//                              style: FCITextStyle(color: Colors.white)
//                                  .bold14(),
//                            ),
//                          ),
//                        ),
//                      );
//                    },
                              columns: <GridColumn>[
                                GridTextColumn(
                                    columnName: 'id',
                                    label: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        color: primaryColor,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'م',
                                          style:
                                              FCITextStyle(color: Colors.white)
                                                  .bold16(),
                                        ))),
                                GridTextColumn(
                                    columnName: 'name',
                                    label: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        color: primaryColor,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'اسم المنتج',
                                          style:
                                              FCITextStyle(color: Colors.white)
                                                  .bold16(),
                                        ))),
                                GridTextColumn(
                                    columnName: 'purchased_amount',
                                    label: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        color: primaryColor,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'المبلغ المشترى',
                                          style:
                                              FCITextStyle(color: Colors.white)
                                                  .bold16(),
                                        ))),
                                GridTextColumn(
                                    columnName: 'purchased_qty',
                                    label: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        color: primaryColor,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'الكمية المشتراة',
                                          style:
                                              FCITextStyle(color: Colors.white)
                                                  .bold16(),
                                        ))),
                                GridTextColumn(
                                    columnName: 'sold_amount',
                                    label: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        color: primaryColor,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'المبلغ المباع',
                                          style:
                                              FCITextStyle(color: Colors.white)
                                                  .bold16(),
                                        ))),
                                GridTextColumn(
                                    columnName: 'sold_qty',
                                    label: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        color: primaryColor,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'الكمبة المباعة',
                                          style:
                                              FCITextStyle(color: Colors.white)
                                                  .bold16(),
                                        ))),
                                GridTextColumn(
                                    columnName: 'returned_amount',
                                    label: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        color: primaryColor,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'المبلغ المرتجع',
                                          style:
                                              FCITextStyle(color: Colors.white)
                                                  .bold16(),
                                        ))),
                                GridTextColumn(
                                    columnName: 'returned_qty',
                                    label: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        color: primaryColor,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'الكمبة المرتجعة',
                                          style:
                                              FCITextStyle(color: Colors.white)
                                                  .bold16(),
                                        ))),
                                GridTextColumn(
                                    columnName: 'purchase_returned_amount',
                                    label: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        color: primaryColor,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'المبلغ المشترى المرتجع',
                                          style:
                                              FCITextStyle(color: Colors.white)
                                                  .bold16(),
                                        ))),
                                GridTextColumn(
                                    columnName: 'purchase_returned_qty',
                                    label: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        color: primaryColor,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'الكمية المشتراه المرتجعه',
                                          style:
                                              FCITextStyle(color: Colors.white)
                                                  .bold16(),
                                        ))),
                                GridTextColumn(
                                    columnName: 'profit',
                                    label: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        color: primaryColor,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'ربح',
                                          style:
                                              FCITextStyle(color: Colors.white)
                                                  .bold16(),
                                        ))),
                                GridTextColumn(
                                    columnName: 'in_stock',
                                    label: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        color: primaryColor,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'المخزن',
                                          style:
                                              FCITextStyle(color: Colors.white)
                                                  .bold16(),
                                        ))),
                              ],
                            ),
                          )
                        : Text(
                            'لا يوجد بيانات',
                            style: FCITextStyle().normal18(),
                          )
                    : loadingTow(70)),
            if (_productReportsDataList !=
                null) //&& _productReportsDataList.productReportDataList.length<_productReportsDataList.total)
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "عدد ${_productReportsDataList.lastItem}",
                      style: FCITextStyle().normal16(),
                    ),
                    Text(
                      "من اجمالى ${_productReportsDataList.total}",
                      style: FCITextStyle().normal16(),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(5),
                    ),
                    _loadMoreLoading
                        ? loadingTow(25)
                        : _productReportsDataList.productReportDataList.length <
                                _productReportsDataList.total
                            ? FlatButton(
                                child: Text(
                                  "التالى",
                                  style: FCITextStyle(color: Colors.blue)
                                      .normal16(),
                                ),
                                onPressed: () {
                                  loadMoreData();
                                },
                              )
                            : Container(),
                  ],
                ),
              ),
//              Container(
//              height: 15,
//              child: SfDataPager(
//                delegate: _productReportDataSource,
//                pageCount: _productReportsData.length/3,
//                direction: Axis.horizontal,
//              ),
//            )
          ],
        ),
      ),
    );
  }

  populateData() {
    _scrollController = new ScrollController();

    setState(() {
      _productReportDataSource = ProductReportDataSource(
          productData: _productReportsDataList.productReportDataList);
    });
  }

  Future<void> setData() async {
    setState(() {
      _productReportsDataList = null;
      temp = null;
    });
    await Provider.of<GetProvider>(context, listen: false)
        .getStocksReports(
            DateFormat('yyyy-MM-dd').format(_startDate).toString(),
            DateFormat('yyyy-MM-dd').format(_endDate).toString(),
            1,
            _warehouse.wId)
        .then((value) {
      setState(() {
        _productReportsDataList = value;
      });
      populateData();
    });
  }

  Future<void> loadMoreData() async {
    setState(() {
      _loadMoreLoading = true;
    });
    await Provider.of<GetProvider>(context, listen: false)
        .getStocksReports(
            DateFormat('yyyy-MM-dd').format(_startDate).toString(),
            DateFormat('yyyy-MM-dd').format(_endDate).toString(),
            _productReportsDataList.currentPage + 1,
            _warehouse.wId)
        .then((value) {
      setState(() {
        _productReportsDataList.addNewPage(value);
        populateData();
      });
      Timer(
        Duration(seconds: 1),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent),
      );
    });
    setState(() {
      _loadMoreLoading = false;
    });
  }
}

class ProductReportDataSource extends DataGridSource {
  List<DataGridRow> _productData = [];
  ProductReportDataSource({@required List<ProductReportData> productData}) {
    _productData = productData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.key + 1),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<int>(
                  columnName: 'purchased_amount', value: e.purchased_amount),
              DataGridCell<int>(
                  columnName: 'purchased_qty', value: e.purchased_qty),
              DataGridCell<int>(
                  columnName: 'sold_amount', value: e.sold_amount),
              DataGridCell<int>(columnName: 'sold_qty', value: e.sold_qty),
              DataGridCell<int>(
                  columnName: 'returned_amount', value: e.returned_amount),
              DataGridCell<int>(
                  columnName: 'returned_qty', value: e.returned_qty),
              DataGridCell<int>(
                  columnName: 'purchase_returned_amount',
                  value: e.purchase_returned_amount),
              DataGridCell<int>(
                  columnName: 'purchase_returned_qty',
                  value: e.purchase_returned_qty),
              DataGridCell<String>(columnName: 'profit', value: e.profit),
              DataGridCell<int>(columnName: 'in_stock', value: e.in_stock),
            ]))
        .toList();
  }
  @override
  List<DataGridRow> get rows => _productData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
//            padding: EdgeInsets.all(0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
