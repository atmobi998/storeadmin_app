import 'package:flutter/material.dart';
import 'package:shopadmin_app/screens/category_edit/components/bottom_nav_bar_category_edit.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class CategoryEditScreen extends StatelessWidget {
  static String routeName = "/category_edit";

  const CategoryEditScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(txtCat),
        automaticallyImplyLeading: false,
      ),
      body: const Body(),
      bottomNavigationBar: const BottomNavBarCategoryEdit(selectedMenu: StoreMenuState.none),
    );
  }
}
