import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/ProductData.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/widget/rounded_input_field.dart';

import 'OffersCard.dart';

class OffersScreen extends StatefulWidget {
  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  TextEditingController searchController = new TextEditingController();
  @override
  void initState() {
    super.initState();
//    searchController.addListener(() {
//      if (searchController.text.isNotEmpty) {
//        productOffers = productOffers
//            .where((element) =>
//                element.name.contains(searchController.text) ||
//                element.description.contains(searchController.text))
//            .toList();
//      } else {
//        productOffers = temp;
//      }
//    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetProvider>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return provider.busy
        ? loading()
        : ListView.builder(
            itemCount: provider.productOffers.length + 1,
            itemBuilder: (context, index) => index == 0
                ? Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(50)),
                    child: CustomTextInput(
                      controller: searchController,
                      hintText: 'search'.tr(),
                      leading: Icons.filter_alt_sharp,
                      suffixicon: Icon(Icons.keyboard_arrow_down_sharp),
                    ),
                  )
                : OfferCard(productOffer:  provider.productOffers[index - 1]));
  }
}
