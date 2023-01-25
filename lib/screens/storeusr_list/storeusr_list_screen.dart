import 'package:flutter/material.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:http/http.dart' as http;
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/screens/store_list/store_list_screen.dart';
import 'package:shopadmin_app/screens/storeusr_add/storeusr_add_screen.dart';
import 'components/body.dart';

class StoreUserListScreen extends StatefulWidget {

  @override
  _StoreUserListScreen createState() => _StoreUserListScreen();
  static String routeName = "/storeuser_list";
}

class _StoreUserListScreen extends State<StoreUserListScreen> with AfterLayoutMixin<StoreUserListScreen> {

  StoreMenuState selectedMenu = StoreMenuState.none;

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
        if (admusraction == 'edit') {
          selectedMenu = StoreMenuState.editpos;
        } else if (admusraction == 'list') {
          selectedMenu = StoreMenuState.salepos;
        } else {
          selectedMenu = StoreMenuState.none;
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(kStoreUsersTitle),
        automaticallyImplyLeading: false,
      ),
      body: StoreUserListBody(),
      bottomNavigationBar: buildbottomNavigationBar(),
    );
  }

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
          } else {
            throw Exception(kstoreqryErr);
          }
      }).catchError((error) {
        //
      });
  }

  buildbottomNavigationBar() {
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
            ],
          )),
    );

  }

  pressMenuItem(StoreMenuState item) {
    setState(() {
      selectedMenu = item;
    });
    if (selectedMenu == StoreMenuState.back) {Navigator.pushNamed(context, StoreListScreen.routeName);}
    if (selectedMenu == StoreMenuState.editpos && admcurstrusr.isNotEmpty) {
      setState(() {
        admusraction = 'edit';
      });
    }
    if (selectedMenu == StoreMenuState.addpos) {Navigator.pushNamed(context, StorePosAddScreen.routeName);}
    if (selectedMenu == StoreMenuState.salepos) {
      setState(() {
        admusraction = 'list';
      });
    }
  }

}


