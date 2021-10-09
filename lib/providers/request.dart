import 'package:flutter/cupertino.dart';

class Request {
  final String id;
  final String userName;
  final String email;
  final String store;
  final String link;

  Request(
      {@required this.id,
      @required this.userName,
      @required this.email,
      @required this.store,
      @required this.link});
}
