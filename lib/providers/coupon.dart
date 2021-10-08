import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Coupon with ChangeNotifier {
  final String id;
  final String store;
  final String title;
  final String code;
  final String description;
  final String imageUrl;
  final String link;
  String category;
  bool isFavorite;

  Coupon({
    @required this.id,
    @required this.store,
    @required this.title,
    @required this.code,
    @required this.description,
    @required this.imageUrl,
    @required this.link,
    @required this.category,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://wafar-cash-demo-default-rtdb.europe-west1.firebasedatabase.app/coupons/$id.json');

    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
