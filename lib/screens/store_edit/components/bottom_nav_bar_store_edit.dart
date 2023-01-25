// import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopadmin_app/screens/category_list/category_list_screen.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/screens/store_list/store_list_screen.dart';
import 'package:shopadmin_app/screens/storeusr_list/storeusr_list_screen.dart';
import 'package:shopadmin_app/screens/store_payment_edit/store_payment_edit_screen.dart';

class BottomNavBarStoreEdit extends StatefulWidget {
  @override
  _BottomNavBarStoreEdit createState() => _BottomNavBarStoreEdit();
    const BottomNavBarStoreEdit({
      Key? key,
      required this.selectedMenu,
    }) : super(key: key);
    final StoreMenuState selectedMenu;
  }

class _BottomNavBarStoreEdit extends State<BottomNavBarStoreEdit> {

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
  if (selectedMenu == StoreMenuState.back) {Navigator.pushNamed(context, StoreListScreen.routeName);}
  if (selectedMenu == StoreMenuState.salepos) {Navigator.pushNamed(context, StoreUserListScreen.routeName);}
  if (selectedMenu == StoreMenuState.payedit) {Navigator.pushNamed(context, StorePaymentEditScreen.routeName);}
  if (selectedMenu == StoreMenuState.category) {Navigator.pushNamed(context, CategoryListScreen.routeName);}

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
                        Icons.payments,
                        color: StoreMenuState.payedit == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => pressMenuItem(StoreMenuState.payedit),
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
