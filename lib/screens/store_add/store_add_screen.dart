import 'package:flutter/material.dart';
import 'package:shopadmin_app/screens/store_add/components/bottom_nav_bar_store_add.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class StoreAddScreen extends StatelessWidget {
  static String routeName = "/store_add";
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(txtAddNewStore),
        automaticallyImplyLeading: false,
      ),
      body: Body(),
      bottomNavigationBar: BottomNavBarStoreAdd(selectedMenu: StoreMenuState.none),
    );
  }
}
