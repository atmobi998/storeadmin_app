// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopadmin_app/screens/product_add/product_add_screen.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/screens/category_list/category_list_screen.dart';

class BottomNavBarProductEdit extends StatefulWidget {
  @override
  _BottomNavBarProductEdit createState() => _BottomNavBarProductEdit();
    const BottomNavBarProductEdit({
      Key? key,
      required this.selectedMenu,
    }) : super(key: key);
    final StoreMenuState selectedMenu;
  }

class _BottomNavBarProductEdit extends State<BottomNavBarProductEdit> {

  StoreMenuState selectedMenu = StoreMenuState.none;


pressMenuItem(StoreMenuState item) {
  
  setState(() {
    selectedMenu = item;
  });
  if (selectedMenu == StoreMenuState.back) {Navigator.pushNamed(context, CategoryListScreen.routeName);}
  if (selectedMenu == StoreMenuState.addprod) {Navigator.pushNamed(context, ProductAddScreen.routeName);}

}

  @override
  Widget build(BuildContext context) {
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
                        color: StoreMenuState.addprod == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => pressMenuItem(StoreMenuState.addprod),
              ),
            ],
          )),
    );
  }
}
