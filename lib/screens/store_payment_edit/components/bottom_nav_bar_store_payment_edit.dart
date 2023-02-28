// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopadmin_app/screens/profile_edit/profile_edit_screen.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
// import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/screens/store_edit/store_edit_screen.dart';
import 'package:shopadmin_app/screens/store_list/store_list_screen.dart';
import 'package:shopadmin_app/screens/category_list/category_list_screen.dart';

class BottomNavBarStorePaymentEdit extends StatefulWidget {
  @override
  _BottomNavBarStorePaymentEdit createState() => _BottomNavBarStorePaymentEdit();
    const BottomNavBarStorePaymentEdit({
      Key? key,
      required this.selectedMenu,
    }) : super(key: key);
    final StoreMenuState selectedMenu;
  }

class _BottomNavBarStorePaymentEdit extends State<BottomNavBarStorePaymentEdit> {

  StoreMenuState selectedMenu = StoreMenuState.none;

pressMenuItem(StoreMenuState item) {
  
  setState(() {
    selectedMenu = item;
  });
  if (selectedMenu == StoreMenuState.back) {Navigator.pushNamed(context, StoreListScreen.routeName);}
  if (selectedMenu == StoreMenuState.profile) {Navigator.pushNamed(context, ProfileEditScreen.routeName);}
  if (selectedMenu == StoreMenuState.editstore) {Navigator.pushNamed(context, StoreEditScreen.routeName);}
  if (selectedMenu == StoreMenuState.category) {Navigator.pushNamed(context, CategoryListScreen.routeName);}

}

  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                      Icons.arrow_back,
                      color: StoreMenuState.back == selectedMenu ? kPrimaryColor : inActiveIconColor,
                      size: 24.0,
                    ),
              onPressed: () => pressMenuItem(StoreMenuState.back),
            ),
            IconButton(
              icon: Icon(
                      Icons.edit,
                      color: StoreMenuState.editstore == selectedMenu ? kPrimaryColor : inActiveIconColor,
                      size: 24.0,
                    ),
              onPressed: () => pressMenuItem(StoreMenuState.editstore),
            ),
            IconButton(
              icon: Icon(
                      Icons.category,
                      color: StoreMenuState.category == selectedMenu ? kPrimaryColor : inActiveIconColor,
                      size: 24.0,
                    ),
              onPressed: () => pressMenuItem(StoreMenuState.category),
            ),
            IconButton(
              icon: Icon(
                      Icons.person_pin,
                      color: StoreMenuState.profile == selectedMenu ? kPrimaryColor : inActiveIconColor,
                      size: 24.0,
                    ),
              onPressed: () => pressMenuItem(StoreMenuState.profile),
            ),
          ],
        ),
      ),
    );
  }
}
