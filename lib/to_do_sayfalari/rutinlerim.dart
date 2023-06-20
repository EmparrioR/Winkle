import 'package:flutter/material.dart';

import 'temel_sayfa.dart';

class Rutinlerim extends BasePage {
  @override
  _RutinlerimState createState() => _RutinlerimState();

  @override
  String getBackgroundImageURL() {
    return "https://images.unsplash.com/photo-1474859569645-e0def92b02bc?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80";

  }

  @override
  String getAppBarTitle() {
    return 'Rutinlerim';
  }

  @override
  Color getAppBarColor() {
    return Colors.orange;
  }

  @override
  Color getDialogColor() {
    return Colors.orange;
  }

  @override
  String getTableName() {
    return "Rutinlerim";

  }
}

class _RutinlerimState extends BasePageState {

}
