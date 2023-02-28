import 'package:flutter/material.dart';
// import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/screens/product_add/components/bottom_nav_bar_product_add.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class ProductAddScreen extends StatelessWidget {
  static String routeName = "/product_add";

  const ProductAddScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(txtProdNew),
        automaticallyImplyLeading: false,
      ),
      body: const Body(),
      bottomNavigationBar: const BottomNavBarProductAdd(selectedMenu: StoreMenuState.none),
    );
  }
}
