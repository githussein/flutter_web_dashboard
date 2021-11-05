import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

import '../../../providers/edit_widget_state.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<QuerySnapshot>(context);

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Image.asset("assets/images/logo.png", width: 80)),
          // DrawerListTile(
          //   title: "الرئيسية",
          //   svgSrc: "assets/icons/menu_dashboard.svg",
          //   press: () {},
          // ),
          DrawerListTile(
            title: "تعديل الكوبونات",
            svgSrc: "assets/icons/drop_box.svg",
            press: () {
              Provider.of<EditWidgetState>(context, listen: false)
                  .changeWidgetMode("coupons");
            },
          ),
          DrawerListTile(
            title: "تعديل العروض",
            svgSrc: "assets/icons/Documents.svg",
            press: () {
              Provider.of<EditWidgetState>(context, listen: false)
                  .changeWidgetMode("offers");
            },
          ),
          DrawerListTile(
            title: "تعديل الأقسام",
            svgSrc: "assets/icons/google_drive.svg",
            press: () {
              Provider.of<EditWidgetState>(context, listen: false)
                  .changeWidgetMode("categories");
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
          DrawerListTile(
            title: "بيانات المستخدمين",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () => {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text('بيانات المستخدمين'),
                        content: Text('هل تريد تحميل بيانات المستخدمين؟'),
                        actions: [
                          MaterialButton(
                              child: Text(
                                'إلغـاء',
                              ),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              }),
                          MaterialButton(
                              child: Text(
                                'تحـميــل',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                try {
                                  createExcel(users);
                                } catch (error) {
                                  scaffoldMessenger.showSnackBar(SnackBar(
                                    content: Text(
                                      'فشل تحميل الملف. برجاء التحقق من الانترنت.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ));
                                }
                                Navigator.of(ctx).pop();
                              }),
                        ],
                      ))
            },
          ),
        ],
      ),
    );
  }

  Future<void> createExcel(QuerySnapshot<Object> users) async {
    //create a workbook with one worksheet
    final Workbook workbook = Workbook();
    final Worksheet worksheet = workbook.worksheets[0];

    //Parse table head
    worksheet.getRangeByIndex(1, 1).setText('م');
    worksheet.getRangeByIndex(1, 2).setText('الاسم');
    worksheet.getRangeByIndex(1, 3).setText('الايميل');
    worksheet.getRangeByIndex(1, 4).setText('البلد');
    worksheet.getRangeByIndex(1, 5).setText('السن');
    worksheet.getRangeByIndex(1, 6).setText('الموبايل');
    worksheet.getRangeByIndex(1, 7).setText('النوع');

    //parse table body
    List<QueryDocumentSnapshot<Object>> user = users.docs;
    for (int i = 0; i < users.docs.length; i++) {
      //Row i+2, column (fixed)
      worksheet.getRangeByIndex(i + 2, 1).setText('${i + 1}');
      worksheet.getRangeByIndex(i + 2, 2).setText(user[i].get('name') ?? '');
      worksheet.getRangeByIndex(i + 2, 3).setText(user[i].get('email') ?? '');
      worksheet.getRangeByIndex(i + 2, 4).setText(user[i].get('country') ?? '');
      worksheet.getRangeByIndex(i + 2, 5).setText(user[i].get('age') ?? '');
      worksheet.getRangeByIndex(i + 2, 6).setText(user[i].get('phone') ?? '');
      worksheet.getRangeByIndex(i + 2, 7).setText(user[i].get('gender') ?? '');
    }

    //to save as an excel file, get the document as bytes
    final List<int> bytes = workbook.saveAsStream();
    //release the resources used
    workbook.dispose();

    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'User Data.xlsx')
        ..click();
    } else {
      //save it as a xlsx file
      //pubspec.yaml -> import path_provider and open_file
      final String path = (await getApplicationSupportDirectory()).path;
      //store the physical path of the file with xlsx extension
      final String fileName = '$path/User Data.xlsx';
      //create a file in the path with this file name
      final File file = File(fileName);
      //write the bytes to the file
      await file.writeAsBytes(bytes, flush: true);
    }
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
