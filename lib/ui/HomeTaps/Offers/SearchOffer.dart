import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/ProductData.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/widget/rounded_button.dart';
import 'package:raid/widget/rounded_input_field.dart';

import 'OffersCard.dart';

class SearchOffer extends StatefulWidget {
  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchOffer> {
  TextEditingController searchController = TextEditingController(text: '');
  Offer searchProducts;
  List<ProductOffer> productList = [];
  bool isLoading = false;
  bool isLoading2 = false;
  ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
    searchController.addListener(() {
      if (searchController.text.isEmpty) searchProducts = null;
    });
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    // print(controller.position.pixels);
    // if (controller.position.extentAfter < searchProducts.productdata.length &&
    //   searchProducts.current_page + 1 <= searchProducts.last_page)
    // getData(searchController.text, searchProducts.current_page + 1);
  }

  bool onNotification(ScrollEndNotification t) {
    if (t.metrics.pixels > 0 && t.metrics.atEdge) {
      if (searchProducts.current_page + 1 <= searchProducts.last_page)
        getData(searchController.text, searchProducts.current_page + 1);
    } else {
      print('I am at the start');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // var provider = Provider.of<GetProvider>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(.9),
        appBar: AppBar(
          title: Text('بحث فى العروض'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/white.png'),
              scale: 5,
            )),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(5),
                      horizontal: ScreenUtil().setWidth(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextInput(
                        // obscure: false,
                        //  enabled: false,
                        suffixicon: Icon(Icons.search),
                        hintText: 'search'.tr(),
                        controller: searchController,
                        leading: null,
                      ),
                      if (searchController.text.isNotEmpty)
                        RoundedButton(
                          text: 'بحث',
                          color: primaryColor,
                          onTap: () async {
                            getData(searchController.text, 1);
                          },
                        ),
                    ],
                  ),
                ),
                isLoading
                    ? Center(child: loadingTow(50))
                    : searchProducts != null
                        ? productList.length > 0
                            ? Expanded(
                                child:
                                    NotificationListener<ScrollEndNotification>(
                                  onNotification: onNotification,
                                  child: ListView.builder(
                                      controller: controller,
                                      itemCount: productList.length,
                                      itemBuilder: (context, index) => index ==
                                                  productList.length - 1 &&
                                              isLoading2
                                          ? loadingTow(50)
                                          : OfferCard(
                                              productOffer: productList[index],
                                            )),
                                ),
                              )
                            : Align(
                                alignment: Alignment.topCenter,
                                child: Center(
                                  child: Text(
                                    "لا يوجد نتائج",
                                    style: FCITextStyle().normal18(),
                                  ),
                                ),
                              )
                        : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getData(String text, int page) async {
    setState(() {
      isLoading = page == 1 ? true : false;
      isLoading2 = true;
    });
    FocusScope.of(context).requestFocus(new FocusNode());
    await Provider.of<GetProvider>(context, listen: false)
        .searchOffers(searchController.text, page)
        .then((value) {
      if (value != null) {
        print('before: ${productList.length}');
        setState(() {
          isLoading = false;
          isLoading2 = false;

          searchProducts = value;
          productList.addAll(value.productdata);
        });
        print('after: ${productList.length}');
      }
    });
  }
}
