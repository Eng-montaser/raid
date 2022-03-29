import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart' as T;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/ui/HomeTaps/Brands.dart';
import 'package:raid/ui/HomeTaps/ContactUs.dart';
import 'package:raid/ui/Profile/CustomerProfile.dart';
import 'package:raid/widget/CustomWidgets.dart';

import '../constants.dart';
import 'HomeTaps/Codes/Code2.dart';
import 'HomeTaps/Conciliation/Conciliation.dart';
import 'HomeTaps/MyServices/SearchPage.dart';
import 'HomeTaps/Offers/Offers.dart';
import 'HomeTaps/ProductsScreen/ProductsScreen.dart';
import 'HomeTaps/Videos/Video.dart';

class Home extends StatefulWidget {
  final int initialIndex;

  const Home({Key key, this.initialIndex = 0}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool catLoading = true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ///Cat And Products -------------------------------------
      await Provider.of<GetProvider>(context, listen: false)
          .getCatProducts()
          .then((value) {
        setState(() {
          catLoading = false;
        });
      });
      await Provider.of<GetProvider>(context, listen: false).getProducts(1);

      ///Cat And Conciliation ---------------------------------
      await Provider.of<GetProvider>(context, listen: false).getIntegrations();

      ///Cat And Offers --------------------------------------
      await Provider.of<GetProvider>(context, listen: false).getOffers(1);

      ///Cat And Brands --------------------------------------
      // await Provider.of<GetProvider>(context, listen: false).getBrands();

      ///Cat And Service --------------------------------------
      await Provider.of<GetProvider>(context, listen: false).getService();

      ///Cat And Videos --------------------------------------
      //   await Provider.of<GetProvider>(context, listen: false).getVideos();

      ///Cat And Codes --------------------------------------
      await Provider.of<GetProvider>(context, listen: false).getCompanies();

      ///Cat And Setting --------------------------------------
      await Provider.of<GetProvider>(context, listen: false).getSetting();
    });

    _tabController = TabController(
        length: 8, vsync: this, initialIndex: widget.initialIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(ScreenUtil().setHeight(130)),
          child: AppBar(
            title: Container(
              height: ScreenUtil().setHeight(70),
              width: ScreenUtil().setWidth(100),
              child: Image.asset(
                kLogo,
                fit: BoxFit.contain,
              ),
              margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(20),
                  vertical: ScreenUtil().setHeight(5)),
              padding: EdgeInsets.symmetric(
//                horizontal: ScreenUtil().setWidth(20),
                  vertical: ScreenUtil().setHeight(5)),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerProfile()));
                },
                child: CustomWidgets().CircleImage(
                    fileImage: null,
                    assetsImagePath: 'assets/images/defult_profile.png',
                    networkImageUrl:
                        'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                    radius: 20),
              ),
              SizedBox(
                width: 5,
              )
//              IconButton(
//                  icon: Icon(
//                    Icons.list,
//                    size: ScreenUtil().setSp(30),
//                  ),
//                  onPressed: () async {
//                    await T.EasyLocalization.of(context).setLocale(
//                        T.EasyLocalization.of(context).locale.languageCode ==
//                                'en'
//                            ? Locale('ar', 'SA')
//                            : Locale('en', 'US'));
//                  })
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(ScreenUtil().setHeight(50)),
              child: Builder(builder: (context) {
                return Row(
                  children: [
                    if (_tabController.index != 0)
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (_tabController.index > 0) {
                            _tabController.animateTo(_tabController.index - 1);
                          }
                        },
                      ),
                    Expanded(
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.red,

//            indicatorWeight: 0,
                        isScrollable: true,
                        unselectedLabelStyle: TextStyle(fontSize: 18),
                        labelStyle: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            fontSize: 18),
                        tabs: [
                          Tab(
                            child: Text("Products".tr()),
                          ),
                          Tab(
                            child: Text("Conciliation".tr()),
                          ),
                          Tab(
                            child: Text("Brands".tr()),
                          ),
                          Tab(
                            child: Text("Offers".tr()),
                          ),
                          Tab(
                            child: Text("myservices".tr()),
                          ),
                          Tab(
                            child: Text("Video".tr()),
                          ),
                          Tab(
                            child: Text("Code".tr()),
                          ),
                          Tab(
                            child: Text("ContactUs".tr()),
                          )
                        ],
                      ),
                    ),
                    if (_tabController.index != 7)
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (_tabController.index < 7) {
                            _tabController.animateTo(_tabController.index + 1);
                          }
                        },
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ProductsScreen(
              loading: catLoading,
            ),
            ConciliationScreen(),
            BrandsScreen(),
            OffersScreen(),
            SearchServices(),
            VideoScreen(),
            CodeScreen2(),
            ContactUs()
          ],
        ));
  }
}
