import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/widget/CustomWidgets.dart';
import 'package:raid/widget/rounded_input_field.dart';

import 'ProductsCard.dart';

class ProductsScreen extends StatefulWidget {
  bool loading;
  ProductsScreen({this.loading});
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
  }

  changeProducts() async {
    selectedCat == 0
        ? await Provider.of<GetProvider>(context, listen: false).getProducts()
        : await Provider.of<GetProvider>(context, listen: false)
            .getProductById(selectedCat);
  }

  int selectedCat = 0;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetProvider>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(5),
                horizontal: ScreenUtil().setWidth(60)),
            child: CustomTextInput(
              obscure: false,
              enabled: false,
              suffixicon: Icon(Icons.keyboard_arrow_down_sharp),
              hintText: 'search'.tr(),
              leading: Icons.filter_alt_sharp,
            ),
          ),
          widget.loading
              ? Column(
                  children: [
                    loadingTow(50),
                  ],
                )
              : Container(
                  width: size.width,
                  height: ScreenUtil().setHeight(120),
                  child: provider.catProducts.length > 0
                      ? ListView.builder(
                          itemCount: provider.catProducts.length + 1,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => index == 0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil().setWidth(
                                              selectedIndex == index
                                                  ? 20
                                                  : 5)),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedCat = 0;
                                            selectedIndex = 0;
                                            changeProducts();
                                          });
                                        },
                                        child: Container(
                                          height: selectedIndex == index
                                              ? ScreenUtil().setHeight(110)
                                              : ScreenUtil().setHeight(90),
                                          width: selectedIndex == index
                                              ? ScreenUtil().setWidth(110)
                                              : ScreenUtil().setWidth(90),
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setWidth(5)),
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setWidth(5),
                                              vertical:
                                                  ScreenUtil().setHeight(5)),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 3,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ]),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      ScreenUtil().setHeight(5),
                                                  horizontal:
                                                      ScreenUtil().setWidth(5),
                                                ),
                                                child:
                                                    CustomWidgets().CustomImage(
                                                  fileImage: null,
                                                  assetsImagePath:
                                                      'assets/images/allcat.png',
                                                  networkImageUrl: null,
                                                  height: ScreenUtil()
                                                      .setHeight(
                                                          selectedIndex == index
                                                              ? 60
                                                              : 50),
                                                  width: ScreenUtil().setWidth(
                                                      selectedIndex == index
                                                          ? 70
                                                          : 60),
                                                ),
                                              ),
                                              Text(
                                                'الكل',
                                                style: selectedIndex == index
                                                    ? FCITextStyle(
                                                            color: primaryColor)
                                                        .bold16()
                                                    : FCITextStyle(
                                                            color: Colors.black)
                                                        .normal16(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil().setWidth(
                                              selectedIndex == index
                                                  ? 10
                                                  : 5)),
                                      child: InkWell(
                                        onTap: () {
                                          print("Cat ${provider.catProducts[index - 1].name}" );
                                          setState(() {
                                            selectedIndex = index;
                                            selectedCat = provider
                                                .catProducts[index - 1]
                                                .categoryId;
                                            changeProducts();
                                          });
                                        },
                                        child: Container(
                                          height: selectedIndex == index
                                              ? ScreenUtil().setHeight(110)
                                              : ScreenUtil().setHeight(100),
                                          width: selectedIndex == index
                                              ? ScreenUtil().setWidth(110)
                                              : ScreenUtil().setWidth(90),
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setWidth(5)),
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setWidth(5),
                                              vertical:
                                                  ScreenUtil().setHeight(5)),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 3,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ]),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      ScreenUtil().setHeight(5),
                                                  horizontal:
                                                      ScreenUtil().setWidth(5),
                                                ),
                                                child:
                                                    CustomWidgets().CustomImage(
                                                  fileImage: null,
                                                  assetsImagePath:
                                                      'assets/images/noImage.png',
                                                  networkImageUrl: provider
                                                      .catProducts[index - 1]
                                                      .image,
                                                  height: ScreenUtil()
                                                      .setHeight(
                                                          selectedIndex == index
                                                              ? 40
                                                              : 30),
                                                  width: ScreenUtil().setWidth(
                                                      selectedIndex == index
                                                          ? 60
                                                          : 50),
                                                ),
                                              ),
                                              Text(
                                                '${provider.catProducts[index - 1].name ?? ''}',textAlign: TextAlign.center,
                                                style: selectedIndex == index
                                                    ? FCITextStyle(
                                                            color: primaryColor)
                                                        .bold16()
                                                    : FCITextStyle(
                                                            color: Colors.black)
                                                        .normal12(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        )
                      : Container(),
                ),
          Container(
            height: size.height * 3 / 5 - ScreenUtil().setHeight(20),
            child: provider?.busy
                ? loadingTow(100)
                : provider.products.length>0?ListView.builder(
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) => ProductCard(
                          productData: provider.products[index],
                        ))
            :Center(child: Text("لا يوجد نتائج",style: FCITextStyle().normal18(),),),
          ),
        ],
      ),
    );
  }
}
