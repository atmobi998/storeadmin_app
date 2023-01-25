import 'package:flutter/material.dart';
import 'package:shopadmin_app/screens/store_list/components/bottom_nav_bar_store_list.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class StoreListScreen extends StatelessWidget {
  static String routeName = "/store_list";
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(txtStoreListTitle),
        automaticallyImplyLeading: false,
      ),
      body: Body(),
      bottomNavigationBar: BottomNavBarStoreList(selectedMenu: StoreMenuState.none),
    );
  }
}
