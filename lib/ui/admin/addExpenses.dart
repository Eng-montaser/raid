import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/NewModels.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/provider/PostProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddExpense extends StatefulWidget {
  @override
  _AddExpense createState() => _AddExpense();
}

class _AddExpense extends State<AddExpense> {
  TextEditingController amountController = TextEditingController(text: '');
  TextEditingController noteController = TextEditingController(text: '');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  List<ExpenseCategory> expensecategories = [];
  ExpenseCategory expenseCategory;
  List<Warehouse> warehouses = [];
  Warehouse warehouse;
  List<Account> accounts = [];
  Account account;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      expensecategories = await Provider.of<GetProvider>(context, listen: false)
          .getExpenseCategories();
      warehouses = await Provider.of<GetProvider>(context, listen: false)
          .getWarehouses();
      accounts =
          await Provider.of<GetProvider>(context, listen: false).getAccounts();
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var getProvider = Provider.of<GetProvider>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white.withOpacity(.9),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'إضافة مصروفات',
            style: FCITextStyle(color: Colors.white).bold20(),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios_outlined),
          ),
        ),
        body: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                InkWell(
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                            title: Text(
                              "إختــــــر القسم",
                              style:
                                  FCITextStyle(color: accentColor).normal18(),
                            ),
                            actions: List.generate(
                              expensecategories.length,
                              (int index) {
                                return CupertinoActionSheetAction(
                                  child: Text(
                                    "${expensecategories[index].name}",
                                    style: FCITextStyle(color: primaryColor)
                                        .normal18(),
                                  ),
                                  isDefaultAction: true,
                                  onPressed: () {
                                    setState(() {
                                      expenseCategory =
                                          expensecategories[index];
                                    });

                                    //ontap(selected);
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
//
                            )));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20)),
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
                          expenseCategory == null
                              ? "إختــــــر القســم"
                              : expenseCategory.name,
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
                SizedBox(
                  height: ScreenUtil().setHeight(25),
                ),
                InkWell(
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                            title: Text(
                              "إختــــــر المستودع",
                              style:
                                  FCITextStyle(color: accentColor).normal18(),
                            ),
                            actions: List.generate(
                              warehouses.length,
                              (int index) {
                                return CupertinoActionSheetAction(
                                  child: Text(
                                    "${warehouses[index].name}",
                                    style: FCITextStyle(color: primaryColor)
                                        .normal18(),
                                  ),
                                  isDefaultAction: true,
                                  onPressed: () {
                                    setState(() {
                                      warehouse = warehouses[index];
                                    });

                                    //ontap(selected);
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
//
                            )));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20)),
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
                          warehouse == null
                              ? "إختــــــر المستودع"
                              : warehouse.name,
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
                SizedBox(
                  height: ScreenUtil().setHeight(25),
                ),
                InkWell(
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                            title: Text(
                              "إختــــــر الحســاب",
                              style:
                                  FCITextStyle(color: accentColor).normal18(),
                            ),
                            actions: List.generate(
                              accounts.length,
                              (int index) {
                                return CupertinoActionSheetAction(
                                  child: Text(
                                    "${accounts[index].name}",
                                    style: FCITextStyle(color: primaryColor)
                                        .normal18(),
                                  ),
                                  isDefaultAction: true,
                                  onPressed: () {
                                    setState(() {
                                      account = accounts[index];
                                    });

                                    //ontap(selected);
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
//
                            )));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20)),
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
                          account == null
                              ? "إختــــــر الحســاب"
                              : account.name,
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
                SizedBox(
                  height: ScreenUtil().setHeight(25),
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: accentColor,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(10)),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: amountController,
                    //  focusNode: focusNode,
                    onSubmitted: (value) {},
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(10)),
                      border: InputBorder.none,
                      hintText: 'المبـــلغ',
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(25),
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: accentColor,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(10)),
                  child: TextField(
                    controller: noteController,
                    maxLines: 5,
                    //  focusNode: focusNode,
                    onSubmitted: (value) {},
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(10)),
                      border: InputBorder.none,
                      hintText: 'ملاحظات',
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: RoundedLoadingButton(
                      child: Text('send'.tr(),
                          style: FCITextStyle(color: Colors.white).normal18()),
                      width: ScreenUtil().setWidth(100),
                      color: primaryColor,
                      controller: _btnController,
                      onPressed: () {
                        sendExpense();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (expenseCategory == null) {
      showInSnackBar('إختر قسم المصروف');
      return false;
    } else if (warehouse == null) {
      showInSnackBar('إختر المخزن');

      return false;
    } else if (account == null) {
      showInSnackBar('إختر رقم الحساب');

      return false;
    } else if (amountController.text.isEmpty ||
        amountController.text == '.' ||
        amountController.text == ',') {
      showInSnackBar('ادخل الكمية بشكل صحيح');
      return false;
    }
    return true;
  }

  clearData() {
    setState(() {
      expenseCategory = null;
      account = null;
      warehouse = null;
      amountController.text = '';
      noteController.text = '';
      _btnController.reset();
    });
  }

  sendExpense() async {
    if (validate() == true) {
      var data = {
        'expense_category_id': '${expenseCategory.id}',
        'warehouse_id': '${warehouse.id}',
        'account_id': '${account.id}',
        'amount': '${amountController.text}',
        'note': '${noteController.text}',
      };
      print('data is $data');
      await Provider.of<PostProvider>(context, listen: false)
          .addExpense(data)
          .then((response) {
        if (response) {
          // Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.SUCCES,
              dismissOnBackKeyPress: true,
              dismissOnTouchOutside: true,
              title: "اضافة مصروفات",
              desc: "تمت الاضافة بنجاح",
              btnOkText: "ok".tr(),
              btnOkColor: Colors.green,
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
              title: "اضافة مصروفات",
              desc: "فشل عملية اضافة المصروفات",
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

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        style: FCITextStyle(color: Colors.white).normal18(),
      ),
      duration: new Duration(milliseconds: 1000),
      backgroundColor: primaryColor,
    ));
  }
}
