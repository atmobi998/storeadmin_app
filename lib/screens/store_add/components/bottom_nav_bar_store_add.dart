// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopadmin_app/screens/profile_edit/profile_edit_screen.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
// import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/screens/store_list/store_list_screen.dart';

class BottomNavBarStoreAdd extends StatefulWidget {
  @override
  _BottomNavBarStoreAdd createState() => _BottomNavBarStoreAdd();
    const BottomNavBarStoreAdd({
      Key? key,
      required this.selectedMenu,
    }) : super(key: key);
    final StoreMenuState selectedMenu;
  }

class _BottomNavBarStoreAdd extends State<BottomNavBarStoreAdd> {

  StoreMenuState selectedMenu = StoreMenuState.none;

  pressMenuItem(StoreMenuState item) {
    
    setState(() {
      selectedMenu = item;
    });

    if (selectedMenu == StoreMenuState.back) {Navigator.pushNamed(context, StoreListScreen.routeName);}
    if (selectedMenu == StoreMenuState.profile) {Navigator.pushNamed(context, ProfileEditScreen.routeName);}

  }

  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
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
                    Icons.person_pin,
                    color: StoreMenuState.profile == selectedMenu ? kPrimaryColor : inActiveIconColor,
                    size: 24.0,
                  ),
                onPressed: () => pressMenuItem(StoreMenuState.profile),
              ),
            ],
          )),
    );
  }
}
