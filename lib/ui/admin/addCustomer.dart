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

class AddCustomer extends StatefulWidget {
  @override
  _AddCustomer createState() => _AddCustomer();
}

class _AddCustomer extends State<AddCustomer> {
  TextEditingController companyController = TextEditingController(text: '');
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController phoneController = TextEditingController(text: '');
  TextEditingController addressController = TextEditingController(text: '');
  TextEditingController cityController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  List<CustomerGroup> customerGroups = [];
  CustomerGroup customerGroup;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      customerGroups = await Provider.of<GetProvider>(context, listen: false)
          .getCustomerGroups();
    });
  }

  @override
  void dispose() {
    companyController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    emailController.dispose();
    nameController.dispose();
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
        //  resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'إضافة عميل',
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
        body: SingleChildScrollView(
          child: Builder(
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
                                "إختــــــر المجموعة",
                                style:
                                    FCITextStyle(color: accentColor).normal18(),
                              ),
                              actions: List.generate(
                                customerGroups.length,
                                (int index) {
                                  return CupertinoActionSheetAction(
                                    child: Text(
                                      "${customerGroups[index].name}",
                                      style: FCITextStyle(color: primaryColor)
                                          .normal18(),
                                    ),
                                    isDefaultAction: true,
                                    onPressed: () {
                                      setState(() {
                                        customerGroup = customerGroups[index];
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
                            customerGroup == null
                                ? "إختــــــر المجموعة"
                                : customerGroup.name,
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
                    height: ScreenUtil().setHeight(15),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(5)),
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
                      controller: nameController,
                      //  focusNode: focusNode,
                      onSubmitted: (value) {},
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10)),
                        border: InputBorder.none,
                        hintText: 'اسم العميل',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(15),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(5)),
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
                      controller: companyController,
                      //  focusNode: focusNode,
                      onSubmitted: (value) {},
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10)),
                        border: InputBorder.none,
                        hintText: 'اسم الشركة',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(15),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(5)),
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
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      //  focusNode: focusNode,
                      onSubmitted: (value) {},
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10)),
                        border: InputBorder.none,
                        hintText: 'رقم التليفون',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(15),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(5)),
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
                      controller: addressController,
                      //keyboardType: TextInputType.phone,
                      //  focusNode: focusNode,
                      onSubmitted: (value) {},
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10)),
                        border: InputBorder.none,
                        hintText: 'العنــــوان',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(15),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(5)),
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
                      controller: cityController,
                      // keyboardType: TextInputType.phone,
                      //  focusNode: focusNode,
                      onSubmitted: (value) {},
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10)),
                        border: InputBorder.none,
                        hintText: 'المدينــــة',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(15),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(5)),
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
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      //  focusNode: focusNode,
                      onSubmitted: (value) {},
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10)),
                        border: InputBorder.none,
                        hintText: 'الايميل',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(35),
                  ),
                  Container(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (customerGroup == null) {
      showInSnackBar('إختر المجموعة');
      return false;
    } else if (nameController.text.isEmpty) {
      showInSnackBar('ادخل اسم العميل');

      return false;
    } else if (companyController.text.isEmpty) {
      showInSnackBar('ادخل اسم الشركة');

      return false;
    } else if (phoneController.text.isEmpty) {
      showInSnackBar('ادخل رقم التليفون');

      return false;
    } else if (addressController.text.isEmpty) {
      showInSnackBar('ادخل العنوان');
      return false;
    } else if (cityController.text.isEmpty) {
      showInSnackBar('ادخل المدينة');
      return false;
    }
    return true;
  }

  clearData() {
    setState(() {
      customerGroup = null;

      companyController.text = '';
      phoneController.text = '';
      addressController.text = '';
      cityController.text = '';
      emailController.text = '';
      nameController.text = '';
      _btnController.reset();
    });
  }

  sendExpense() async {
    if (validate() == true) {
      var data = {
        'customer_group_id': '${customerGroup.id}',
        'company_name': '${companyController.text}',
        'name': '${nameController.text}',
        'phone_number': '${phoneController.text}',
        'address': '${addressController.text}',
        'city': '${cityController.text}',
        'email': '${emailController.text}',
      };
      print('data is $data');
      await Provider.of<PostProvider>(context, listen: false)
          .addCustomer(data)
          .then((response) {
        if (response) {
          //Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.SUCCES,
              dismissOnBackKeyPress: true,
              dismissOnTouchOutside: true,
              title: "اضافة عميل",
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
              title: "اضافة عميل",
              desc: "فشل عملية اضافة العميل",
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
