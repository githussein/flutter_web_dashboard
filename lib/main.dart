import 'package:admin_panel_coupons/providers/edit_widget_state.dart';
import 'package:admin_panel_coupons/providers/offers_provider.dart';
import 'package:admin_panel_coupons/providers/requests_provider.dart';
import 'package:admin_panel_coupons/screens/edit_coupon_screen.dart';
import 'package:admin_panel_coupons/screens/edit_offer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'constants.dart';
import 'screens/main/main_screen.dart';
import 'package:admin_panel_coupons/providers/coupons_provider.dart';

void main() {
  runApp(MyApp());
}

enum WidgetMode { COUPONS, OFFERS, REQUESTS }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(WidgetMode);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CouponsProvider()),
        ChangeNotifierProvider(create: (context) => OffersProvider()),
        ChangeNotifierProvider(create: (context) => RequestsProvider()),
        ChangeNotifierProvider(create: (context) => EditWidgetState()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          // Locale("en", "US"),
          Locale("ar", ""), // Control panel only in Arabic
        ],
        debugShowCheckedModeBanner: false,
        title: 'لوحة تحكم التطبيق',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        routes: {
          EditCouponScreen.routeName: (ctx) => EditCouponScreen(),
          EditOfferScreen.routeName: (ctx) => EditOfferScreen(),
        },
        home: MainScreen(),
      ),
    );
  }
}
