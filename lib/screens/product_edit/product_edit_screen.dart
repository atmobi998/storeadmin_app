import 'package:flutter/material.dart';
// import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/screens/product_edit/components/bottom_nav_bar_product_edit.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class ProductEditScreen extends StatelessWidget {
  static String routeName = "/product_edit";
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(txtProdUpd),
        automaticallyImplyLeading: false,
      ),
      body: Body(),
      bottomNavigationBar: BottomNavBarProductEdit(selectedMenu: StoreMenuState.none),
    );
  }
}
