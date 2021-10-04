import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/UserData.dart';
import 'package:raid/provider/AuthProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/ui/Profile/Profile.dart';
import 'package:raid/widget/background.dart';

class SalesPerson extends StatefulWidget {
  SalesPerson({Key key}) : super(key: key);

  @override
  _SalesPerson createState() => _SalesPerson();
}

class _SalesPerson extends State<SalesPerson> {
  UserData userData;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userData =
          await Provider.of<AuthProvider>(context, listen: false).userData;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        show: false,
        child: Center(
          child: Column(
            //  mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(25),
                    vertical: ScreenUtil().setHeight(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Profile()));
                      },
                      child: CircleAvatar(
                        child: Image.asset('assets/images/man-300x300.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              Image.asset(
                "assets/images/white.png",
                fit: BoxFit.contain,
                height: size.height * .11,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(45),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'مندوب المبيعات',
                        textScaleFactor: 1.3,
                        style: FCITextStyle().bold18(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10)),
                        child: Text(
                          'تستطيع الان عمل كشف حساب للعملاء المتعاملين وكذلك تحويل مخزون الى المخزن الرئيسى بالاضافة الى عمل مرتجع للصنف',
                          // textScaleFactor: 1.3,
                          maxLines: 2,

                          style: FCITextStyle(color: Colors.black54)
                              .normal14()
                              .copyWith(height: 1.5),
                        ),
                      ),
                      cardWidget('كشف حساب العملاء',
                          'assets/images/Group_498.png', false, 'summary', 0),
                      if (userData?.role_id == 1)
                        cardWidget('فاتورة شراء', 'assets/images/Group_498.png',
                            true, 'buy', 50),
                      if (userData?.role_id == 4 || userData?.role_id == 1)
                        cardWidget('فاتورة بيع', 'assets/images/Group_498.png',
                            false, 'invoice', 100),
//                      cardWidget('تحويل مخزون', 'assets/images/Group_595.png',
//                          false, 'return_store', 100),
//                      cardWidget('مرتـــجع', 'assets/images/Group_681.png',
//                          true, 'returns', 150),
                      if (userData?.role_id == 4 || userData?.role_id == 1)
                        cardWidget('رصيد مستودع', 'assets/images/Group_681.png',
                            true, 'productReport', 150),
                      if (userData?.role_id == 1)
                        cardWidget('إضافة عميل ', 'assets/images/customer.jpg',
                            false, 'addCustomer', 200),
                      if (userData?.role_id == 1)
                        cardWidget('إضافة مورد ', 'assets/images/supplier.png',
                            true, 'addSupplier', 250),
                      if (userData?.role_id == 1)
                        cardWidget(
                            'إضافة مصروفات ',
                            'assets/images/expense.png',
                            false,
                            'addExpense',
                            300),
                      if (userData?.role_id == 1)
                        cardWidget('إضافة صنف ', 'assets/images/product.jpg',
                            true, 'addProduct', 350),
                    ],
                  ),
                ),
              )
            ],
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }

  Widget cardWidget(
      String text, String image, bool fromRight, String navigate, int index) {
    return InkWell(
      onTap: () {
        //  print('${userData.role_id}');
        /* if (navigate == 'invoice' && userData.role_id != 4) {
                  AwesomeDialog(
                      context: context,
                      animType: AnimType.LEFTSLIDE,
                      headerAnimationLoop: false,
                      dialogType: DialogType.ERROR,
                      dismissOnBackKeyPress: false,
                      dismissOnTouchOutside: false,
                      title: '',
                      desc: 'لا يمكنك اصدار فاتورة',
                      btnOkText: "حسنا",
                      btnOkColor: Colors.red,
                      btnOkOnPress: () {},
                      onDissmissCallback: (type) {})
                    ..show();
                } else*/
        Navigator.of(context).pushNamed(navigate);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7)),
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(25),
            vertical: ScreenUtil().setHeight(15)),
        child: Column(
          children: [
            TranslationAnimatedWidget(
              enabled:
                  true, //update this boolean to forward/reverse the animation
              delay: Duration(milliseconds: index),
              values: [
                Offset(0, 200), // disabled value value
                Offset(0, 150), //intermediate value
                Offset(0, 0) //enabled value
              ],
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(15),
                    vertical: ScreenUtil().setHeight(5)),
                margin: EdgeInsets.only(
                  bottom: ScreenUtil().setHeight(10),
                ),
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection:
                      fromRight ? TextDirection.ltr : TextDirection.rtl,
                  children: [
                    Expanded(
                      child: Text(
                        text,
                        style: FCITextStyle(color: Colors.white).bold18(),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(50),
                    ),
                    Expanded(
                      child: Image.asset(
                        image,
                        fit: BoxFit.fill,
                        height: ScreenUtil().setHeight(100),
                        //  width: ScreenUtil().setWidth(150),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Text(
              'تستطيع الان عمل كشف حساب للعملاء المتعاملين وكذلك تحويل مخزون الى المخزن الرئيسى بالاضافة الى عمل مرتجع للصنف',
              // textScaleFactor: 1.3,
              maxLines: 2,
              style: FCITextStyle(color: Colors.black54)
                  .normal13()
                  .copyWith(height: 1),
            ),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(30),
                  vertical: ScreenUtil().setHeight(2)),
              decoration: BoxDecoration(
                  border: Border.all(color: primaryColor, width: .5),
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                'للمزيد',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(13),
                    color: primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
