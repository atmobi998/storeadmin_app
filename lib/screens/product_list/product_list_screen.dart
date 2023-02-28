import 'package:flutter/material.dart';
// import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/screens/product_list/components/bottom_nav_bar_product_list.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class ProductListScreen extends StatelessWidget {
  static String routeName = "/product_list";

  const ProductListScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    var tmpcatname = txtCatProds;
    return Scaffold(
      appBar: AppBar(
        title: Text( tmpcatname ),
        automaticallyImplyLeading: false,
      ),
      body: const ProductsListBody(),
      bottomNavigationBar: const BottomNavBarProductList(selectedMenu: StoreMenuState.none),
    );
  }
}
