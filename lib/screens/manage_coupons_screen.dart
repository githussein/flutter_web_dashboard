import 'package:admin_panel_coupons/screens/edit_coupon_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../screens/edit_coupon_screen.dart';
import '../constants.dart';
import '../providers/coupons_provider.dart';
import '../widgets/admin_coupon_item.dart';
// import '../widgets/app_drawer.dart';

class ManageCouponsScreen extends StatelessWidget {
  static const routeName = '/manage-coupons';

  //function to handle Refresh Indicator
  Future<void> _refreshCoupons(BuildContext ctx) async {
    await Provider.of<CouponsProvider>(ctx, listen: false).fetchCoupons();
  }

  @override
  Widget build(BuildContext context) {
    //Listen to changes in the coupons list
    final couponsData = Provider.of<CouponsProvider>(context);
    return RefreshIndicator(
      onRefresh: () => _refreshCoupons(context),
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
                    'إضافة كوبون ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditCouponScreen.routeName);
                  }),
            ),
            SizedBox(height: defaultPadding),
            ListView.builder(
              shrinkWrap: true,
              itemCount: couponsData.items.length,
              itemBuilder: (_, i) => Column(
                children: [
                  AdminCouponItem(
                    couponsData.items[i].id,
                    couponsData.items[i].title,
                    couponsData.items[i].store,
                    couponsData.items[i].imageUrl,
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
