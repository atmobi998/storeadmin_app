// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/screens/store_list/store_list_screen.dart';

class BottomNavBarStoreLocation extends StatefulWidget {
  @override
  _BottomNavBarStoreLocation createState() => _BottomNavBarStoreLocation();
    const BottomNavBarStoreLocation({
      Key? key,
      required this.selectedMenu,
    }) : super(key: key);
    final StoreMenuState selectedMenu;
  }

class _BottomNavBarStoreLocation extends State<BottomNavBarStoreLocation> {

  StoreMenuState selectedMenu = StoreMenuState.none;


pressMenuItem(StoreMenuState item) {
  
  setState(() {
    selectedMenu = item;
  });
  if (selectedMenu == StoreMenuState.back) {Navigator.pushNamed(context, StoreListScreen.routeName);}

}

  @override
  Widget build(BuildContext context) {
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
            ],
          )),
    );
  }
}
