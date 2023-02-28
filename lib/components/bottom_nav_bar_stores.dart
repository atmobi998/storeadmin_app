// import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/screens/profile_edit/profile_edit_screen.dart';
import 'package:shopadmin_app/screens/sign_in/sign_in_screen.dart';

class BottomNavBarStores extends StatelessWidget {
  const BottomNavBarStores({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final StoreMenuState selectedMenu;

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
    // print("$postdata");
    http.post(
        storeqryEndPoint, 
        body: postdata,
        headers: posthdr
      ).then((result) {
          if (result.statusCode == 200) {
            // var resary = jsonDecode(result.body);
            // print("$resary");
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
                        Icons.home,
                        color: StoreMenuState.home == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => 
                    Navigator.pushNamed(context, SignInScreen.routeName),
              ),
              IconButton(
                icon: Icon(
                        Icons.remove,
                        color: StoreMenuState.delstore == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => {storeqry()},
              ),
              IconButton(
                icon: Icon(
                        Icons.add_business,
                        color: StoreMenuState.addstore == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () => {storeqry()},
              ),
              IconButton(
                icon: Icon(
                        Icons.account_box,
                        color: StoreMenuState.profile == selectedMenu ? kPrimaryColor : inActiveIconColor,
                        size: 24.0,
                      ),
                onPressed: () =>
                    Navigator.pushNamed(context, ProfileEditScreen.routeName),
              ),
            ],
          )),
    );
  }
}
