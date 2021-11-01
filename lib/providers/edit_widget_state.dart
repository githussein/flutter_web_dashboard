import 'package:admin_panel_coupons/screens/manage_coupons_screen.dart';
import 'package:admin_panel_coupons/screens/manage_offers_screen.dart';
import 'package:admin_panel_coupons/screens/manage_requests_screen.dart';
import 'package:flutter/material.dart';

// enum WidgetMode { COUPONS, OFFERS, REQUESTS }

class EditWidgetState with ChangeNotifier {
  StatelessWidget switchedWidget = ManageCouponsScreen();

  void changeWidgetMode(String mode) {
    switch (mode) {
      case "coupons":
        print("SWITCH TO COUPONS");
        switchedWidget = ManageCouponsScreen();
        break;
      case "offers":
        print("SWITCH TO OFFERS");
        switchedWidget = ManageOffersScreen();
        break;
      case "requests":
        print("SWITCH TO REQUESTS");
        switchedWidget = ManageRequestsScreen();
        break;

      default:
        break;
    }
    notifyListeners();
  }
}
