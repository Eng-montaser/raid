import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/ui/HomeTaps/Offers/SearchOffer.dart';
import 'package:raid/widget/rounded_input_field.dart';

import 'OffersCard.dart';

class OffersScreen extends StatefulWidget {
  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  TextEditingController searchController = new TextEditingController();
  bool isLoading2 = false;

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

  changeProducts(int page) async {
    setState(() {
      isLoading2 = page == 1 ? false : true;
    });
    await Provider.of<GetProvider>(context, listen: false).getOffers(page);
    setState(() {
      isLoading2 = false;
    });
  }

  bool onNotification(ScrollEndNotification t) {
    if (t.metrics.pixels > 0 && t.metrics.atEdge) {
      if (Provider.of<GetProvider>(context, listen: false).offers.current_page +
              1 <=
          Provider.of<GetProvider>(context, listen: false).offers.last_page)
        changeProducts(Provider.of<GetProvider>(context, listen: false)
                .offers
                .current_page +
            1);
    } else {
      print('I am at the start');
    }
    ;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetProvider>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return provider.busy && provider?.productOffers?.length == 0
        ? loading()
        : NotificationListener<ScrollEndNotification>(
            onNotification: onNotification,
            child: ListView.builder(
                itemCount: provider.productOffers.length + 1,
                itemBuilder: (context, index) => index == 0
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SearchOffer()));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(50)),
                          child: CustomTextInput(
                            enabled: false,
                            controller: searchController,
                            hintText: 'search'.tr(),
                            leading: Icons.filter_alt_sharp,
                            suffixicon: Icon(Icons.keyboard_arrow_down_sharp),
                          ),
                        ),
                      )
                    : index == provider.productOffers.length - 1 && isLoading2
                        ? loadingTow(50)
                        : OfferCard(
                            productOffer: provider.productOffers[index - 1])),
          );
  }
}
