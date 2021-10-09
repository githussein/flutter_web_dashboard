import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        padding: EdgeInsets.all((10)),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: offersData.items.length,
          itemBuilder: (_, i) => Column(
            children: [
              AdminOfferItem(
                offersData.items[i].id,
                offersData.items[i].title,
                offersData.items[i].imageUrl,
              ),
              Divider(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
