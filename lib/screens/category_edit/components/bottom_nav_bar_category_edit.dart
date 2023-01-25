// import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopadmin_app/screens/category_add/category_add_screen.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/screens/category_list/category_list_screen.dart';

class BottomNavBarCategoryEdit extends StatefulWidget {
  @override
  _BottomNavBarCategoryEdit createState() => _BottomNavBarCategoryEdit();
    const BottomNavBarCategoryEdit({
      Key? key,
      required this.selectedMenu,
    }) : super(key: key);
    final StoreMenuState selectedMenu;
  }

class _BottomNavBarCategoryEdit extends State<BottomNavBarCategoryEdit> {

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
  if (selectedMenu == StoreMenuState.back) {Navigator.pushNamed(context, CategoryListScreen.routeName);}
  if (selectedMenu == StoreMenuState.addcat) {Navigator.pushNamed(context, CategoryAddScreen.routeName);}

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
                        color: StoreMenuState.addcat == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => pressMenuItem(StoreMenuState.addcat),
              ),
            ],
          )),
    );
  }
}
