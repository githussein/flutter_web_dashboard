import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Category with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;

  Category({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  });
}
