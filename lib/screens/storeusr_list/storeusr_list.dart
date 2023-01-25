// import 'dart:io';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';


class StoreUserListView extends StatefulWidget {

  @override
  _StorePosListView createState() => _StorePosListView();

  }
  
  
  class _StorePosListView extends State<StoreUserListView> {

  var liststrusrs = allstrusrs;

  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Container(
      width: defListFormWidth,
      height: posListScrlHeight,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: defListFormMaxWidth,
        ),
        child: _storesUserListView(liststrusrs),
      ),
    );
  }

  void refresh(int storeposid) {
    setState(() {
      admcurstrusrid = storeposid;
      admcurstrusr=allstrusrs.where((element) => (element.id == storeposid)).toList();
      liststrusrs = allstrusrs;
    });
  }

  ListView _storesUserListView(data) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _tile(data[index].id, data[index].usrname, data[index].staffname + '\n'+ data[index].usrcode, data[index].staffimg, Icons.account_circle_rounded);
      },
    );
  }
  
  ListTile _tile(int storeposid, String title, String subtitle, String imgpath, IconData icon) => ListTile(
    title: Text(title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(subtitle),
    leading: Icon(
      icon,
      color: admcurstrusrid == storeposid ? kPrimaryColor : inActiveIconColor,
      size: 48.0,
    ),
    trailing: Image.network(imagehost+imgpath, fit: BoxFit.cover, height: 60.0, width: 60.0),
    onTap: () => refresh(storeposid),
  );

}

