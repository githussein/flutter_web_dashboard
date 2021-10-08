import 'package:admin_panel_coupons/screens/manage_coupons_screen.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "لوحة التحكم",
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: ManageCouponsScreen(),
                  ),
                  SizedBox(width: defaultPadding),
                  Expanded(
                    flex: 2,
                    child: Image.asset("assets/images/logo.png", height: 100),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
