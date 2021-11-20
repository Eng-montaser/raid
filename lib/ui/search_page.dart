//import 'package:easy_localization/easy_localization.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:provider/provider.dart';
//import 'package:raid/constants.dart';
//import 'package:raid/model/ProductData.dart';
//import 'package:raid/provider/GetProvider.dart';
//
//import 'HomeTaps/ProductsScreen/ProductsCard.dart';
//
//class SearchPage extends StatefulWidget {
//  @override
//  _SearchPageState createState() => _SearchPageState();
//}
//
//class _SearchPageState extends State<SearchPage> {
//  // data
//  TextEditingController searchEditingController = new TextEditingController();
//  bool isLoading = false;
//  FocusNode focusNode = FocusNode();
//  //bool _isJoined = false;
//  List<ProductData> searchProducts = [];
//
//  // initState()
//  @override
//  void initState() {
//    super.initState();
//
//    init();
//    // _getCurrentUserNameAndUid();
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//  }
//
//  init() async {}
//
//  // functions
//
//  search() async {
//    if (searchEditingController.text.isNotEmpty) {
//      setState(() {
//        isLoading = true;
//        focusNode.unfocus();
//        focusNode.canRequestFocus = false;
//      });
//      Provider.of<GetProvider>(context, listen: false)
//          .searchProduct(searchEditingController.text)
//          .then((value) {
//        //print('ddd ${value.length}');
//        if (value != null)
//          setState(() {
//            isLoading = false;
//            searchProducts = value;
//          });
//      });
//    }
//  }
//
//  // widgets
//  Widget groupList() {
//    return isLoading
//        ? loading()
//        : ListView.builder(
//            itemCount: searchProducts.length,
//            itemBuilder: (context, index) => ProductCard(
//                  productData: searchProducts[index],
//                ));
//  }
//
//  // building the search page widget
//  @override
//  Widget build(BuildContext context) {
//    return AnnotatedRegion<SystemUiOverlayStyle>(
//      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.white),
//      child: Scaffold(
//        appBar: AppBar(
//          leading: IconButton(
//            onPressed: () {
//              Navigator.of(context).pop();
//            },
//            icon: Icon(
//              Icons.arrow_back_ios,
//              color: Colors.white,
//            ),
//          ),
//          elevation: 0.0,
//          backgroundColor: Theme.of(context).primaryColor,
//          title: Text('search'.tr(),
//              style: TextStyle(
//                  fontSize: 27.0,
//                  fontWeight: FontWeight.bold,
//                  color: Colors.white)),
//        ),
//        body: // isLoading ? Container(
//            //   child: Center(
//            //     child: CircularProgressIndicator(),
//            //   ),
//            // )
//            // :
//            Container(
//          child: Column(
//            children: [
//              Container(
//                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
//                color: Colors.grey[200],
//                child: Row(
//                  children: [
//                    Expanded(
//                      child: TextField(
//                        focusNode: focusNode,
//                        controller: searchEditingController,
//                        style: TextStyle(
//                            // color: Colors.white,
//                            ),
//                        decoration: InputDecoration(
//                            hintText: "search".tr(),
//                            hintStyle: TextStyle(
//                              //  color: Colors.white,
//                              fontSize: 16,
//                            ),
//                            border: InputBorder.none),
//                      ),
//                    ),
//                    GestureDetector(
//                        onTap: () {
//                          search();
//                        },
//                        child: Container(
//                            height: 40,
//                            width: 40,
//                            decoration: BoxDecoration(
//                                color: Theme.of(context).primaryColor,
//                                borderRadius: BorderRadius.circular(40)),
//                            child: Icon(Icons.search, color: Colors.white)))
//                  ],
//                ),
//              ),
//              isLoading
//                  ? Container(
//                      padding: EdgeInsets.symmetric(vertical: 30),
//                      child: Center(child: CircularProgressIndicator()))
//                  : Expanded(child: groupList())
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
