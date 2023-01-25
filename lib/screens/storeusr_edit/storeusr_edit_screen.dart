import 'package:flutter/material.dart';
import 'package:shopadmin_app/screens/storeusr_edit/components/bottom_nav_bar_storeusr_edit.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class StoreUserEditScreen extends StatelessWidget {
  static String routeName = "/storeusr_edit";
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(userTitleInfo),
        automaticallyImplyLeading: false,
      ),
      body: Body(),
      bottomNavigationBar: BottomNavBarStoreUserEdit(selectedMenu: StoreMenuState.none),
    );
  }
}
