import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/screens/category_edit/category_edit_screen.dart';
import 'package:shopadmin_app/screens/category_add/category_add_screen.dart';
import 'package:shopadmin_app/screens/product_list/product_list_screen.dart';
import 'package:shopadmin_app/screens/store_list/store_list_screen.dart';
import 'package:shopadmin_app/screens/product_add/product_add_screen.dart';


class BottomNavBarCategoryList extends StatefulWidget {
  @override
  _BottomNavBarCategoryList createState() => _BottomNavBarCategoryList();
    const BottomNavBarCategoryList({
      Key? key,
      required this.selectedMenu,
    }) : super(key: key);
    final StoreMenuState selectedMenu;
  }

class _BottomNavBarCategoryList extends State<BottomNavBarCategoryList> {

  StoreMenuState selectedMenu = StoreMenuState.none;

  pressMenuItem(StoreMenuState item) {
    
    setState(() {
      selectedMenu = item;
    });
    if (selectedMenu == StoreMenuState.back) {Navigator.pushNamed(context, StoreListScreen.routeName);}
    if (selectedMenu == StoreMenuState.product && admcurcatid >0) {Navigator.pushNamed(context, ProductListScreen.routeName);}
    if (selectedMenu == StoreMenuState.addcat) {Navigator.pushNamed(context, CategoryAddScreen.routeName);}
    if (selectedMenu == StoreMenuState.editcat && admcurcatid>0) {Navigator.pushNamed(context, CategoryEditScreen.routeName);}
    if (selectedMenu == StoreMenuState.product && admcurcatid>0) {Navigator.pushNamed(context, ProductListScreen.routeName);}
    if (selectedMenu == StoreMenuState.addprod && admcurcatid>0) {Navigator.pushNamed(context, ProductAddScreen.routeName);}
    if (selectedMenu == StoreMenuState.editprod && admcurprodid>0) {Navigator.pushNamed(context, ProductListScreen.routeName);}


  }

  categoryqry() {
    var postdata = {
        "qrymode": 'by_id',
        "id": "$admcurcatid",
        "mobapp" : mobAppVal,
        "store_id" : "$admcurstoreid", // admcurstoreid
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    http.post(
        categoryqryEndPoint, 
        body: postdata,
        headers: posthdr
      ).then((result) {
          if (result.statusCode == 200) {
            var resary = jsonDecode(result.body);
            setState(() {
              admcurcat = resary['data'];
              admcurcatid = resary['data']['id'];
            });
          } else {
            throw Exception(kstoreqryErr);
          }
      }).catchError((error) {
        //
      });
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
                        Icons.add_sharp,
                        color: StoreMenuState.addcat == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => 
                    pressMenuItem(StoreMenuState.addcat),
              ),
              IconButton(
                icon: Icon(
                        Icons.create,
                        color: StoreMenuState.editcat == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => 
                    pressMenuItem(StoreMenuState.editcat),
              ),
              IconButton(
                icon: Icon(
                        Icons.add_sharp,
                        color: StoreMenuState.addprod == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => 
                    pressMenuItem(StoreMenuState.addprod),
              ),
              IconButton(
                icon: Icon(
                        Icons.create,
                        color: StoreMenuState.editprod == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => 
                    pressMenuItem(StoreMenuState.editprod),
              ),
            ],
          )),
    );
  }
}

