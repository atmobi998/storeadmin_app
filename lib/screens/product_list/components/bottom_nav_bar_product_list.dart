import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/screens/category_list/category_list_screen.dart';
import 'package:shopadmin_app/screens/product_list/product_list_screen.dart';
import 'package:shopadmin_app/screens/product_edit/product_edit_screen.dart';
import 'package:shopadmin_app/screens/product_add/product_add_screen.dart';

class BottomNavBarProductList extends StatefulWidget {
  @override
  _BottomNavBarProductList createState() => _BottomNavBarProductList();
    const BottomNavBarProductList({
      Key? key,
      required this.selectedMenu,
    }) : super(key: key);
    final StoreMenuState selectedMenu;
  }

class _BottomNavBarProductList extends State<BottomNavBarProductList> {

  StoreMenuState selectedMenu = StoreMenuState.none;

  pressMenuItem(StoreMenuState item) {
    
    setState(() {
      selectedMenu = item;
    });
    if (selectedMenu == StoreMenuState.back) {Navigator.pushNamed(context, CategoryListScreen.routeName);}
    if (selectedMenu == StoreMenuState.product && admcurcatid>0) {Navigator.pushNamed(context, ProductListScreen.routeName);}
    if (selectedMenu == StoreMenuState.addprod && admcurcatid>0) {Navigator.pushNamed(context, ProductAddScreen.routeName);}
    if (selectedMenu == StoreMenuState.editprod && admcurprodid>0) {Navigator.pushNamed(context, ProductEditScreen.routeName);}

  }

    productqry() {
      var postdata = {
          "qrymode": 'by_id',
          "id": "$admcurprodid",
          "mobapp" : mobAppVal,
          "cat_id": "$admcurcatid",
          "store_id" : "$admcurstoreid", 
        };
      var posthdr = {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $logintoken'
          };
      http.post(
          productqryEndPoint, 
          body: postdata,
          headers: posthdr
        ).then((result) {
            if (result.statusCode == 200) {
              var resary = jsonDecode(result.body);
              setState(() {
                admcurprod = resary['data'];
                admcurprodid = resary['data']['id'];
                curprodactive = (resary['data']['active'] > 0)? true:false;
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
                        color: StoreMenuState.addprod == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => 
                    pressMenuItem(StoreMenuState.addprod),
              ),
            ],
          )),
    );
  }
}
