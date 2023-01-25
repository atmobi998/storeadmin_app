import 'package:flutter/material.dart';
import 'package:shopadmin_app/screens/store_edit/components/bottom_nav_bar_store_edit.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class StoreEditScreen extends StatelessWidget {
  static String routeName = "/store_edit";
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(txtStoreInfo),
        automaticallyImplyLeading: false,
      ),
      body: Body(),
      bottomNavigationBar: BottomNavBarStoreEdit(selectedMenu: StoreMenuState.none),
    );
  }
}
