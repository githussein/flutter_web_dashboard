import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../providers/requests_provider.dart';

class AdminRequestItem extends StatelessWidget {
  final String id;
  final String userName;
  final String email;
  final String store;
  final String link;

  AdminRequestItem(this.id, this.userName, this.email, this.store, this.link);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            store,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(userName),
          Text(email, textDirection: TextDirection.ltr),
          Text(link, textDirection: TextDirection.ltr),
        ],
      ),
      trailing: Container(
        width: 150,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                _openLink(link);
              },
              icon: Icon(Icons.launch),
            ),
            SizedBox(width: defaultPadding * 2),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('حذف الطلب'),
                          content: Text('تأكيد حذف الطلب؟'),
                          actions: [
                            MaterialButton(
                                child: Text(
                                  'إلغاء',
                                ),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                }),
                            MaterialButton(
                                child: Text(
                                  'حذف',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  try {
                                    await Provider.of<RequestsProvider>(context,
                                            listen: false)
                                        .deleteRequest(id);
                                  } catch (error) {
                                    scaffoldMessenger.showSnackBar(SnackBar(
                                      content: Text(
                                        'فشل الحذف. برجاء التحقق من الانترنت.',
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                                  }
                                  Navigator.of(ctx).pop();
                                }),
                          ],
                        ));
              },
              icon: Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  // void _openLink(String url) async {
  //   await canLaunch(url) ? await launch(url) : throw 'Could not launch ';
  // }

  Future<void> _openLink(String url) async {
    if (await canLaunch(url)) {
      print('if (await canLaunch(url)');
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      print('throw error!');
      throw 'Could not launch $url';
    }
  }
}
