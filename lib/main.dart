import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:raid/provider/AuthProvider.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/provider/PostProvider.dart';
import 'package:raid/provider/settings.dart';
import 'package:raid/ui/Home.dart';
import 'package:raid/ui/Profile/Profile.dart';
import 'package:raid/ui/Salesperson/ProductReport.dart';
import 'package:raid/ui/Salesperson/customerReports.dart';
import 'package:raid/ui/Salesperson/invoice.dart';
import 'package:raid/ui/Salesperson/returns.dart';
import 'package:raid/ui/Salesperson/returns_store.dart';
import 'package:raid/ui/Salesperson/sales_person.dart';
import 'package:raid/ui/admin/addCustomer.dart';
import 'package:raid/ui/admin/addExpenses.dart';
import 'package:raid/ui/admin/addProduct.dart';
import 'package:raid/ui/admin/sup_invoice.dart';
import 'package:raid/ui/auth_page.dart';
import 'package:raid/ui/matches.dart';
import 'package:raid/ui/onboard.dart';
import 'package:raid/ui/our_service.dart';

import 'constants.dart';
import 'ui/admin/addSupplier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(EasyLocalization(
      supportedLocales: [Locale('ar', 'SA'), Locale('en', 'US')],
      path: 'assets/lang', // <-- change patch to your
      fallbackLocale: Locale('ar', 'SA'),
      saveLocale: false, //saveLocale: true,
      startLocale: Locale('ar', 'SA'),
      child: MultiProvider(providers: [
        ChangeNotifierProvider<Setting>(
          create: (_) => Setting(),
        ),
        ChangeNotifierProvider<GetProvider>(
          create: (_) => GetProvider(),
        ),
        ChangeNotifierProvider<PostProvider>(
          create: (_) => PostProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
      ], child: MyApp()))));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Setting>(
        create: (BuildContext context) => Setting(),
        child: Consumer<Setting>(builder: (context, model, __) {
          model.checkLogin();
          model.changeLanguage(EasyLocalization.of(context).locale);
          return ScreenUtilInit(
            designSize: Size(480, 800),
            builder: () => MaterialApp(
              key: ValueKey<Locale>(context.locale),
              debugShowCheckedModeBanner: false,
              title: 'الرائد والقناص',
              theme: ThemeData(
                fontFamily: GoogleFonts.elMessiri().fontFamily,
                primaryColor: PrimaryColor,
                accentColor: AccentColor,
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
              ),
              supportedLocales: EasyLocalization.of(context).supportedLocales,
              locale: model.appLocal,
              localizationsDelegates: context.localizationDelegates,
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
                  if (locale.languageCode == deviceLocale.languageCode &&
                      locale.countryCode == deviceLocale.countryCode) {
                    return deviceLocale;
                  }
                }
                return supportedLocales.first;
              },
              initialRoute: '/', //model.login?'main':'login',
              routes: {
                'home': (context) => Home(),
                '/': (context) => OnBoard(),
                'sales_person': (context) => SalesPerson(),
                'login': (context) => AuthPage(),
                'ourservice': (context) => OurService(),
                'returns': (context) => Returns(),
                'matches': (context) => Matches(),
                'return_store': (context) => ReturnStore(),
                'profile': (context) => Profile(),
                'summary': (context) => Summary(),
                'invoice': (context) => Invoice(),
                'buy': (context) => SupInvoice(),
                'productReport': (context) => ProductReport(),
                'addExpense': (context) => AddExpense(),
                'addCustomer': (context) => AddCustomer(),
                'addSupplier': (context) => AddSupplier(),
                'addProduct': (context) => AddProduct(),
              },
            ),
          );
        }));
  }
}
