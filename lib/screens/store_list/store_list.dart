// import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:audiofileplayer/audiofileplayer.dart';


class StoresListView extends StatefulWidget {
  const StoresListView({Key? key}) : super(key: key);


  @override
  _StoresListView createState() => _StoresListView();

  }
  
  
  class _StoresListView extends State<StoresListView> with AfterLayoutMixin<StoresListView> {

  late ByteData printfont;
  late Uint8List assetLogoATC;
  bool logoPdfLoaded = false;
  Timer? timer;
  Timer? timerCatUpd;
  Timer? timerProdUpd;
  String poststatus = '';

  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Container(
      width: defListFormWidth,
      height: storeListScrlHeight,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: defListFormMaxWidth,
        ),
        child: _storesListView(allappstores),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    loadPrintFont();
    readLogoPdf();
    doStoreQryAll();
    doQryStoreUsers();
    setState(() {
      
    });
  }

  loadPrintFont() async {
    printfont = await rootBundle.load("assets/fonts/open-sans/OpenSans-Regular.ttf");
  }

  playBeepSound() {
    // Audio.load('assets/sounds/beep-read-02.mp3')..play()..dispose();
  }

  readLogoPdf() async {
    if (logoPdfLoaded == false) {
      final ByteData logoATCbytes = await rootBundle.load('assets/images/BTT-Logo_09.png');
      assetLogoATC = logoATCbytes.buffer.asUint8List();
      logoPdfLoaded = true;
    }
  }

  void logError(error) {
    print(error);
  }

  void logMessage(String message) {
    print(message);
  }

  getuserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position _tmpstorepos;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openAppSettings();await Geolocator.openLocationSettings();
    }

    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        await Geolocator.openAppSettings();await Geolocator.openLocationSettings();
      }
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      _tmpstorepos = await Geolocator.getCurrentPosition();
      setState(() {
        curposition = _tmpstorepos;
        curusrpos = LatLng(_tmpstorepos.latitude, _tmpstorepos.longitude);
        storecamerapos = CameraPosition(target: curusrpos ,zoom: 14,);
      });
    }
  }

  setStatus(String message) {
    setState(() {
      poststatus = message;
    });
  }

  syncStoresList(AtcStore fromStore, int toStoreIdx) {
    allappstores[toStoreIdx].id = fromStore.id;
    allappstores[toStoreIdx].userid = fromStore.userid;
    allappstores[toStoreIdx].storecode = fromStore.storecode;
    allappstores[toStoreIdx].storename = fromStore.storename;
    allappstores[toStoreIdx].storeemail = fromStore.storeemail;
    allappstores[toStoreIdx].storephone = fromStore.storephone;
    allappstores[toStoreIdx].storefax = fromStore.storefax;
    allappstores[toStoreIdx].storeaddr = fromStore.storeaddr;
    allappstores[toStoreIdx].storeaddr2 = fromStore.storeaddr2;
    allappstores[toStoreIdx].storecity = fromStore.storecity;
    allappstores[toStoreIdx].storezip = fromStore.storezip;
    allappstores[toStoreIdx].storestate = fromStore.storestate;
    allappstores[toStoreIdx].storecountry = fromStore.storecountry;
    allappstores[toStoreIdx].currency = fromStore.currency;
    allappstores[toStoreIdx].storelat = fromStore.storelat;
    allappstores[toStoreIdx].storelng = fromStore.storelng;
    allappstores[toStoreIdx].rescaf = fromStore.rescaf;
    allappstores[toStoreIdx].rescaftabs = fromStore.rescaftabs;
    allappstores[toStoreIdx].rescaftake = fromStore.rescaftake;
    allappstores[toStoreIdx].cvsmart = fromStore.cvsmart;
    allappstores[toStoreIdx].pharmacy = fromStore.pharmacy;
    allappstores[toStoreIdx].logoimg = fromStore.logoimg;
    allappstores[toStoreIdx].logow = fromStore.logow;
    allappstores[toStoreIdx].logoh = fromStore.logoh;
    allappstores[toStoreIdx].uplogoimg = fromStore.uplogoimg;
    allappstores[toStoreIdx].uplogow = fromStore.uplogow;
    allappstores[toStoreIdx].uplogoh = fromStore.uplogoh;
    allappstores[toStoreIdx].bcntrycode = fromStore.bcntrycode;
    allappstores[toStoreIdx].scntrycode = fromStore.scntrycode;
    allappstores[toStoreIdx].billingphone = fromStore.billingphone;
    allappstores[toStoreIdx].billingname = fromStore.billingname;
    allappstores[toStoreIdx].billingaddr = fromStore.billingaddr;
    allappstores[toStoreIdx].billingaddr2 = fromStore.billingaddr2;
    allappstores[toStoreIdx].billingcity = fromStore.billingcity;
    allappstores[toStoreIdx].billingzip = fromStore.billingzip;
    allappstores[toStoreIdx].billingstate = fromStore.billingstate;
    allappstores[toStoreIdx].billingcountry = fromStore.billingcountry;
    allappstores[toStoreIdx].shippingphone = fromStore.shippingphone;
    allappstores[toStoreIdx].shippingname = fromStore.shippingname;
    allappstores[toStoreIdx].shippingaddr = fromStore.shippingaddr;
    allappstores[toStoreIdx].shippingaddr2 = fromStore.shippingaddr2;
    allappstores[toStoreIdx].shippingcity = fromStore.shippingcity;
    allappstores[toStoreIdx].shippingzip = fromStore.shippingzip;
    allappstores[toStoreIdx].shippingstate = fromStore.shippingstate;
    allappstores[toStoreIdx].shippingcountry = fromStore.shippingcountry;
    allappstores[toStoreIdx].paymentmethod = fromStore.paymentmethod;
    allappstores[toStoreIdx].cardowner = fromStore.cardowner;
    allappstores[toStoreIdx].cardnumber = fromStore.cardnumber;
    allappstores[toStoreIdx].cardcode = fromStore.cardcode;
    allappstores[toStoreIdx].cardyear = fromStore.cardyear;
    allappstores[toStoreIdx].cardmonth = fromStore.cardmonth;
    allappstores[toStoreIdx].authorization = fromStore.authorization;
    allappstores[toStoreIdx].transaction = fromStore.transaction;
    allappstores[toStoreIdx].balance = fromStore.balance;
    allappstores[toStoreIdx].accip = fromStore.accip;
    allappstores[toStoreIdx].acctoken = fromStore.acctoken;
    allappstores[toStoreIdx].devinfo = fromStore.devinfo;
    allappstores[toStoreIdx].created = fromStore.created;
    allappstores[toStoreIdx].storeusers = fromStore.storeusers;
  }

  doStoreQryAll() {
    List<AtcStore> tmpstores = [];
    var postdata = {
        "mobapp" : mobAppVal,
        "qrymode" : "all"
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    http.post(storeqryEndPoint, body: postdata, headers: posthdr).then((result) {
      if (result.statusCode == 200) {
        var resary = jsonDecode(result.body);
        setState(() {
          resary['data'].asMap().forEach((i, v) {
            tmpstores.add(AtcStore.fromJsonDet(v));
          });
          tmpstores.asMap().forEach((sk, sv) {
            if (allappstores.where((strelem) => (strelem.id == sv.id)).isNotEmpty) {
              syncStoresList(sv,sk);
            } else {
              allappstores.add(sv);
            }
          });
          
        });
        // logMessage(rescafprods.toString());
      } else {
        throw Exception(kCatAPIErr);
      }
    }).catchError((error) {
      // logError(error);
    });
  }

  doQryStoreUsers() async {
    if (admcurstore.isNotEmpty && allappstores.where((element) => (element.id == admcurstore.first.id)).isNotEmpty) {
      var postdata = {
          "mobapp" : mobAppVal,
          "qrymode" : "all",
          "store_id" : "$admcurstoreid",
          "filter" : "",
        };
      var posthdr = {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $logintoken'
          };
      http.post(storeqryPosEndPoint, body: postdata, headers: posthdr ).then((result) {
          if (result.statusCode == 200) {
            setState(() {
              var resary = jsonDecode(result.body);
              List<AtcStoreUser> tmpstrusers = [];
              if (resary['status'] > 0) {
                resary['data'].asMap().forEach((i, v) {
                  tmpstrusers.add(AtcStoreUser.fromJsonDet(v));
                });
                tmpstrusers.asMap().forEach((uk, uv) {
                  if (allstrusrs.where((prodelem) => (prodelem.id == uv.id)).isNotEmpty) {
                    syncStoreUsersList(uv, allstrusrs.indexWhere((element) => (element.id == uv.id)));
                  } else {
                    allstrusrs.add(uv);
                  }
                });
              }
            });
          }
      }).catchError((error) {
        setStatus(kStoreAPIErr);
      });
    }
  }

  syncStoreUsersList(AtcStoreUser fromStoreUser, int toStoreUserIdx) {
    allstrusrs[toStoreUserIdx].id=fromStoreUser.id;
    allstrusrs[toStoreUserIdx].storeid=fromStoreUser.storeid;
    allstrusrs[toStoreUserIdx].storecode=fromStoreUser.storecode;
    allstrusrs[toStoreUserIdx].usrname=fromStoreUser.usrname;
    allstrusrs[toStoreUserIdx].usrcode=fromStoreUser.usrcode;
    allstrusrs[toStoreUserIdx].usrpasscode=fromStoreUser.usrpasscode;
    allstrusrs[toStoreUserIdx].passcodebk=fromStoreUser.passcodebk;
    allstrusrs[toStoreUserIdx].ispos=fromStoreUser.ispos;
    allstrusrs[toStoreUserIdx].isinv=fromStoreUser.isinv;
    allstrusrs[toStoreUserIdx].iskitchen=fromStoreUser.iskitchen;
    allstrusrs[toStoreUserIdx].isfrontst=fromStoreUser.isfrontst;
    allstrusrs[toStoreUserIdx].active=fromStoreUser.active;
    allstrusrs[toStoreUserIdx].devip=fromStoreUser.devip;
    allstrusrs[toStoreUserIdx].devtoken=fromStoreUser.devtoken;
    allstrusrs[toStoreUserIdx].status=fromStoreUser.status;
    allstrusrs[toStoreUserIdx].staffimg=fromStoreUser.staffimg;
    allstrusrs[toStoreUserIdx].imgw=fromStoreUser.imgw;
    allstrusrs[toStoreUserIdx].imgh=fromStoreUser.imgh;
    allstrusrs[toStoreUserIdx].phone=fromStoreUser.phone;
    allstrusrs[toStoreUserIdx].name=fromStoreUser.name;
    allstrusrs[toStoreUserIdx].addr=fromStoreUser.addr;
    allstrusrs[toStoreUserIdx].addr2=fromStoreUser.addr2;
    allstrusrs[toStoreUserIdx].city=fromStoreUser.city;
    allstrusrs[toStoreUserIdx].zip=fromStoreUser.zip;
    allstrusrs[toStoreUserIdx].state=fromStoreUser.state;
    allstrusrs[toStoreUserIdx].country=fromStoreUser.country;
    allstrusrs[toStoreUserIdx].devinfo=fromStoreUser.devinfo;
    allstrusrs[toStoreUserIdx].created=fromStoreUser.created;
  }

  ListView _storesListView(data) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _tile(data[index].id, data[index].storename, data[index].storeemail +'\n'+ data[index].storephone, data[index].logoimg, Icons.local_mall);
      },
    );
  }

  ListTile _tile(int storeid, String title, String subtitle, String logopath, IconData icon) => ListTile(
    title: Text(title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(subtitle),
    leading: Icon(
      icon,
      color: admcurstoreid == storeid ? kPrimaryColor : inActiveIconColor,
      size: 48.0,
    ),
    trailing: Image.network(imagehost+logopath, fit: BoxFit.cover, height: 60.0, width: 60.0),
    onTap: () => refreshStore(storeid),
  );

  void refreshStore(int storeid) {
    setState(() {
      admcurstoreid = storeid;
      admcurstrusr=[];
      admcurstrusrid=0;
      admcurcat=[];
      admcurcatid=0;
      allstrcats = [];
      allstrprods = [];
      allstrusrs = [];
      admcurstore = allappstores.where((element) => (element.id == storeid)).toList();
      getuserPosition();
      doQryStoreUsers();
      doCatQryAll();
      doProdQryAll();
      curlatlng = LatLng(admcurstore.first.storelat,admcurstore.first.storelng);
      if (admcurstore.first.storelat == 0.0 && admcurstore.first.storelng == 0.0) {
        curlatlng = curusrpos;
        storelatlng = curusrpos;
        storecamerapos = CameraPosition(target: curusrpos ,zoom: 14,);
      }
    });
  }

  doCatQryAll() {
    List<Category> tmpstrcats = [];
    var postdata = {
        "mobapp" : mobAppVal,
        "qrymode" : "all",
        "store_id" : "$admcurstoreid", 
        "filter" : admcurcatsearch, 
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    http.post(categoryqryEndPoint, body: postdata, headers: posthdr).then((result) {
      if (result.statusCode == 200) {
        var resary = jsonDecode(result.body);
        setState(() {
          resary['data'].asMap().forEach((i, v) {
            tmpstrcats.add(Category.fromJsonDet(v));
          });
          tmpstrcats.asMap().forEach((pk, pv) {
            if (allstrcats.where((prodelem) => (prodelem.id == pv.id)).isNotEmpty) {
              syncCatsList(pv,pk);
            } else {
              allstrcats.add(pv);
            }
          });
          
        });
        // logMessage(rescafprods.toString());
      } else {
        throw Exception(kCatAPIErr);
      }
    }).catchError((error) {
      // logError(error);
    });
  }

  syncCatsList(Category fromCat, int toCatIdx) {
    allstrcats[toCatIdx].id = fromCat.id;
    allstrcats[toCatIdx].catname = fromCat.catname;
    allstrcats[toCatIdx].catslug = fromCat.catslug;
    allstrcats[toCatIdx].catdesc = fromCat.catdesc;
    allstrcats[toCatIdx].catsort = fromCat.catsort;
    allstrcats[toCatIdx].catactive = fromCat.catactive;
    allstrcats[toCatIdx].created = fromCat.created;
    allstrcats[toCatIdx].prods = fromCat.prods;
  }

  doProdQryAll() {
    List<Product> tmpstrprods = [];
    var postdata = {
        "qrymode": 'allbystore',
        "mobapp" : mobAppVal,
        "store_id" : "$admcurstoreid",
        "filter" : admcurprodsearch,
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    http.post(productqryEndPoint, body: postdata, headers: posthdr).then((result) {
      if (result.statusCode == 200) {
        var resary = jsonDecode(result.body);
        setState(() {
          resary['data'].asMap().forEach((i, v) {
            tmpstrprods.add(Product.fromJsonDet(v));
          });
          tmpstrprods.asMap().forEach((pk, pv) {
            if (allstrprods.where((prodelem) => (prodelem.id == pv.id)).isNotEmpty) {
              syncProdList(pv,pk);
            } else {
              allstrprods.add(pv);
            }
          });
        });
        // logMessage(rescafprods.toString());
      } else {
        throw Exception(kProdAPIErr);
      }
    }).catchError((error) {
      // logError(error);
    });
  }

  syncProdList(Product fromProd, int toProdIdx) {
    allstrprods[toProdIdx].id = fromProd.id;
    allstrprods[toProdIdx].storeid = fromProd.storeid;
    allstrprods[toProdIdx].storename = fromProd.storename;
    allstrprods[toProdIdx].catid = fromProd.catid;
    allstrprods[toProdIdx].catname = fromProd.catname;
    allstrprods[toProdIdx].prodname = fromProd.prodname;
    allstrprods[toProdIdx].prodcode = fromProd.prodcode;
    allstrprods[toProdIdx].prodslug = fromProd.prodslug;
    allstrprods[toProdIdx].proddesc = fromProd.proddesc;
    allstrprods[toProdIdx].prodsort = fromProd.prodsort;
    allstrprods[toProdIdx].prodico = fromProd.prodico;
    allstrprods[toProdIdx].prodimga = fromProd.prodimga;
    allstrprods[toProdIdx].prodimgb = fromProd.prodimgb;
    allstrprods[toProdIdx].prodimgc = fromProd.prodimgc;
    allstrprods[toProdIdx].prodpricesell = fromProd.prodpricesell;
    allstrprods[toProdIdx].prodpricebuy = fromProd.prodpricebuy;
    allstrprods[toProdIdx].prodtaxrate = fromProd.prodtaxrate;
    allstrprods[toProdIdx].prodactive = fromProd.prodactive;
    allstrprods[toProdIdx].stockunits = fromProd.stockunits;
    allstrprods[toProdIdx].minstock = fromProd.minstock;
    allstrprods[toProdIdx].prodcotype = fromProd.prodcotype;
    allstrprods[toProdIdx].prodsku = fromProd.prodsku;
    allstrprods[toProdIdx].prodref = fromProd.prodref;
    allstrprods[toProdIdx].weight = fromProd.weight;
    allstrprods[toProdIdx].weiunit = fromProd.weiunit;
    allstrprods[toProdIdx].sizew = fromProd.sizew;
    allstrprods[toProdIdx].sizeh = fromProd.sizeh;
    allstrprods[toProdIdx].sized = fromProd.sized;
    allstrprods[toProdIdx].sizeunit = fromProd.sizeunit;
    allstrprods[toProdIdx].supplid = fromProd.supplid;
  }

  void refreshonly() {
      setState(() {});
  }

}

