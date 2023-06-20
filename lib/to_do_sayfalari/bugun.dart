import 'package:flutter/material.dart';
import 'temel_sayfa.dart';

class Bugun extends BasePage {
  @override
  _BugunState createState() => _BugunState();

  @override
  String getBackgroundImageURL() {
    return "https://images.unsplash.com/photo-1559770968-53924e9b32de?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=327&q=80";
  }

  @override
  String getAppBarTitle() {
    return 'Bugün';
  }

  @override
  Color getAppBarColor() {
    return Colors.green;
  }

  @override
  Color getDialogColor() {
    return Colors.green;
  }

  @override
  String getTableName() {
    return "Bugün";

  }
}

class _BugunState extends BasePageState {


}
