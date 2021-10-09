import 'package:admin_panel_coupons/screens/main/components/side_menu.dart';
import 'package:admin_panel_coupons/screens/manage_coupons_screen.dart';
import 'package:flutter/material.dart';

// enum WidgetMode { COUPONS, OFFERS, REQUESTS }

class EditWidgetState with ChangeNotifier {
  String _widgetMode = "coupons";
  StatelessWidget switchedWidget = Container();

  void changeWidgetMode(String mode) {
    switch (mode) {
      case "coupons":
        print("SWITCH TO COUPONS");
        switchedWidget = ManageCouponsScreen();
        break;
      case "offers":
        print("SWITCH TO OFFERS");
        switchedWidget = Container(height: 400, color: Colors.green);
        break;
      default:
        break;
    }
    notifyListeners();
  }
}
