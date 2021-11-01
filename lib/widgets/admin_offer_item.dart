import 'package:admin_panel_coupons/screens/edit_offer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../screens/edit_offer_screen.dart';
import '../constants.dart';
import '../providers/offers_provider.dart';

class AdminOfferItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  AdminOfferItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 150,
        child: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditOfferScreen.routeName, arguments: id);
            },
            icon: Icon(Icons.edit),
          ),
          SizedBox(width: defaultPadding * 2),
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text('حذف العرض'),
                        content: Text('تأكيد حذف العرض؟'),
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
                                  await Provider.of<OffersProvider>(context,
                                          listen: false)
                                      .deleteOffer(id);
                                } catch (error) {
                                  scaffoldMessenger.showSnackBar(SnackBar(
                                    content: Text(
                                      'فشل حذف العرض. برجاء التحقق من الانترنت.',
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
        ]),
      ),
    );
  }
}
