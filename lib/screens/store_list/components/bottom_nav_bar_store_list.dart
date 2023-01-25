// import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/screens/profile_edit/profile_edit_screen.dart';
import 'package:shopadmin_app/screens/store_add/store_add_screen.dart';
import 'package:shopadmin_app/screens/store_edit/store_edit_screen.dart';
import 'package:shopadmin_app/screens/category_list/category_list_screen.dart';
import 'package:shopadmin_app/screens/storeusr_list/storeusr_list_screen.dart';


class BottomNavBarStoreList extends StatefulWidget {
  @override
  _BottomNavBarStoreList createState() => _BottomNavBarStoreList();
    const BottomNavBarStoreList({
      Key? key,
      required this.selectedMenu,
    }) : super(key: key);
    final StoreMenuState selectedMenu;
  }

class _BottomNavBarStoreList extends State<BottomNavBarStoreList> {

  StoreMenuState selectedMenu = StoreMenuState.none;

  storeqry() {
    var postdata = {
        "qrymode": 'by_id',
        "id": "$admcurstoreid",
        "mobapp" : mobAppVal
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    http.post(
        storeqryEndPoint, 
        body: postdata,
        headers: posthdr
      ).then((result) {
          if (result.statusCode == 200) {
            // var resary = jsonDecode(result.body);
          } else {
            throw Exception(kstoreqryErr);
          }
      }).catchError((error) {
        //
      });
  }

  pressMenuItem(StoreMenuState item) {
    
    setState(() {
      selectedMenu = item;
    });
    if (selectedMenu == StoreMenuState.logout) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
    if (selectedMenu == StoreMenuState.editstore && admcurstore.isNotEmpty) {Navigator.pushNamed(context, StoreEditScreen.routeName);}
    if (selectedMenu == StoreMenuState.addstore) {Navigator.pushNamed(context, StoreAddScreen.routeName);}
    if (selectedMenu == StoreMenuState.profile) {Navigator.pushNamed(context, ProfileEditScreen.routeName);}
    if (selectedMenu == StoreMenuState.category && admcurstore.isNotEmpty) {Navigator.pushNamed(context, CategoryListScreen.routeName);}
    if (selectedMenu == StoreMenuState.salepos && admcurstore.isNotEmpty) {Navigator.pushNamed(context, StoreUserListScreen.routeName);}

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
                        Icons.logout,
                        color: StoreMenuState.logout == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => pressMenuItem(StoreMenuState.logout),
              ),
              IconButton(
                icon: Icon(
                        Icons.person_pin,
                        color: StoreMenuState.profile == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => 
                    pressMenuItem(StoreMenuState.profile),
              ),
              IconButton(
                icon: Icon(
                        Icons.add_sharp,
                        color: StoreMenuState.addstore == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => 
                    pressMenuItem(StoreMenuState.addstore),
              ),
              IconButton(
                icon: Icon(
                        Icons.create,
                        color: StoreMenuState.editstore == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => 
                    pressMenuItem(StoreMenuState.editstore),
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
                        Icons.supervisor_account,
                        color: StoreMenuState.salepos == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => pressMenuItem(StoreMenuState.salepos),
              ),
            ],
          )),
    );
  }
}

