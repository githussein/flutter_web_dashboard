import 'package:admin_panel_coupons/providers/categories_provider.dart';
import 'package:admin_panel_coupons/screens/edit_category_screen.dart';
import 'package:admin_panel_coupons/screens/edit_coupon_screen.dart';
import 'package:admin_panel_coupons/widgets/admin_category_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../screens/edit_coupon_screen.dart';
import '../constants.dart';
import '../providers/coupons_provider.dart';
import '../widgets/admin_coupon_item.dart';
// import '../widgets/app_drawer.dart';

class ManageCategoriesScreen extends StatelessWidget {
  static const routeName = '/manage-categories';

  //function to handle Refresh Indicator
  Future<void> _refreshCategories(BuildContext ctx) async {
    await Provider.of<CategoriesProvider>(ctx, listen: false).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    //Listen to changes in the categories list
    final categoriesData = Provider.of<CategoriesProvider>(context);
    return RefreshIndicator(
      onRefresh: () => _refreshCategories(context),
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: defaultPadding * 3),
              child: MaterialButton(
                  elevation: 4,
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding * 2),
                  color: Colors.green.shade700,
                  child: Text(
                    'إضافة قسم ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditCategoryScreen.routeName);
                  }),
            ),
            SizedBox(height: defaultPadding),
            ListView.builder(
              shrinkWrap: true,
              itemCount: categoriesData.items.length,
              itemBuilder: (_, i) => Column(
                children: [
                  AdminCategoryItem(
                    categoriesData.items[i].id,
                    categoriesData.items[i].title,
                    categoriesData.items[i].imageUrl,
                  ),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: defaultPadding * 3),
                      child: Divider()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
