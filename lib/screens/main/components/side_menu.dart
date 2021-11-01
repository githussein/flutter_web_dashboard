import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/edit_widget_state.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
                child: Image.asset("assets/images/logo.png", width: 80)),
            // DrawerListTile(
            //   title: "الرئيسية",
            //   svgSrc: "assets/icons/menu_dashboard.svg",
            //   press: () {},
            // ),
            DrawerListTile(
              title: "تعديل الكوبونات",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () {
                Provider.of<EditWidgetState>(context, listen: false)
                    .changeWidgetMode("coupons");
              },
            ),
            DrawerListTile(
              title: "تعديل العروض",
              svgSrc: "assets/icons/menu_store.svg",
              press: () {
                Provider.of<EditWidgetState>(context, listen: false)
                    .changeWidgetMode("offers");
              },
            ),
            DrawerListTile(
              title: "طلبات الكوبونات",
              svgSrc: "assets/icons/menu_doc.svg",
              press: () {
                Provider.of<EditWidgetState>(context, listen: false)
                    .changeWidgetMode("requests");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key key,
    @required this.title,
    @required this.svgSrc,
    @required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(svgSrc, color: Colors.white60),
      title: Text(title, style: TextStyle(color: Colors.white60)),
    );
  }
}
