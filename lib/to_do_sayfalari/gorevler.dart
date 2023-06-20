import 'package:flutter/material.dart';

import 'temel_sayfa.dart';

class Gorevler extends BasePage {
  @override
  _GorevlerState createState() => _GorevlerState();

  @override
  String getBackgroundImageURL() {
    return "https://images.unsplash.com/photo-1593062096033-9a26b09da705?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80";
  }

  @override
  String getAppBarTitle() {
    return 'Görevler';
  }

  @override
  Color getAppBarColor() {
    return Colors.purple;
  }

  @override
  Color getDialogColor() {
    return Colors.purple;
  }

  @override
  String getTableName() {
    return "Görevler";

  }
}

class _GorevlerState extends BasePageState {

}
