import 'package:flutter/material.dart';
import 'package:shopadmin_app/screens/category_add/components/bottom_nav_bar_category_add.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class CategoryAddScreen extends StatelessWidget {
  static String routeName = "/category_add";
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(txtCatNew),
        automaticallyImplyLeading: false,
      ),
      body: Body(),
      bottomNavigationBar: BottomNavBarCategoryAdd(selectedMenu: StoreMenuState.none),
    );
  }
}
