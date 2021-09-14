import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/model/ProductReportData.dart';
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

List<ProductReportData> _productReportsData, temp;
ProductReportDataSource _productReportDataSource;

class _ProductReportState extends State<ProductReport> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<GetProvider>(context, listen: false)
          .getStocksReports(
              DateFormat('yyyy-MM-dd').format(_startDate).toString(),
              DateFormat('yyyy-MM-dd').format(_endDate).toString())
          .then((value) {
        print(value.length);
        setState(() {
          _productReportsData = temp = value;
          _productReportDataSource = ProductReportDataSource();
        });
      });
    });
    _searchController.addListener(() {
      _productReportsData = temp
          .where((element) => element.name.contains(_searchController.text))
          .toList();
    });
//    populateData();
  }

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  TextEditingController _searchController = new TextEditingController(text: '');
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
          //mainAxisSize: MainAxisSize.max,
          children: [
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
            ///select range of date
            ///---------------------------------
            Container(
              padding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
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
                        border: Border.all(color: Color(0xfff1f1f1), width: 2),
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
                                onChanged: (date) {}, onConfirm: (date) async {
                              _startDate = date;
                              await populateData();
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
                        border: Border.all(color: Color(0xfff1f1f1), width: 2),
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
                                onChanged: (date) {}, onConfirm: (date) async {
                              _endDate = date;
                              await populateData();
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
            Container(
                height: size.height * 0.70,
                width: size.width,
                alignment: Alignment.center,
                child: _productReportsData != null
                    ? _productReportsData.length != 0
                        ? SfDataGrid(
                            source: _productReportDataSource,
                            columnWidthMode: ColumnWidthMode.auto,
                            headerCellBuilder: (contex, column) {
                              return Center(
                                child: Container(
                                  width: double.infinity,
                                  decoration:
                                      BoxDecoration(color: primaryColor),
                                  child: Center(
                                    child: Text(
                                      '${column.headerText}',
                                      style: FCITextStyle(color: Colors.white)
                                          .bold14(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility:
                                GridLinesVisibility.vertical,
                            headerRowHeight: ScreenUtil().setHeight(60),
                            rowHeight: ScreenUtil().setHeight(50),
                            columns: <GridColumn>[
                              GridTextColumn(
                                  mappingName: 'name',
                                  headerText: 'اسم المنتج',
                                  width: ScreenUtil().setWidth(150),
                                  maxLines: 3,
                                  padding: EdgeInsets.symmetric(vertical: 0),
                                  headerTextAlignment: Alignment.centerRight,
                                  textAlignment: Alignment.centerRight,
                                  overflow: TextOverflow.ellipsis),
                              GridNumericColumn(
                                  mappingName: 'purchased_amount',
                                  headerText: 'المبلغ المشترى',
                                  padding: EdgeInsets.symmetric(vertical: 0),
                                  textAlignment: Alignment.center,
                                  headerTextOverflow: TextOverflow.clip),
                              GridNumericColumn(
                                mappingName: 'purchased_qty',
                                headerText: 'الكمية المشتراة',
                                padding: EdgeInsets.symmetric(vertical: 0),
                                textAlignment: Alignment.center,
                              ),
                              GridNumericColumn(
                                mappingName: 'sold_amount',
                                headerText: 'المبلغ المباع',
                                padding: EdgeInsets.symmetric(vertical: 0),
                                textAlignment: Alignment.center,
                              ),
                              GridNumericColumn(
                                mappingName: 'sold_qty',
                                headerText: 'الكمبة المباعة',
                                padding: EdgeInsets.symmetric(vertical: 0),
                                textAlignment: Alignment.center,
                              ),
                              GridNumericColumn(
                                mappingName: 'returned_amount',
                                headerText: 'المبلغ المرتجع',
                                padding: EdgeInsets.symmetric(vertical: 0),
                                textAlignment: Alignment.center,
                              ),
                              GridNumericColumn(
                                mappingName: 'returned_qty',
                                headerText: 'الكمبة المرتجعة',
                                padding: EdgeInsets.symmetric(vertical: 0),
                                textAlignment: Alignment.center,
                              ),
                              GridNumericColumn(
                                mappingName: 'purchase_returned_amount',
                                headerText: 'المبلغ المشترى المرتجع',
                                padding: EdgeInsets.symmetric(vertical: 0),
                                textAlignment: Alignment.center,
                              ),
                              GridNumericColumn(
                                mappingName: 'purchase_returned_qty',
                                headerText: 'الكمية المشتراه المرتجعه ',
                                padding: EdgeInsets.symmetric(vertical: 0),
                                textAlignment: Alignment.center,
                              ),
                              GridNumericColumn(
                                mappingName: 'profit',
                                headerText: 'ربح',
                                padding: EdgeInsets.symmetric(vertical: 0),
                                textAlignment: Alignment.center,
                              ),
                              GridNumericColumn(
                                  mappingName: 'in_stock',
                                  headerText: 'المخزن',
                                  padding: EdgeInsets.symmetric(vertical: 0),
                                  textAlignment: Alignment.center,
                                  headerTextOverflow: TextOverflow.visible),
                            ],
                          )
                        : Text(
                            'لا يوجد بيانات',
                            style: FCITextStyle().normal18(),
                          )
                    : loadingTow(100)),
          ],
        ),
      ),
    );
  }

  Future<void> populateData() async {
    setState(() {
      _productReportsData = temp = null;
    });
    await Provider.of<GetProvider>(context, listen: false)
        .getStocksReports(
            DateFormat('yyyy-MM-dd').format(_startDate).toString(),
            DateFormat('yyyy-MM-dd').format(_endDate).toString())
        .then((value) {
      setState(() {
        _productReportsData = temp = value;
        _productReportDataSource = ProductReportDataSource();
      });
    });
  }
}

class ProductReportDataSource extends DataGridSource<ProductReportData> {
  @override
  List<ProductReportData> get dataSource => _productReportsData;

  @override
  Object getValue(ProductReportData product, String columnName) {
    switch (columnName) {
      case 'name':
//        print(product.name);
        return product.name;
        break;
      case 'purchased_amount':
        return product.purchased_amount;
        break;
      case 'purchased_qty':
        return product.purchased_qty;
        break;
      case 'sold_amount':
        return product.sold_amount;
        break;
      case 'sold_qty':
        return product.sold_qty;
        break;
      case 'returned_amount':
        return product.returned_amount;
        break;
      case 'returned_qty':
        return product.returned_qty;
        break;
      case 'purchase_returned_amount':
        return product.purchase_returned_amount;
        break;
      case 'purchase_returned_qty':
        return product.purchase_returned_qty;
        break;
      case 'profit':
        return product.profit;
        break;
      case 'in_stock':
//        print(product.in_stock);
        return product.in_stock;
        break;
      default:
        return ' ';
        break;
    }
  }
}
