import 'package:admin_panel_coupons/providers/edit_widget_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Listen to changes in edits area widget
    final providedWidget = Provider.of<EditWidgetState>(context);

    return SafeArea(
      child: SingleChildScrollView(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 2,
                      vertical: defaultPadding / 2,
                    ),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      // border: Border.all(color: Colors.white10),
                    ),
                    child: Text(
                      "لوحة التحكم",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: providedWidget.switchedWidget,
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
