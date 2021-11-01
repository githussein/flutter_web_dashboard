import 'package:admin_panel_coupons/screens/edit_offer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../widgets/admin_offer_item.dart';
// import '../screens/edit_offer_screen.dart';
// import '../widgets/app_drawer.dart';
import '../providers/offers_provider.dart';

class ManageOffersScreen extends StatelessWidget {
  static const routeName = '/manage-offers';

  //function to handle Refresh Indicator
  Future<void> _refreshOffers(BuildContext ctx) async {
    await Provider.of<OffersProvider>(ctx, listen: false).fetchOffers();
  }

  @override
  Widget build(BuildContext context) {
    //Listen to changes in the coupons list
    final offersData = Provider.of<OffersProvider>(context);

    return RefreshIndicator(
      onRefresh: () => _refreshOffers(context),
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
                    'إضافة عرض ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditOfferScreen.routeName);
                  }),
            ),
            SizedBox(height: defaultPadding),
            ListView.builder(
              shrinkWrap: true,
              itemCount: offersData.items.length,
              itemBuilder: (_, i) => Column(
                children: [
                  AdminOfferItem(
                    offersData.items[i].id,
                    offersData.items[i].title,
                    offersData.items[i].imageUrl,
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
