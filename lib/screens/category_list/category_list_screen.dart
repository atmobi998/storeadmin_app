import 'package:flutter/material.dart';
import 'package:shopadmin_app/screens/category_list/components/bottom_nav_bar_category_list.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class CategoryListScreen extends StatelessWidget {
  static String routeName = "/category_list";

  const CategoryListScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(txtListCats),
        automaticallyImplyLeading: false,
      ),
      body: const CategoriesListBody(),
      bottomNavigationBar: const BottomNavBarCategoryList(selectedMenu: StoreMenuState.none),
    );
  }
}
