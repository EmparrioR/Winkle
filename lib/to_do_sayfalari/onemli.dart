import 'package:flutter/material.dart';

import 'temel_sayfa.dart';

class Onemli extends BasePage {
  @override
  _OnemliState createState() => _OnemliState();

  @override
  String getBackgroundImageURL() {
    return "https://images.unsplash.com/photo-1517607908060-9a66da662869?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80";
  }

  @override
  String getAppBarTitle() {
    return 'Önemli';
  }

  @override
  Color getAppBarColor() {
    return Colors.red;
  }

  @override
  Color getDialogColor() {
    return Colors.red;
  }

  @override
  String getTableName() {
    return "Önemli";
  }
}

class _OnemliState extends BasePageState {}
