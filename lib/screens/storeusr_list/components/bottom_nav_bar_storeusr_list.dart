// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/screens/store_list/store_list_screen.dart';
import 'package:shopadmin_app/screens/storeusr_add/storeusr_add_screen.dart';

class BottomNavBarStoreUserList extends StatefulWidget {
  @override
  _BottomNavBarStoreUserList createState() => _BottomNavBarStoreUserList();
    const BottomNavBarStoreUserList({
      Key? key,
      required this.selectedMenu,
    }) : super(key: key);
    final StoreMenuState selectedMenu;
}
 
class _BottomNavBarStoreUserList extends State<BottomNavBarStoreUserList> with AfterLayoutMixin<BottomNavBarStoreUserList> {

  StoreMenuState selectedMenu = StoreMenuState.none;

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
        if (admusraction == 'edit') {
          selectedMenu = StoreMenuState.editpos;
        } else if (admusraction == 'list') {
          selectedMenu = StoreMenuState.salepos;
        } 
    });
  }


  pressMenuItem(StoreMenuState item) {
    
    setState(() {
      selectedMenu = item;
    });
    if (selectedMenu == StoreMenuState.back) {Navigator.pushNamed(context, StoreListScreen.routeName);}
    if (selectedMenu == StoreMenuState.editpos && admcurstrusr.isNotEmpty) {
      setState(() {admusraction = 'edit';});
    }
    if (selectedMenu == StoreMenuState.addpos) {Navigator.pushNamed(context, StorePosAddScreen.routeName);}
    if (selectedMenu == StoreMenuState.salepos) {
      setState(() {admusraction = 'list';});
    }

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
                        Icons.add_sharp,
                        color: StoreMenuState.addpos == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => 
                    pressMenuItem(StoreMenuState.addpos),
              ),
              IconButton(
                icon: Icon(
                        Icons.create,
                        color: StoreMenuState.editpos == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => 
                    pressMenuItem(StoreMenuState.editpos),
              ),  
              IconButton(
                icon: Icon(
                        Icons.details_sharp,
                        color: StoreMenuState.salepos == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => 
                    pressMenuItem(StoreMenuState.salepos),
              ),            
            ],
          )),
    );
  }


  
}
