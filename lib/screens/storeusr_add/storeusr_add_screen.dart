import 'package:flutter/material.dart';
import 'package:shopadmin_app/screens/storeusr_add/components/bottom_nav_bar_storeusr_add.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class StorePosAddScreen extends StatelessWidget {
  static String routeName = "/storeusr_add";
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(userTitleInfo),
        automaticallyImplyLeading: false,
      ),
      body: Body(),
      bottomNavigationBar: BottomNavBarStorePosAdd(selectedMenu: StoreMenuState.none),
    );
  }
}
