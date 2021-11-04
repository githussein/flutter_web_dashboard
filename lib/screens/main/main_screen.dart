import 'package:admin_panel_coupons/providers/categories_provider.dart';
import 'package:admin_panel_coupons/providers/coupons_provider.dart';
import 'package:admin_panel_coupons/providers/offers_provider.dart';
import 'package:admin_panel_coupons/providers/requests_provider.dart';
import 'package:admin_panel_coupons/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _isInit = true;

  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      //fetch offers and coupons
      Provider.of<CouponsProvider>(context).fetchCoupons().then((value) {
        Provider.of<OffersProvider>(context, listen: false).fetchOffers();
      }).then((value) {
        Provider.of<CategoriesProvider>(context, listen: false)
            .fetchCategories();
      }).then((value) {
        Provider.of<RequestsProvider>(context, listen: false).fetchRequests();
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SideMenu()), //flex 1/5
            Expanded(
                flex: 5, // takes5/6 of the screen
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : DashboardScreen()),
          ],
        ),
      ),
    );
  }
}
