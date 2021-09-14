//import 'dart:async';
//import 'dart:convert';
//
//import 'package:api_cache_manager/utils/cache_manager.dart';
//import 'package:awesome_dialog/awesome_dialog.dart';
//import 'package:cached_network_image/cached_network_image.dart';
////import 'package:connectivity/connectivity.dart';
//import 'package:easy_localization/easy_localization.dart';
//import 'package:expansion_tile_card/expansion_tile_card.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter_app_badger/flutter_app_badger.dart';
//import 'package:flutter_html/flutter_html.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:provider/provider.dart';
//import 'package:theqah/Styles/StylesTextAndColors.dart';
//import 'package:theqah/Styles/size_config.dart';
//import 'package:theqah/models/BankData.dart';
//import 'package:theqah/models/ad_model.dart';
//import 'package:theqah/models/conversation_model.dart';
//import 'package:theqah/models/message_model.dart';
//import 'package:theqah/models/user_model.dart';
//import 'package:theqah/providers/ads_provider.dart';
//import 'package:theqah/providers/auth_provider.dart';
//import 'package:theqah/providers/conversation_provider.dart';
//import 'package:theqah/providers/user_provider.dart';
//import 'package:theqah/services/ads_service.dart';
//import 'package:theqah/setting/constants.dart';
//import 'package:theqah/ui/search_page.dart';
//import 'package:theqah/widgets/gray_input_field.dart';
//import 'package:theqah/widgets/loading.dart';
//import 'package:theqah/widgets/login_animation.dart';
//
//import 'edit_profile.dart';
//import 'messages.dart';
//
//class Home extends StatefulWidget {
//  @override
//  _HomeScreenState createState() => _HomeScreenState();
//}
//
//class _HomeScreenState extends State<Home>
//    with TickerProviderStateMixin, WidgetsBindingObserver {
//  ///*************************
//  ///  Variables
//  String _connectionStatus = 'Unknown';
//  TabController _tabController;
////  final Connectivity _connectivity = Connectivity();
////  StreamSubscription<ConnectivityResult> _connectivitySubscription;
//  TextEditingController phone1 = new TextEditingController();
//  TextEditingController phone2 = new TextEditingController();
//  TextEditingController ownerName = new TextEditingController();
//  TextEditingController details = new TextEditingController();
//  TextEditingController period = new TextEditingController();
//  TextEditingController kind1 = new TextEditingController();
//  TextEditingController total = new TextEditingController();
//  TextEditingController name = new TextEditingController();
//  TextEditingController fee = new TextEditingController();
//  TextEditingController bativalue = new TextEditingController();
//  AnimationController _sendButtonController;
//  bool isLoading = false;
//  UserModel userprofile = new UserModel();
//  static const double Amount = 3000;
//  static const double AmountLarger3000 = 2.5;
//  static const double Amountyounger3000 = 100;
//
//  ///  **********************
//  TextEditingController searchText;
//  bool conditions, showpolicy = false;
//  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//
//  ///**************************
//  /// TabController
//  final List<Tab> homeTabs = <Tab>[
//    new Tab(text: 'messages'),
//    new Tab(text: 'baptism'),
//    new Tab(text: 'advertisement'),
//  ];
//  int _selctedIndex, validat = -1;
//
//  // [{"id":2,"role_id":2,"name":"mohamed","phone":"01113985706","email":"mohamed4shim@gmail.com","avatar":"users\/default.png","fcm_token":"vghfhfhghhfhgd","email_verified_at":null,"settings":[],"created_at":"2021-06-06T10:55:27.000000Z","updated_at":"2021-06-06T12:34:51.000000Z"},{"id":3,"role_id":2,"name":"montaser hatem","phone":"01113985706","email":"mont@admin.com","avatar":"users\/default.png","fcm_token":null,"email_verified_at":null,"settings":[],"created_at":"2021-06-09T20:31:17.000000Z","updated_at":"2021-06-09T20:31:17.000000Z"}]
//  ///***********************
//  // List<SupervisorsData> supervisorData;
//  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//  UserModel user = new UserModel();
//  AppLifecycleState _notification;
//  @override
//  void didChangeAppLifecycleState(AppLifecycleState state) {
//    switch (state) {
//      case AppLifecycleState.resumed:
//        handleBackground();
//        break;
//      case AppLifecycleState.inactive:
//        print("app in inactive");
//        break;
//      case AppLifecycleState.paused:
//        print("app in paused");
//        break;
//      case AppLifecycleState.detached:
//        print("app in detached");
//        // refresh();
//        break;
//    }
//  }
//
//  handleBackground() async {
//    bool test = await APICacheManager().isAPICacheKeyExist('back_notify');
//    if (test) {
//      var temp = await APICacheManager().getCacheData('back_notify');
//      if (temp != null) {
//        var data = jsonDecode(temp.syncData);
//        for (var m in data) {
//          if (m['group'] != null) {
//          } else {
//            if (m['message'] != null) {
//              var messageJson = json.decode(m['message']);
//              var message = MessageModal.fromJson(messageJson);
//              await Provider.of<ConversationProvider>(context, listen: false)
//                  .addMessageToConversation(
//                  message.conversationId, message, true);
//            }
//          }
//        }
//        //  handleNotification(data);
//
//      }
//      APICacheManager().deleteCache('back_notify');
//    }
//  }
//
//  refresh() async {
//    await Provider.of<ConversationProvider>(context, listen: false)
//        .concersations
//        .clear();
//    await Provider.of<ConversationProvider>(context, listen: false)
//        .getConversations();
//  }
//
//  @override
//  void initState() {
//    FlutterAppBadger.removeBadge();
//    WidgetsBinding.instance.addObserver(this);
//    searchText = new TextEditingController();
//    conditions = false;
//    _tabController = new TabController(vsync: this, length: homeTabs.length);
//    _selctedIndex = 0;
//
//    setText();
//
//    //setData();
//    super.initState();
//    FirebaseMessaging.onMessageOpenedApp.listen((event) {
//      // FlutterAppBadger.updateBadgeCount(1);
//      print('coms1}');
//      FlutterAppBadger.removeBadge();
//    });
//
//    FirebaseMessaging.onBackgroundMessage((message) {
//      print('coms2 ');
//      handleNotification(message.data);
//    });
//    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//      FlutterAppBadger.updateBadgeCount(1);
//      print('coms ${message.data}');
//      handleNotification(message.data);
//      if (message.notification != null) {
//        print('yeeeees ${message.notification}');
//      }
//    });
////    initConnectivity();
////    _connectivitySubscription =
////        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//    _firebaseMessaging.getToken().then((token) {
//      _firebaseMessaging.subscribeToTopic('group1');
//      // print(token);
//      if (token != null)
//        Provider.of<UserProvider>(context, listen: false).setFcmToken(token);
//    });
//    _sendButtonController = AnimationController(
//      duration: const Duration(milliseconds: 3000),
//      vsync: this,
//    );
//    WidgetsBinding.instance.addPostFrameCallback((_) async {
//      await Provider.of<ConversationProvider>(context, listen: false)
//          .getConversations();
////    await Provider.of<ConversationProvider>(context, listen: false)
////        .concersations.clear();
//      Provider.of<AuthProvider>(context, listen: false)
//          .getUserInfo()
//          .then((value) {
//        if (value != null) {
//          userprofile = value;
//          phone1.text = value.phone;
//        }
//      });
//    });
//  }
//
//  /* Future<void> initConnectivity() async {
//    ConnectivityResult result = ConnectivityResult.none;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      result = await await (Connectivity().checkConnectivity());;
//    } on PlatformException catch (e) {
//      print(e.toString());
//    }
//    if (!mounted) {
//      return Future.value(null);
//    }
//
//    return _updateConnectionStatus(result);
//  }
//  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
//    print('resu $result');
//    switch (result) {
//      case ConnectivityResult.wifi :
//
//        break;
//      case ConnectivityResult.mobile:
//
//        break;
//      case ConnectivityResult.none:
//        setState(() => _connectionStatus = result.toString());
//        Provider.of<ConversationProvider>(context,listen: true).setBusy(false);
//        Provider.of<ConversationProvider>(context,listen: false).getConversationsOffline();
//        Provider.of<AdsProvider>(context,listen: false).getAdsOffline();
//
//        break;
//      default:
//        setState(() => _connectionStatus = 'Failed to get connectivity.');
//        break;
//    }
//  }*/
//  @override
//  void dispose() {
//    WidgetsBinding.instance.removeObserver(this);
//    _tabController.dispose();
//    // _connectivitySubscription.cancel();
//    _sendButtonController.dispose();
//    phone1.dispose();
//    phone2.dispose();
//    kind1.dispose();
//    ownerName.dispose();
//    details.dispose();
//    period.dispose();
//    name.dispose();
//    fee.dispose();
//    total.dispose();
//    bativalue.dispose();
//    super.dispose();
//
//    AuthProvider().dispose();
//    UserProvider().dispose();
//    ConversationProvider().dispose();
//    AdsProvider().dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    Size size = MediaQuery.of(context).size;
//    SizeConfig().init(context);
//
//    var provider = Provider.of<ConversationProvider>(context, listen: true);
//    return AnnotatedRegion<SystemUiOverlayStyle>(
//      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.white),
//      child: SafeArea(
//        child: Scaffold(
//          key: _scaffoldKey,
//          backgroundColor: Colors.white,
//          body:
//          /*provider.busy
//            ? Center(child: CircularProgressIndicator()) : */
//          SingleChildScrollView(
//            child: Column(
//              // shrinkWrap: true,
//                children: <Widget>[
//                  Container(
//                    //  height: size.height / 4 - ScreenUtil().setHeight(15),
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: [
//                        ///********************
//                        ///    header
//                        ///********************
//                        Container(
//                            padding: EdgeInsets.symmetric(
//                                vertical: ScreenUtil().setHeight(15)),
//                            alignment: Alignment.center,
//                            color: Colors.white,
//                            child: Row(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              mainAxisAlignment: MainAxisAlignment.spaceAround,
//                              children: [
//                                Container(
//                                  padding: EdgeInsets.symmetric(
//                                      horizontal: ScreenUtil().setWidth(10)),
//                                  child: Row(
//                                    crossAxisAlignment:
//                                    CrossAxisAlignment.center,
//                                    mainAxisAlignment:
//                                    MainAxisAlignment.spaceAround,
//                                    children: [
//                                      InkWell(
//                                        onTap: () {
//                                          Navigator.of(context)
//                                              .push(MaterialPageRoute(
//                                              builder: (context) =>
//                                                  EditProfile(
//                                                    user: userprofile,
//                                                  )))
//                                              .then((value) async {
//                                            userprofile =
//                                            await Provider.of<AuthProvider>(
//                                                context,
//                                                listen: false)
//                                                .getUserInfo();
//                                          });
//                                        },
//                                        child: Container(
////                                          padding: EdgeInsets.symmetric(
////                                              horizontal: ScreenUtil().setWidth(5)),
//                                          height: ScreenUtil().setWidth(60),
//                                          width: ScreenUtil().setWidth(60),
//                                          child: Container(
//                                            decoration: BoxDecoration(
//                                              shape: BoxShape.circle,
//                                            ),
//                                            child: ClipRRect(
//                                                borderRadius:
//                                                BorderRadius.circular(50),
//                                                child: CachedNetworkImage(
////                                                  height: ScreenUtil().setWidth(100),
////                                                  width: ScreenUtil().setWidth(100),
//                                                  imageUrl:
//                                                  userprofile?.imageUrl ??
//                                                      '',
//                                                  fit: BoxFit.fill,
//                                                  placeholder: (context, url) =>
//                                                      Image.asset(
//                                                        'assets/images/defult_profile.png',
//                                                        fit: BoxFit.fill,
//                                                      ),
////                                                progressIndicatorBuilder: (context, url, downloadProgress) =>
////                                                    CircularProgressIndicator(value: downloadProgress.progress),
//                                                  errorWidget:
//                                                      (context, url, error) =>
//                                                      Image.asset(
//                                                        'assets/images/defult_profile.png',
//                                                        fit: BoxFit.fill,
//                                                      ),
//                                                )),
//                                          ),
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                                Container(
//                                  height: ScreenUtil().setHeight(70),
//                                  width: ScreenUtil().setWidth(50),
//                                  child: Image.asset(
//                                    'assets/images/Theqah_red.png',
//                                    fit: BoxFit.fill,
//                                  ),
//                                  padding: EdgeInsets.symmetric(
//                                    //   horizontal: ScreenUtil().setWidth(10),
//                                      vertical: ScreenUtil().setHeight(5)),
//                                ),
//                                Container(
//                                  child: Row(
//                                    children: [
//                                      InkWell(
//                                        onTap: () async {
//                                          refresh();
////                                          Navigator.of(context)
////                                              .push(MaterialPageRoute(builder: (context)=>SimpleRecorder()));
//                                        },
//                                        child: Container(
//                                          padding: EdgeInsets.all(3),
//                                          margin: EdgeInsets.symmetric(
//                                              horizontal:
//                                              ScreenUtil().setWidth(10)),
//                                          decoration: BoxDecoration(
//                                            color: getColors.lightGrey,
//                                          ),
//                                          child: Icon(
//                                            Icons.refresh_sharp,
//                                            color: Colors.black,
//                                            size: ScreenUtil().setSp(25),
//                                          ),
//                                        ),
//                                      ),
//                                      InkWell(
//                                        onTap: () async {
//                                          Navigator.of(context).pushNamed(
//                                              "profile",
//                                              arguments: userprofile ?? null);
//                                        },
//                                        child: Container(
//                                          padding: EdgeInsets.all(3),
//                                          margin: EdgeInsets.symmetric(
//                                              horizontal:
//                                              ScreenUtil().setWidth(10)),
//                                          decoration: BoxDecoration(
//                                            color: getColors.lightGrey,
//                                          ),
//                                          child: Image.asset(
//                                              "assets/images/setting.png"),
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                )
//                              ],
//                            )),
//
//                        ///********************
//                        ///    Search
//                        ///********************
//                        Padding(
//                          padding: EdgeInsets.symmetric(
//                            horizontal: ScreenUtil().setWidth(20),
//                            vertical: ScreenUtil().setHeight(10),
//                          ),
//                          child: Container(
//                            padding: EdgeInsets.symmetric(
//                                horizontal: 15, vertical: 5),
//                            decoration: BoxDecoration(
//                              borderRadius: BorderRadius.all(
//                                Radius.circular(10),
//                              ),
//                              color: getColors.lightGrey,
//                            ),
//                            child: TextFormField(
//                              controller: searchText,
//                              //  textAlign: TextAlign.center,
//                              onSaved: (val) {},
//                              decoration: new InputDecoration(
//                                hintText: 'search.home'.tr(),
//                                hintStyle:
//                                getTextStyles.textStyleLightGreyNormal16,
//                                labelStyle:
//                                getTextStyles.textStyleBlackNormal18,
//                                border: InputBorder.none,
//                                suffixIcon: Icon(
//                                  Icons.search,
//                                  size: ScreenUtil().setSp(30),
//                                  color: Colors.black45,
//                                ),
//                              ),
//                              // onChanged: onSearchTextChanged,
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                  Container(
//                    height: size.height * 3 / 4 - ScreenUtil().setHeight(15),
//                    child:
//
//                    ///********************
//                    ///    Taps
//                    ///********************
//                    DefaultTabController(
//                      initialIndex: _selctedIndex,
//                      length: homeTabs.length,
//                      child: SizedBox(
////                   height: size.height,
//                        width: size.width,
//                        child: Column(
//                          children: <Widget>[
//                            Stack(
//                              fit: StackFit.passthrough,
//                              alignment: Alignment.bottomCenter,
//                              children: [
//                                Container(
//                                  width: size.width,
//                                  decoration: BoxDecoration(
//                                    color: Colors.white,
//                                    border: Border(
//                                      bottom: BorderSide(
//                                          color: getColors.lightGrey,
//                                          width: 15),
//                                    ),
//                                  ),
//                                ),
//                                TabBar(
//                                  controller: _tabController,
//                                  //  isScrollable: true,
//                                  labelColor: Colors.red,
//                                  unselectedLabelColor: Colors.grey,
//                                  unselectedLabelStyle:
//                                  getTextStyles.textStyleLightGreyBold16,
//                                  labelStyle: getTextStyles.textStyleRedBold16,
//                                  indicatorColor: getColors.red,
//                                  // labelColor: getColors.red,
//                                  indicatorWeight: 15,
//                                  indicatorSize: TabBarIndicatorSize.tab,
//                                  onTap: (val) {
//                                    setState(() {
//                                      _selctedIndex = val;
//                                    });
//                                    if (val == 2)
//                                      Provider.of<AdsProvider>(context,
//                                          listen: false)
//                                          .getAds();
//                                  },
//                                  // automaticIndicatorColorAdjustment: true,
//                                  tabs: List.generate(homeTabs.length, (index) {
//                                    return Container(
//                                        height: ScreenUtil().setHeight(50),
//                                        // width: size.width / 3,
//                                        alignment: Alignment.center,
//                                        color: Colors.white,
//                                        child: FittedBox(
//                                          child: Text(
//                                              '${homeTabs[index].text.tr()}'),
//                                        ));
//                                  }),
//                                ),
//                              ],
//                            ),
//                            Expanded(
//                              child: TabBarView(
//                                  controller: _tabController,
//                                  children: [
//                                    ///message
//                                    provider.concersations != null
//                                        ? provider.concersations.length > 0
//                                        ? ListView.builder(
//                                        physics:
//                                        ClampingScrollPhysics(),
//                                        itemCount: _selctedIndex == 0 &&
//                                            searchText
//                                                .text.isNotEmpty
//                                            ? provider.concersations
//                                            .where((element) =>
//                                            element.user.name
//                                                .contains(
//                                                searchText
//                                                    .text))
//                                            .length
//                                            : provider
//                                            .concersations.length,
//                                        scrollDirection: Axis.vertical,
//                                        shrinkWrap: true,
//                                        itemBuilder:
//                                            (BuildContext context,
//                                            int index) {
//                                          return InkWell(
//                                            onTap: () {
//                                              if (provider.concersations
//                                                  .length >
//                                                  0)
//                                                Navigator.push(
//                                                    context,
//                                                    MaterialPageRoute(
//                                                        builder:
//                                                            (context) =>
//                                                            Messages(
//                                                              data: provider.concersations.length > 0
//                                                                  ? provider.concersations[index]
//                                                                  : null,
//                                                              myId:
//                                                              userprofile?.id,
//                                                            ))).then(
//                                                        (value) async {
////                                         await  Provider.of<ConversationProvider>(context, listen: false)
////                                              .getConversationsOffline();
//                                                    });
//                                            },
//                                            child: provider
//                                                .concersations[
//                                            index]
//                                                .user !=
//                                                null
//                                                ? messageWidget(provider
//                                                .concersations[
//                                            index])
//                                                : Container(),
//                                          );
//                                        })
//                                        : provider.busy
//                                        ? Loading()
//                                        : Center(
//                                        child: Text('empty'.tr()))
//                                        : Container(),
//                                    orderWidget(size),
//                                    Provider.of<AdsProvider>(context, listen: false)
//                                        .ads
//                                        .length >
//                                        0
//                                        ? ListView.builder(
//                                        physics: ClampingScrollPhysics(),
//                                        itemCount: _selctedIndex == 2 &&
//                                            searchText.text.isNotEmpty
//                                            ? Provider.of<AdsProvider>(context,
//                                            listen: false)
//                                            .ads
//                                            .where((element) =>
//                                        element.name.contains(searchText.text) ||
//                                            element.title.contains(
//                                                searchText.text))
//                                            .length
//                                            : Provider.of<AdsProvider>(context,
//                                            listen: false)
//                                            .ads
//                                            .length,
//                                        scrollDirection: Axis.vertical,
//                                        shrinkWrap: true,
//                                        itemBuilder: (BuildContext context,
//                                            int index) {
//                                          return advertisementWidget(
//                                              size,
//                                              Provider.of<AdsProvider>(
//                                                  context,
//                                                  listen: false)
//                                                  .ads[index],
//                                              index);
//                                        })
//                                        : Provider.of<AdsProvider>(context, listen: false).busy
//                                        ? Loading()
//                                        : Center(child: Text('emptyads'.tr())),
//                                  ]),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  )
//                ]),
//          ),
//          floatingActionButton: new FloatingActionButton(
//            onPressed: () async {
//              //  List<ConversationModel> conversation=await provider.concersations.toList();
//
//              await Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => SearchPage(
//                        conversationModel: provider.concersations,
//                      ))).then((value) {
//                provider.concersations.clear();
//                provider.getConversations();
//              });
//            }, // Switch tabs
//            child: new Icon(CupertinoIcons.chat_bubble_text_fill,
//                size: ScreenUtil().setSp(33), color: Colors.white),
//            backgroundColor: Theme.of(context).primaryColor,
//          ),
//        ),
//      ),
//    );
//  }
//
//  String bankTyprEn, bankTyprAr, iban, account_number, account_name;
//  int bankId;
//
//  messageWidget(ConversationModel conversationModel) {
//    return Container(
//      //   width: Size.infinite.width,
//        child: Column(
//          children: [
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: [
//                Container(
//                  margin: EdgeInsets.symmetric(
//                    horizontal: ScreenUtil().setWidth(10),
//                    vertical: ScreenUtil().setHeight(5),
//                  ),
//                  child: Row(
//                    children: [
//                      Stack(
//                        children: [
//                          Container(
//                            margin: EdgeInsets.symmetric(
//                              horizontal: ScreenUtil().setWidth(10),
//                              vertical: ScreenUtil().setHeight(5),
//                            ),
//                            height: ScreenUtil().setWidth(50),
//                            width: ScreenUtil().setWidth(50),
//                            child: ClipRRect(
//                                borderRadius: BorderRadius.circular(50),
//                                child: conversationModel.groupTitle != null
//                                    ? Image.asset(
//                                  'assets/images/Theqah_red.png',
//                                  fit: BoxFit.contain,
//                                )
//                                    : CachedNetworkImage(
//                                  //  height: ScreenUtil().setHeight(50),
//                                  // width: ScreenUtil().setWidth(50),
//                                  imageUrl:
//                                  conversationModel.user?.imageUrl ?? '',
//                                  fit: BoxFit.fill,
//                                  placeholder: (context, url) => Image.asset(
//                                    'assets/images/defult_profile.png',
//                                    fit: BoxFit.fill,
//                                  ),
////                                                progressIndicatorBuilder: (context, url, downloadProgress) =>
////                                                    CircularProgressIndicator(value: downloadProgress.progress),
//                                  errorWidget: (context, url, error) =>
//                                      Image.asset(
//                                        'assets/images/defult_profile.png',
//                                        fit: BoxFit.fill,
//                                      ),
//                                )),
//                          ),
//                          /*  if(conversationModel..online)Positioned(
//                              top: 7,
//                              right: 30,
//                              child: Icon(
//                                Icons.circle,
//                                size: ScreenUtil().setSp(15),
//                                color: Colors.greenAccent,
//                              )),*/
//                          if (conversationModel != null)
//                            if (conversationModel.unread != null)
//                              if (conversationModel.unread > 0)
//                                Positioned(
//                                    bottom: 0,
//                                    right: 30,
//                                    child: Center(
//                                      child: Container(
//                                        alignment: Alignment.center,
//                                        width: ScreenUtil().setWidth(18),
//                                        height: ScreenUtil().setHeight(18),
//                                        decoration: BoxDecoration(
//                                          borderRadius: BorderRadius.all(
//                                            Radius.circular(7),
//                                          ),
//                                          border: Border.all(
//                                              color: Colors.white, width: 1.5),
//                                          color: getColors.red,
//                                        ),
//                                        child: Text(
//                                          '${conversationModel.unread}',
//                                          style: getTextStyles.textStyleWaitNormal9
//                                              .copyWith(fontSize: 11),
//                                        ),
//                                      ),
//                                    )),
//                          Positioned(
//                              top: ScreenUtil().setHeight(8),
//                              right: ScreenUtil().setWidth(15),
//                              child: Container(
//                                alignment: Alignment.center,
//                                width: ScreenUtil().setWidth(10),
//                                height: ScreenUtil().setWidth(10),
//                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.all(
//                                    Radius.circular(6),
//                                  ),
//                                  border:
//                                  Border.all(color: Colors.white, width: 1.5),
//                                  color: conversationModel.user.status == "online"
//                                      ? Colors.green
//                                      : Colors.grey,
//                                ),
//                              ))
//                        ],
//                      ),
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: [
//                          Text(
//                            '${conversationModel.user.name}',
//                            style: getTextStyles.textStyleBlackNormal16.copyWith(
//                                fontWeight: FontWeight.w600,
//                                fontSize: ScreenUtil().setSp(15)),
//                          ),
//                          conversationModel
//                              .messages[
//                          conversationModel.messages.length - 1]
//                              .type ==
//                              0
//                              ? Text(
//                            conversationModel
//                                .messages[conversationModel
//                                .messages.length -
//                                1]
//                                .body
//                                .length >
//                                30
//                                ? '${conversationModel.messages[conversationModel.messages.length - 1].body.substring(0, 30)}...'
//                                : conversationModel
//                                .messages[
//                            conversationModel.messages.length - 1]
//                                .body,
//                            style: getTextStyles.textStyleLightGreyNormal14
//                                .copyWith(color: Colors.grey),
//                          )
//                              : Text('Media Message',
//                              style: getTextStyles.textStyleLightGreyNormal14
//                                  .copyWith(color: Colors.grey))
//                        ],
//                      )
//                    ],
//                  ),
//                ),
//                Padding(
//                  padding: EdgeInsets.symmetric(
//                    horizontal: ScreenUtil().setWidth(20),
//                    //vertical: ScreenUtil().setHeight(10),
//                  ),
//                  child: Row(
//                    children: [
//                      if (conversationModel
//                          .messages[conversationModel.messages.length - 1]
//                          .userId !=
//                          conversationModel.user.id)
//                        Icon(
//                          Icons.done,
//                          size: ScreenUtil().setSp(17),
//                          color: conversationModel
//                              .messages[
//                          conversationModel.messages.length - 1]
//                              .read ==
//                              1
//                              ? getColors.red
//                              : Colors.grey,
//                        ),
////                        Text(timeago.format(DateTime.parse(
////                            conversationModel.messages[conversationModel.messages.length-1].createdAt),locale:
////                        EasyLocalization.of(context).locale.languageCode),
////                          style: TextStyle(
////                            color: Colors.grey,
////                            fontSize: 12.0,
////                          ),),
//                      Text(
//                        getTimeFromDate(DateTime.parse(conversationModel
//                            .messages[conversationModel.messages.length - 1]
//                            .createdAt)),
//                        style: TextStyle(
//                          color: Colors.grey,
//                          fontSize: 12.0,
//                        ),
//                      )
//                    ],
//                  ),
//                )
//              ],
//            ),
//            Padding(
//              padding: EdgeInsets.only(
//                  right: EasyLocalization.of(context).locale.languageCode == 'ar'
//                      ? ScreenUtil().setWidth(80)
//                      : ScreenUtil().setWidth(30),
//                  left: EasyLocalization.of(context).locale.languageCode == 'en'
//                      ? ScreenUtil().setWidth(80)
//                      : ScreenUtil().setWidth(10)),
//              child: Divider(
//                color: Colors.black,
//                thickness: .5,
//              ),
//            )
//          ],
//        ));
//  }
//
//  var focusNode = FocusNode();
//
//  orderWidget(Size size) {
//    return Container(
//        padding: EdgeInsets.symmetric(horizontal: 10),
//        //   width: Size.infinite.width,
//        child: CustomScrollView(
//          slivers: [
//            SliverFillRemaining(
//              hasScrollBody: false,
//              child: Column(
//                children: [
//                  Padding(
//                    padding: EdgeInsets.symmetric(
//                      horizontal: ScreenUtil().setWidth(5),
//                      vertical: ScreenUtil().setHeight(5),
//                    ),
//                    child: Text(
//                      "Application.form".tr(),
//                      style: getTextStyles.textStyleBlackNormal16,
//                    ),
//                  ),
//                  ///The owner of the transaction
//                  GrayInputField(
//                    focusNode: validat == 4 ? focusNode : null,
//                    controller: ownerName,
//                    hintText: 'ownerName',
//                  ),
//                  ///Mobile of the owner of the transaction:
//                  GrayInputField(
//                    controller: phone1,
//                    //  focusNode: validat == 1 ? focusNode : null,
//                    inputType: TextInputType.phone,
//                    enabled: false,
//                    hintText: 'phone.recipient',
//                  ),
//                  ///Almaqab mobile
//                  GrayInputField(
//                    inputType: TextInputType.phone,
//                    focusNode: validat == 2 ? focusNode : null,
//                    controller: phone2,
//                    hintText: 'phone.tracker',
////                maskFormatter: maskFormatter,
//                  ),
//                  ///The value of the baptism:
//                  GrayInputField(
//                    inputType: TextInputType.number,
//                    focusNode: validat == 7 ? focusNode : null,
//                    controller: bativalue,
//                    hintText: 'Baptismal.value',
//                    onChanged: (val) {
//                      if (val.isNotEmpty && !val.contains('-')) {
//                        fee.text = setFee(double.parse(val)).toString();
//                        total.text = setTotal(double.parse(val)).toString();
//                      } else {
//                        fee.text = '0';
//                        total.text = '0';
//                      }
//                    },
//                  ),
//                  ///Baptism fees:
//                  Row(
//                    children: [
//                      Container(
//                          padding: EdgeInsets.symmetric(
//                              horizontal: ScreenUtil().setWidth(10)),
//                          //  width:size.width/2-ScreenUtil().setWidth(20),// Size.infinite.width/2,
//                          child: Text(
//                            "Commission.account".tr(),
//                            style: getTextStyles.textStyleBlackNormal16,
//                          )),
//                      Expanded(
//                        child: Container(
//                          decoration: BoxDecoration(
//                            borderRadius: BorderRadius.all(
//                              Radius.circular(10),
//                            ),
//                            color: getColors.lightGrey,
//                          ),
//                          margin: EdgeInsets.symmetric(
//                            horizontal: ScreenUtil().setWidth(10),
//                            vertical: ScreenUtil().setHeight(4),
//                          ),
//                          // width: size.width / 2, // Size.infinite.width/2,
//                          child: TextFormField(
//                            keyboardType: TextInputType.number,
//                            focusNode: validat == 8 ? focusNode : null,
//                            controller: fee,
//                            enabled: false,
//
//                            decoration: new InputDecoration(
////                        hintText: 'search'.tr(),
//                              hintStyle: getTextStyles.textStyleBlackNormal16,
//                              labelStyle: getTextStyles.textStyleBlackNormal18,
//                              border: InputBorder.none,
//                            ),
//                            // onChanged: onSearchTextChanged,
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                  /// Total amount:
//                  Row(
//                    children: [
//                      Container(
//                          padding: EdgeInsets.symmetric(
//                              horizontal: ScreenUtil().setWidth(10)),
//                          child: Text(
//                            '${"total.amount".tr()}  ',
//                            style: getTextStyles.textStyleBlackNormal16,
//                          )),
//                      Expanded(
//                        child: Container(
//                          decoration: BoxDecoration(
//                            borderRadius: BorderRadius.all(
//                              Radius.circular(10),
//                            ),
//                            color: getColors.lightGrey,
//                          ),
//                          margin: EdgeInsets.symmetric(
//                            horizontal: ScreenUtil().setWidth(10),
//                            vertical: ScreenUtil().setHeight(4),
//                          ),
//                          // width: size.width / 2,
//                          child: TextFormField(
//                            keyboardType: TextInputType.number,
//                            focusNode: validat == 9 ? focusNode : null,
//                            controller: total,
//                            enabled: false,
//                            decoration: new InputDecoration(
////                        hintText: 'search'.tr(),
//                              hintStyle: getTextStyles.textStyleBlackNormal18,
//                              labelStyle: getTextStyles.textStyleBlackNormal18,
//                              border: InputBorder.none,
//                            ),
//                            // onChanged: onSearchTextChanged,
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                  ///Baptism period:
//                  GrayInputField(
//                    controller: period,
//
//                    inputType: TextInputType.number,
//                    focusNode: validat == 5 ? focusNode : null,
//
//                    hintText: 'baptism.days',
//                  ),
//                  ///Details:
//                  GrayInputField(
//                    focusNode: validat == 12 ? focusNode : null,
//                    controller: details,
//                    hintText: 'details',
//                    inputType: TextInputType.multiline,
//                    minLines: 1, //Normal textInputField will be displayed
//                    maxLines: 5, //
//                  ),
//
//
////                  GrayInputField(
////                    focusNode: validat == 3 ? focusNode : null,
////                    controller: kind1,
////                    hintText: 'transaction',
////                  ),
//
//
//
////                  GrayInputField(
////                    focusNode: validat == 6 ? focusNode : null,
////                    controller: name,
////                    hintText: 'name.account',
////                  ),
//
//
//
//
//                  InkWell(
//                    onTap: () async {
//                      var provider =
//                      Provider.of<AdsProvider>(context, listen: false);
//                      await provider.getBanks();
//                      FocusScope.of(context).unfocus();
//                      modalBottomSheetMenu(
//                          context: context,
//                          data: provider.banks,
//                          vacationName: (bank) {
//                            setState(() {
//                              bankTyprEn = bank.name_en;
//                              bankTyprAr = bank.name_ar;
//                              iban = bank.iban;
//                              account_number = bank.account_number;
//                              account_name = bank.account_name;
//                            });
//                          },
//                          vacationId: (val) {
//                            setState(() {
//                              bankId = val;
//                            });
//                          });
//                    },
//                    child: Container(
//                      alignment: Alignment.center,
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.all(
//                          Radius.circular(10),
//                        ),
//                        color: getColors.deepPurple,
//                      ),
//                      margin: EdgeInsets.symmetric(
//                        horizontal: ScreenUtil().setWidth(20),
//                        vertical: ScreenUtil().setHeight(10),
//                      ),
//                      width: size.width,
//                      height: ScreenUtil().setHeight(55),
//                      child: Text(
//                        "Choose.bank".tr(),
//                        style: getTextStyles.textStyleWaitBold16,
//                      ),
//                    ),
//                  ),
//                  /*if(bankId != null) Padding(
//                    padding: EdgeInsets.symmetric(
//                      horizontal: ScreenUtil().setWidth(30),
//                      vertical: ScreenUtil().setHeight(10),
//                    ),
//                    child: Row(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: [
//                        Text(EasyLocalization
//                            .of(context)
//                            .locale
//                            .languageCode == 'en' ? bankTyprEn : bankTyprAr,
//                          style: getTextStyles.textStyleBlackNormal16,),
//                        Container(
//                          padding: EdgeInsets.symmetric(
//                            horizontal: ScreenUtil().setWidth(3),
//                            vertical: ScreenUtil().setHeight(3),
//                          ),
//                          child: Icon(Icons.arrow_forward_ios_outlined,
//                            size: ScreenUtil().setSp(20), color: Colors.white,
//                          ),
//                          decoration: BoxDecoration(
//                            borderRadius: BorderRadius.all(
//                              Radius.circular(5),
//                            ),
//                            color: getColors.red,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),*/
//                  if (bankId != null)
//                    Padding(
//                      padding: EdgeInsets.symmetric(
//                        horizontal: ScreenUtil().setWidth(30),
//                        vertical: ScreenUtil().setHeight(10),
//                      ),
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: [
//                          Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: [
//                              Text(
//                                EasyLocalization.of(context)
//                                    .locale
//                                    .languageCode ==
//                                    'en'
//                                    ? bankTyprEn
//                                    : bankTyprAr,
//                                style: getTextStyles.textStyleBlackNormal16,
//                              ),
//                              Container(
//                                padding: EdgeInsets.symmetric(
//                                  horizontal: ScreenUtil().setWidth(3),
//                                  vertical: ScreenUtil().setHeight(3),
//                                ),
//                                child: Icon(
//                                  Icons.arrow_forward_ios_outlined,
//                                  size: ScreenUtil().setSp(20),
//                                  color: Colors.white,
//                                ),
//                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.all(
//                                    Radius.circular(5),
//                                  ),
//                                  color: getColors.red,
//                                ),
//                              ),
//                            ],
//                          ),
//                          Text(
//                            "${account_name}",
//                            style: getTextStyles.textStyleBlackNormal16,
//                          ),
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: [
//                              Text(
//                                "${"account".tr()}",
//                                style: getTextStyles.textStyleBlackNormal16,
//                              ),
//                              Text(
//                                "$account_number",
//                                style: getTextStyles.textStyleRedNormal16,
//                              ),
//                            ],
//                          ),
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: [
//                              Text(
//                                "iban".tr(),
//                                style: getTextStyles.textStyleBlackNormal16,
//                              ),
//                              Text(
//                                "$iban",
//                                style: getTextStyles.textStyleBlackNormal16,
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  InkWell(
//                    onTap: () {
//                      setState(() {
//                        conditions = !conditions;
//                      });
//                    },
//                    child: Container(
//                      padding: EdgeInsets.symmetric(
//                        horizontal: ScreenUtil().setWidth(10),
//                        vertical: ScreenUtil().setHeight(3),
//                      ),
//                      child: Row(
//                        children: [
//                          Checkbox(
//                              value: conditions,
//                              onChanged: (val) {
//                                setState(() {
//                                  conditions = val;
//                                });
//                              }),
//                          Text(
//                            "conditions1".tr(),
//                            style: getTextStyles.textStyleBlackNormal16,
//                          ),
//                          InkWell(
//                            onTap: () {
//                              showConditions(context);
//                            },
//                            child: Text(
//                              "conditions2".tr(),
//                              style: getTextStyles.textStyleRedNormal16,
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                  StaggerAnimation(
//                    titleButton: 'send'.tr(),
//                    buttonController: _sendButtonController.view,
//                    onTap: () async {
//                      if (!isLoading) {
//                        setState(() {
//                          validat = validate();
//                        });
//
//                        if (validat == 0) {
//                          _playAnimation();
//                          var data = {
//                            'emp_phone': phone2.text,
//                            'owner_phone': phone1.text,
//                            //'type': kind1.text,
//                            'owner_name': ownerName.text,
//                            'details': details.text,
//                            'period': period.text,
//                            //   'account_name': name.text,
//                            'commission': fee.text,
//                            'total': total.text,
//                            'price': bativalue.text,
//                            'bank_type': '$bankId',
//                            //  'user_id': '1'
//                          };
//
//                          AdsService().savebaptisms(data).then((value) async {
//                            print('lara ${value.body}');
//                            _stopAnimation();
//                            setState(() {
//                              validat = -1;
//                            });
//                            if (value.statusCode == 201) {
//                              var res = jsonDecode(value.body);
//                              AwesomeDialog(
//                                  context: context,
//                                  animType: AnimType.LEFTSLIDE,
//                                  headerAnimationLoop: false,
//                                  dialogType: DialogType.SUCCES,
//                                  dismissOnBackKeyPress: false,
//                                  dismissOnTouchOutside: false,
////                title: "order.successful.title",
////                desc: "order.successful.desc",
//                                  body: Column(
//                                    crossAxisAlignment:
//                                    CrossAxisAlignment.center,
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    children: [
//                                      Text(
//                                        "order.successful.title".tr(),
//                                        style: TextStyle(
//                                            fontSize: 18,
//                                            fontWeight: FontWeight.bold),
//                                      ),
//                                      Text(
//                                        '${res['data']['group_title']}',
//                                        style: TextStyle(
//                                            fontSize: 16,
//                                            fontWeight: FontWeight.normal,
//                                            color: Colors.grey),
//                                      ),
//                                      Text(
//                                        "order.successful.desc".tr(),
//                                        style: TextStyle(
//                                            fontSize: 16,
//                                            fontWeight: FontWeight.normal,
//                                            color: Colors.black),
//                                        textAlign: TextAlign.center,
//                                      )
//                                    ],
//                                  ),
//                                  btnOkText: "ok".tr(),
//                                  btnOkColor: Colors.red,
//                                  btnOkOnPress: () {
//                                    _tabController.animateTo(0);
//                                  },
//                                  onDissmissCallback: (type) {})
//                                ..show();
//                              setState(() {
//                                bankId = null;
//                                _selctedIndex = 0;
//                              });
//                              await Provider.of<ConversationProvider>(context,
//                                  listen: false)
//                                  .concersations
//                                  .clear();
//                              await Provider.of<ConversationProvider>(context,
//                                  listen: false)
//                                  .getConversations();
//                              setText();
//                            }
//                          });
//                        }
//                      }
//                    },
//                  ),
//                  SizedBox(
//                    height: ScreenUtil().setHeight(50),
//                  )
//                ],
//              ),
//            ),
//          ],
//        ));
//  }
//
//  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
//  advertisementWidget(Size size, AdModel model, index) {
//    return Container(
//      margin: EdgeInsets.symmetric(
//        horizontal: ScreenUtil().setWidth(10),
//        vertical: ScreenUtil().setHeight(10),
//      ),
//      padding: EdgeInsets.symmetric(
//        horizontal: ScreenUtil().setWidth(15),
//        vertical: ScreenUtil().setHeight(15),
//      ),
//      child: ExpansionTileCard(
//        leading: Container(
////                  height: ScreenUtil().setHeight(130),
//          child: model.image != null
//              ? CircleAvatar(
//            radius: 30,
//            backgroundImage: NetworkImage(
//              model.userImage,
//            ),
////                        child: Image.asset(
////                          'assets/images/profile.jpg',
////                          height: ScreenUtil().setHeight(130),
////                          fit: BoxFit.fill,
////                        )
//          )
//              : CircleAvatar(
//            radius: 30,
//            backgroundImage: AssetImage(
//              'assets/images/userImage.png',
//            ),
////                        child: Image.asset(
////                          'assets/images/profile.jpg',
////                          height: ScreenUtil().setHeight(130),
////                          fit: BoxFit.fill,
////                        )
//          ),
//        ),
//        title: Text(
//          model.name,
//          style: getTextStyles.textStyleBlackBold16,
//        ),
//        subtitle: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: [
//            Text(
//              model.title,
////                            overflow: TextOverflow.fade,
//              style: getTextStyles.textStyleBlackNormal13,
//            ),
//            if (model.location != null)
//              Padding(
//                padding: EdgeInsets.symmetric(
//                  vertical: ScreenUtil().setHeight(2),
//                ),
//                child: Row(
//                  children: [
//                    Icon(
//                      Icons.location_on,
//                      size: ScreenUtil().setSp(20),
//                      color: getColors.red,
//                    ),
//                    Text(
//                      model.location,
//                      style: getTextStyles.textStyleBlackNormal11,
//                    ),
//                  ],
//                ),
//              ),
//            Padding(
//              padding: EdgeInsets.symmetric(
//                vertical: ScreenUtil().setHeight(2),
//              ),
//              child: Row(
//                children: [
//                  Icon(
//                    CupertinoIcons.time_solid,
//                    size: ScreenUtil().setSp(20),
//                    color: getColors.red,
//                  ),
//                  Text(
//                    getTimeFromDate(DateTime.parse(model.createdAt)),
//                    style: TextStyle(
//                      // color: lightGrey,
//                      fontSize: 12.0,
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//        borderRadius: BorderRadius.all(
//          Radius.circular(10),
//        ),
//        children: <Widget>[
//          Divider(
//            thickness: 1.0,
//            height: 1.0,
//          ),
//          Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: [
//              Html(
//                data: model.description,
//              ),
//              ClipRRect(
//                  borderRadius: BorderRadius.circular(10),
//                  child: CachedNetworkImage(
//                    height: ScreenUtil().setHeight(200),
//                    width: ScreenUtil().setWidth(200),
//                    imageUrl: model.image ?? '/',
//                    fit: BoxFit.fill,
//                    placeholder: (context, url) => Image.asset(
//                      'assets/images/place.png',
//                      fit: BoxFit.fill,
//                    ),
////                                                progressIndicatorBuilder: (context, url, downloadProgress) =>
////                                                    CircularProgressIndicator(value: downloadProgress.progress),
//                    errorWidget: (context, url, error) => Image.asset(
//                      'assets/images/place.png',
//                      fit: BoxFit.fill,
//                    ),
//                  ))
//            ],
//          ),
//        ],
//      ),
//    );
//  }
//
//  int validate() {
//    if (ownerName.text == null || ownerName.text.isEmpty) {
//      focusNode = new FocusNode();
//
//      focusNode.requestFocus();
//      _showScaffold('Field.input'.tr());
//      return 4;
//    }
//    if (phone2.text == null || phone2.text.isEmpty) {
//      focusNode = new FocusNode();
//
//      focusNode.requestFocus();
//      _showScaffold('Field.input'.tr());
//      return 2;
//    }
//    if (bativalue.text == null || bativalue.text.isEmpty) {
//      focusNode = new FocusNode();
//
//      focusNode.requestFocus();
//      _showScaffold('Field.input'.tr());
//      return 7;
//    }
//    if (period.text == null || period.text.isEmpty) {
//      focusNode = new FocusNode();
//
//      focusNode.requestFocus();
//      _showScaffold('Field.input'.tr());
//      return 5;
//    }
//    if (details.text == null || details.text.isEmpty) {
//      focusNode = new FocusNode();
//      focusNode.requestFocus();
//      _showScaffold('Field.input'.tr());
//      return 12;
//    }
//    if (phone1.text == null || phone1.text.isEmpty) {
//      //focusNode = new FocusNode();
//      focusNode.requestFocus();
//      _showScaffold('Field.input'.tr());
//      return 1;
//    }
//    //return 1;
//
//    if (phone2.text.length != 10) {
//      focusNode = new FocusNode();
//
//      focusNode.requestFocus();
//      _showScaffold("Please.input.phone".tr());
//      return 2;
//    }
////    if (kind1.text == null || kind1.text.isEmpty) {
////      focusNode = new FocusNode();
////
////      focusNode.requestFocus();
////      _showScaffold('Field.input'.tr());
////      return 3;
////    }
//
//
////    if (name.text == null || name.text.isEmpty) {
////      focusNode = new FocusNode();
////
////      focusNode.requestFocus();
////      _showScaffold('Field.input'.tr());
////      return 6;
////    }
//
//    if (fee.text == null || fee.text.isEmpty) {
//      focusNode = new FocusNode();
//
//      focusNode.requestFocus();
//      _showScaffold('Field.input'.tr());
//      return 8;
//    }
//    if (total.text == null || total.text.isEmpty) {
//      focusNode = new FocusNode();
//
//      focusNode.requestFocus();
//      _showScaffold('Field.input'.tr());
//      return 9;
//    }
//    if (bankId == null) {
//      _showScaffold('Bank.select'.tr());
//      return 10;
//    }
//    if (!conditions) {
//      _showScaffold('Condition.agree'.tr());
//      return 11;
//    }
//
//    return 0;
//  }
//
//  Future<Null> _playAnimation() async {
//    try {
//      setState(() {
//        isLoading = true;
//      });
//      await _sendButtonController.forward();
//    } on TickerCanceled {
//      // printLog('[_playAnimation] error');
//    }
//  }
//
//  Future<Null> _stopAnimation() async {
//    try {
//      await _sendButtonController.reverse();
//      setState(() {
//        isLoading = false;
//      });
//    } on TickerCanceled {
//      //printLog('[_stopAnimation] error');
//    }
//  }
//
//  void _showScaffold(String message) {
//    _scaffoldKey.currentState.showSnackBar(SnackBar(
//      backgroundColor: Colors.blueAccent,
//      duration: Duration(milliseconds: 1500),
//      content: Text(message,
//          textAlign: TextAlign.center, style: TextStyle(fontSize: 17.0)),
//    ));
//  }
//
//  getTimeFromDate(DateTime dateTime) {
//    return "${dateTime.hour}:${dateTime.minute}";
//  }
//
//  setText() async {
//    conditions = false;
//    phone2.text = '';
//    // kind1.text='';
//    ownerName.text = '';
//    details.text = '';
//    period.text='';
////    name.text = '';
//    fee.text = '';
//    total.text = '';
//    bativalue.text = '';
//  }
//
//  handleNotification(data) async {
//    if (data['group'] != null) {
//      Provider.of<ConversationProvider>(context, listen: false)
//          .concersations
//          .clear();
//      await Provider.of<ConversationProvider>(context, listen: false)
//          .getConversations();
//    } else {
//      var messageJson = json.decode(data['message']);
//      var message = MessageModal.fromJson(messageJson);
//      Provider.of<ConversationProvider>(context, listen: false)
//          .addMessageToConversation(message.conversationId, message, true);
//    }
//  }
//
//  double setFee(double value) {
//    if (value > 0) {
//      return value < Amount
//          ? Amountyounger3000
//          : ((value * AmountLarger3000) / 100);
//    } else
//      return 0;
//  }
//
//  double setTotal(double value) {
//    if (value > 0) {
//      return value < Amount
//          ? (value + Amountyounger3000)
//          : (value + (value * AmountLarger3000) / 100);
//    } else
//      return 0;
//  }
//
//  showConditions(BuildContext context) {
//    AdsService().getConditions().then((value) {
//      var data = jsonDecode(value.body);
//      return showDialog(
//        barrierDismissible: true,
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            //  title: const Text(t),
//            content: value == null
//                ? Loading()
//                : SingleChildScrollView(
//              child: Container(
//                padding: EdgeInsets.all(15),
//
//                child: SingleChildScrollView(
//                  child: Column(
//                    children: <Widget>[
//                      new Text(
//                        '${data['title']}',
//                      ),
//                      new Container(
//                          margin: new EdgeInsets.symmetric(vertical: 8.0),
//                          height: 2.0,
//                          width: 18.0,
//                          color: getColors.red),
//                      new Text('${removeAllHtmlTags(data['body'])}',
//                          style: TextStyle(fontWeight: FontWeight.w400)),
//                    ],
//                  ),
//                ),
//                // margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),
//              ),
//            ),
//            actions: <Widget>[
////              TextButton(
////                  style: TextButton.styleFrom(primary: Colors.blue),
////                  onPressed: () {
////                    setState(() {
////                      showpolicy=false;
////                    });
////                  },
////                  child:  Text('ok'.tr())),
//            ],
//          );
//        },
//      );
//    });
//  }
//}
//
////////////////////////
