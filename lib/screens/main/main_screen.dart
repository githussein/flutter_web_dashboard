import 'package:flutter/material.dart';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SideMenu(),
            Expanded(
                flex: 5, // takes5/6 of the screen
                child: Container(
                  color: Colors.blue,
                )),
          ],
        ),
      ),
    );
  }
}
