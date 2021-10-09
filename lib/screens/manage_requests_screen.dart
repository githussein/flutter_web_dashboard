import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/requests_provider.dart';
// import '../widgets/app_drawer.dart';
import '../widgets/admin_request_item.dart';

class ManageRequestsScreen extends StatelessWidget {
  static const routeName = '/manage-requests';

  //function to handle Refresh Indicator
  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<RequestsProvider>(ctx, listen: false).fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    //Fetch current requests
    _refreshProducts(context);

    //Listen to changes in the coupons list
    final requestsData = Provider.of<RequestsProvider>(context);

    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: Padding(
          padding: EdgeInsets.all((10)),
          child: requestsData.items.length > 0
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: requestsData.items.length,
                  itemBuilder: (_, i) => Column(
                    children: [
                      AdminRequestItem(
                        requestsData.items[i].id,
                        requestsData.items[i].userName,
                        requestsData.items[i].email,
                        requestsData.items[i].store,
                        requestsData.items[i].link,
                      ),
                      Divider(height: 10),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    'No new requests yet!\nSwipe down to check again.',
                    textAlign: TextAlign.center,
                  ),
                )),
    );
  }
}
