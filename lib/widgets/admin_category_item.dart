import 'package:admin_panel_coupons/constants.dart';
import 'package:admin_panel_coupons/providers/categories_provider.dart';
import 'package:admin_panel_coupons/screens/edit_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminCategoryItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  AdminCategoryItem(this.id, this.title, this.imageUrl);

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
                  .pushNamed(EditCategoryScreen.routeName, arguments: id);
            },
            icon: Icon(Icons.edit),
          ),
          SizedBox(width: defaultPadding * 2),
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text('حذف القسم'),
                        content: Text('تأكيد حذف القسم؟'),
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
                                  await Provider.of<CategoriesProvider>(context,
                                          listen: false)
                                      .deleteCategory(id);
                                } catch (error) {
                                  scaffoldMessenger.showSnackBar(SnackBar(
                                    content: Text(
                                      'فشل حذف القسم. برجاء التحقق من الانترنت.',
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
