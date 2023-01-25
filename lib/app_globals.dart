library globals;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'dart:convert';

final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
String regemail='';
String regpassword='';
String regverifypassword='';
String regfirstName='';
String reglastName='';
String regphoneNumber='';
String regaddress='';
String regstorename='';
String regstoreaddr='';
String regstorephone='';
String regstorefax='';
String regtoken='';
String regcountryName='';
String regcountryCode='';
String regcountryPhoneCode='';

String logintoken='';
String loginemail='';
String loginpass='';

List<Category> admcurcat = [];
int admcurcatid = 0;
bool curcatactive = true;
List<Product> admcurprod = [];
int admcurprodid = 0;
bool curprodactive = true;

List<Category> allstrcats = [];
List<Product> allstrprods = [];

List<AtcStore> allappstores = [];
int admcurstoreid = 0;
List<AtcStore> admcurstore = [];

List<AtcStoreUser> allstrusrs = [];
int admcurstrusrid = 0;
List<AtcStoreUser> admcurstrusr = [];

String admusraction = 'edit';
bool curusractive = true;
bool curusrIsPos = true;
bool curusrIsInv = true;
bool curusrIsKitchen = true;
bool curusrIsFrontSt = true;

var admcurprodsearch = '' ; 
var admcurcatsearch = '' ; 
var admcurstrusrsearch = '' ; 
var admcurstrusrsessid;
final posCcy = new NumberFormat("#,##0.0", "en_US");
var emailphoneTxtCtrl =  TextEditingController();
var passwordTxtCtrl =  TextEditingController();
var verifypassTxtCtrl =  TextEditingController();
Codec<String, String> stringToBase64 = utf8.fuse(base64);
DateFormat dateDbFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

LatLng curlatlng = new LatLng(double.tryParse('0.0')!,double.tryParse('0.0')!) ;
LatLng newlatlng = new LatLng(double.tryParse('0.0')!,double.tryParse('0.0')!) ;
LatLng storelatlng = new LatLng(double.tryParse('0.0')!,double.tryParse('0.0')!) ;
LatLng curusrpos = new LatLng(double.tryParse('0.0')!,double.tryParse('0.0')!) ;
CameraPosition storecamerapos = CameraPosition(target: curlatlng,zoom: 14,);
Position curposition = Position(longitude: curlatlng.longitude,latitude: curlatlng.latitude,timestamp: DateTime.now(),accuracy:0.0,altitude:0.0,heading:0.0,speed:0.0,speedAccuracy:0.0,floor:1,isMocked:true);

List<AtcProfile> reguser = [];
var regstore ;
bool needVerify = false;
bool needFBaseVerify = false;

AlertDialog doingapialert = AlertDialog(content: new Row(children: [CircularProgressIndicator(),Container(margin: EdgeInsets.only(left: 5),child:Text("Loading data" ))]));
AlertDialog loginapialert = AlertDialog(content: new Row(children: [CircularProgressIndicator(),Container(margin: EdgeInsets.only(left: 5),child:Text("Sign in into Store Admin" ))]));

showLoginDialog(BuildContext context){
  AlertDialog alert=loginapialert;
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}

showAlertDialog(BuildContext context){
  AlertDialog alert=doingapialert;
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}

hideAlertDialog(BuildContext context){
  Navigator.pop(context);
}

mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => afterFirstLayout(context));
  }

  void afterFirstLayout(BuildContext context);
}

class AtcProfile {

int id;
int roleid;
String username;
String password;
String verifypassword;
String name;
String firstname;
String lastname;
String email;
String website;
String address;
String address2;
String phone;
String phonecode;
int pnverify;
DateTime codesent;
String sentvalue;
String fax;
int haslogo;
String logotext;
String logoimg;
int logow;
int logoh;
String selfimg;
int selfw;
int selfh;
String imghost;
String currency;
String zipcode;
String countryid;
String countryname;
String stateid;
String statename;
String cityname;
String localname;
String profilepath;
String activationkey;
bool status;
int banned;
String note;
String timezone;
String fbaseid;
String fbasecreds;
String twitid;
String twitcreds;
String fbid;
String fbcreds;
String awsid;
String awscreds;
String googleid;
String googlecreds;
int notifications;
double balance;
String data;
DateTime created;

  AtcProfile({required this.id, required this.roleid, required this.username, required this.password, required this.verifypassword, required this.name, required this.firstname, required this.lastname, required this.email,
              required this.website, required this.address, required this.address2, required this.phone, required this.phonecode, required this.pnverify, required this.codesent, required this.sentvalue,
              required this.fax, required this.haslogo, required this.logotext, required this.logoimg, required this.logow, required this.logoh, required this.selfimg, required this.selfw,
              required this.selfh, required this.imghost, required this.currency, required this.zipcode, required this.countryid, required this.countryname, required this.stateid, required this.statename,
              required this.cityname, required this.localname, required this.profilepath, required this.activationkey, required this.status, required this.banned, required this.note,
              required this.timezone, required this.fbaseid, required this.fbasecreds, required this.twitid, required this.twitcreds, required this.fbid, required this.fbcreds, required this.awsid,
              required this.awscreds, required this.googleid, required this.googlecreds, required this.notifications, required this.balance, required this.data, 
              required this.created });

  factory AtcProfile.fromArray(ary) {
    return AtcProfile(
      id: ary['id'],
      roleid: ary['role_id'],
      username: ary['username'],
      password: ary['password'],
      verifypassword: ary['verify_password'],
      name: ary['name'],
      firstname: ary['firstname'],
      lastname: ary['lastname'],
      email: ary['email'],
      website: ary['website'],
      address: ary['address'],
      address2: ary['address2'],
      phone: ary['phone'],
      phonecode: ary['phone_code'],
      pnverify: ary['pn_verify'],
      codesent: DateTime.parse(ary['code_sent']),
      sentvalue: ary['sent_value'],
      fax: ary['fax'],
      haslogo: ary['has_logo'],
      logotext: ary['logo_text'],
      logoimg: ary['logo_img'],
      logow: ary['logo_w'],
      logoh: ary['logo_h'],
      selfimg: ary['self_img'],
      selfw: ary['self_w'],
      selfh: ary['self_h'],
      imghost: ary['img_host'],
      currency: ary['currency'],
      zipcode: ary['zipcode'],
      countryid: ary['country_id'],
      countryname: ary['country_name'],
      stateid: ary['state_id'],
      statename: ary['state_name'],
      cityname: ary['city_name'],
      localname: ary['local_name'],
      profilepath: ary['profile_path'],
      activationkey: ary['activation_key'],
      status: ary['status'],
      banned: ary['banned'],
      note: ary['note'],
      timezone: ary['timezone'],
      fbaseid: ary['fbase_id'],
      fbasecreds: ary['fbase_creds'],
      twitid: ary['twit_id'],
      twitcreds: ary['twit_creds'],
      fbid: ary['fb_id'],
      fbcreds: ary['fb_creds'],
      awsid: ary['aws_id'],
      awscreds: ary['aws_creds'],
      googleid: ary['google_id'],
      googlecreds: ary['google_creds'],
      notifications: ary['notifications'],
      balance: ary['balance'].toDouble(),
      data: ary['data'],
      created: DateTime.parse(ary['created']),
    );
  }

  factory AtcProfile.fromJsonDet(json) {
    return AtcProfile(
      id: json['id'],
      roleid: json['role_id'],
      username: json['username'],
      password: json['password'],
      verifypassword: json['verify_password'],
      name: json['name'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      website: json['website'],
      address: json['address'],
      address2: json['address2'],
      phone: json['phone'],
      phonecode: json['phone_code'],
      pnverify: json['pn_verify'],
      codesent: DateTime.parse(json['code_sent']),
      sentvalue: json['sent_value'],
      fax: json['fax'],
      haslogo: json['has_logo'],
      logotext: json['logo_text'],
      logoimg: json['logo_img'],
      logow: json['logo_w'],
      logoh: json['logo_h'],
      selfimg: json['self_img'],
      selfw: json['self_w'],
      selfh: json['self_h'],
      imghost: json['img_host'],
      currency: json['currency'],
      zipcode: json['zipcode'],
      countryid: json['country_id'],
      countryname: json['country_name'],
      stateid: json['state_id'],
      statename: json['state_name'],
      cityname: json['city_name'],
      localname: json['local_name'],
      profilepath: json['profile_path'],
      activationkey: json['activation_key'],
      status: json['status'],
      banned: json['banned'],
      note: json['note'],
      timezone: json['timezone'],
      fbaseid: json['fbase_id'],
      fbasecreds: json['fbase_creds'],
      twitid: json['twit_id'],
      twitcreds: json['twit_creds'],
      fbid: json['fb_id'],
      fbcreds: json['fb_creds'],
      awsid: json['aws_id'],
      awscreds: json['aws_creds'],
      googleid: json['google_id'],
      googlecreds: json['google_creds'],
      notifications: json['notifications'],
      balance: json['balance'].toDouble(),
      data: json['data'],
      created: DateTime.parse(json['created']),
    );
  }

}

class AtcStore {

int id;
int userid;
String storecode;
String storename;
String storeemail;
String storephone;
String storefax;
String storeaddr;
String storeaddr2;
String storecity;
String storezip;
String storestate;
String storecountry;
String currency;
double storelat;
double storelng;
int rescaf;
int rescaftabs;
int rescaftake;
int cvsmart;
int pharmacy;
String logoimg;
int logow;
int logoh;
String uplogoimg;
int uplogow;
int uplogoh;
String bcntrycode;
String scntrycode;
String billingphone;
String billingname;
String billingaddr;
String billingaddr2;
String billingcity;
String billingzip;
String billingstate;
String billingcountry;
String shippingphone;
String shippingname;
String shippingaddr;
String shippingaddr2;
String shippingcity;
String shippingzip;
String shippingstate;
String shippingcountry;
String paymentmethod;
String cardowner;
String cardnumber;
String cardcode;
String cardyear;
String cardmonth;
String authorization;
String transaction;
double balance;
String accip;
String acctoken;
String devinfo;
DateTime created;
List<AtcStoreUser> storeusers;

  AtcStore({required this.id, required this.userid, required this.storecode, required this.storename, required this.storeemail, required this.storephone, 
            required this.storefax, required this.storeaddr, required this.storeaddr2, required this.storecity, required this.storezip, required this.storestate, 
            required this.storecountry, required this.currency, required this.storelat, required this.storelng, required this.rescaf, required this.rescaftabs, 
            required this.rescaftake, required this.cvsmart, required this.pharmacy, required this.logoimg, required this.logow, required this.logoh, 
            required this.uplogoimg, required this.uplogow, required this.uplogoh, required this.bcntrycode, required this.scntrycode, required this.billingphone, 
            required this.billingname, required this.billingaddr, required this.billingaddr2, required this.billingcity, required this.billingzip, 
            required this.billingstate, required this.billingcountry, required this.shippingphone, required this.shippingname, required this.shippingaddr, 
            required this.shippingaddr2, required this.shippingcity, required this.shippingzip, required this.shippingstate, required this.shippingcountry, 
            required this.paymentmethod, required this.cardowner, required this.cardnumber, required this.cardcode, required this.cardyear, required this.cardmonth, 
            required this.authorization, required this.transaction, required this.balance, required this.accip, required this.acctoken, required this.devinfo, 
            required this.created, required this.storeusers });

  factory AtcStore.fromArray(ary) {
    return AtcStore(
      id: ary['id'],
      userid: ary['user_id'],
      storecode: ary['store_code'],
      storename: ary['store_name'],
      storeemail: ary['store_email'],
      storephone: ary['store_phone'],
      storefax: ary['store_fax'],
      storeaddr: ary['store_addr'],
      storeaddr2: ary['store_addr2'],
      storecity: ary['store_city'],
      storezip: ary['store_zip'],
      storestate: ary['store_state'],
      storecountry: ary['store_country'],
      currency: ary['currency'],
      storelat: ary['store_lat'].toDouble(),
      storelng: ary['store_lng'].toDouble(),
      rescaf: ary['rescaf'],
      rescaftabs: ary['rescaf_tabs'],
      rescaftake: ary['rescaf_take'],
      cvsmart: ary['cvsmart'],
      pharmacy: ary['pharmacy'],
      logoimg: ary['logo_img'],
      logow: ary['logo_w'],
      logoh: ary['logo_h'],
      uplogoimg: ary['up_logo_img'],
      uplogow: ary['up_logo_w'],
      uplogoh: ary['up_logo_h'],
      bcntrycode: ary['bcntry_code'],
      scntrycode: ary['scntry_code'],
      billingphone: ary['billing_phone'],
      billingname: ary['billing_name'],
      billingaddr: ary['billing_addr'],
      billingaddr2: ary['billing_addr2'],
      billingcity: ary['billing_city'],
      billingzip: ary['billing_zip'],
      billingstate: ary['billing_state'],
      billingcountry: ary['billing_country'],
      shippingphone: ary['shipping_phone'],
      shippingname: ary['shipping_name'],
      shippingaddr: ary['shipping_addr'],
      shippingaddr2: ary['shipping_addr2'],
      shippingcity: ary['shipping_city'],
      shippingzip: ary['shipping_zip'],
      shippingstate: ary['shipping_state'],
      shippingcountry: ary['shipping_country'],
      paymentmethod: ary['payment_method'],
      cardowner: ary['card_owner'],
      cardnumber: ary['card_number'],
      cardcode: ary['card_code'],
      cardyear: ary['card_year'],
      cardmonth: ary['card_month'],
      authorization: ary['authorization'],
      transaction: ary['transaction'],
      balance: ary['balance'].toDouble(),
      accip: ary['acc_ip'],
      acctoken: ary['acc_token'],
      devinfo: ary['devinfo'],
      created: DateTime.parse(ary['created']),
      storeusers: modelAddStoreUsers(ary['storeusers']),
    );
  }

  factory AtcStore.fromJsonDet(json) {
    return AtcStore(
      id: json['id'],
      userid: json['user_id'],
      storecode: json['store_code'],
      storename: json['store_name'],
      storeemail: json['store_email'],
      storephone: json['store_phone'],
      storefax: json['store_fax'],
      storeaddr: json['store_addr'],
      storeaddr2: json['store_addr2'],
      storecity: json['store_city'],
      storezip: json['store_zip'],
      storestate: json['store_state'],
      storecountry: json['store_country'],
      currency: json['currency'],
      storelat: json['store_lat'].toDouble(),
      storelng: json['store_lng'].toDouble(),
      rescaf: json['rescaf'],
      rescaftabs: json['rescaf_tabs'],
      rescaftake: json['rescaf_take'],
      cvsmart: json['cvsmart'],
      pharmacy: json['pharmacy'],
      logoimg: json['logo_img'],
      logow: json['logo_w'],
      logoh: json['logo_h'],
      uplogoimg: json['up_logo_img'],
      uplogow: json['up_logo_w'],
      uplogoh: json['up_logo_h'],
      bcntrycode: json['bcntry_code'],
      scntrycode: json['scntry_code'],
      billingphone: json['billing_phone'],
      billingname: json['billing_name'],
      billingaddr: json['billing_addr'],
      billingaddr2: json['billing_addr2'],
      billingcity: json['billing_city'],
      billingzip: json['billing_zip'],
      billingstate: json['billing_state'],
      billingcountry: json['billing_country'],
      shippingphone: json['shipping_phone'],
      shippingname: json['shipping_name'],
      shippingaddr: json['shipping_addr'],
      shippingaddr2: json['shipping_addr2'],
      shippingcity: json['shipping_city'],
      shippingzip: json['shipping_zip'],
      shippingstate: json['shipping_state'],
      shippingcountry: json['shipping_country'],
      paymentmethod: json['payment_method'],
      cardowner: json['card_owner'],
      cardnumber: json['card_number'],
      cardcode: json['card_code'],
      cardyear: json['card_year'],
      cardmonth: json['card_month'],
      authorization: json['authorization'],
      transaction: json['transaction'],
      balance: json['balance'].toDouble(),
      accip: json['acc_ip'],
      acctoken: json['acc_token'],
      devinfo: json['devinfo'],
      created: DateTime.parse(json['created']),
      storeusers: modelAddStoreUsers(json['storeusers']),
    );
  }

}

List<AtcStoreUser> modelAddStoreUsers(detail) {
  List<AtcStoreUser> tmpdetail = [];
  if (detail.length>0) {
    detail.asMap().forEach((di, dv) {
      tmpdetail.add(AtcStoreUser.fromJsonDet(dv));
    });
  }
  return tmpdetail;
}

class AtcStoreUser {

int id;
int storeid;
String storecode;
String usrname;
String usrcode;
String usrpasscode;
String passcodebk;
int ispos;
int isinv;
int iskitchen;
int isfrontst;
int active;
String devip;
String devtoken;
String status;
String staffimg;
int imgw;
int imgh;
String phone;
String name;
String addr;
String addr2;
String city;
String zip;
String state;
String country;
String devinfo;
DateTime created;

  AtcStoreUser({required this.id, required this.storeid, required this.storecode, required this.usrname, required this.usrcode, required this.usrpasscode, 
                required this.passcodebk, required this.ispos, required this.isinv, required this.iskitchen, required this.isfrontst, required this.active, 
                required this.devip, required this.devtoken, required this.status, required this.staffimg, required this.imgw, required this.imgh, 
                required this.phone, required this.name, required this.addr, required this.addr2, required this.city, required this.zip, required this.state, 
                required this.country, required this.devinfo, required this.created});

  factory AtcStoreUser.fromArray(ary) {
    return AtcStoreUser(
      id: ary['id'],
      storeid: ary['store_id'],
      storecode: ary['store_code'],
      usrname: ary['usr_name'],
      usrcode: ary['usr_code'],
      usrpasscode: ary['usr_passcode'],
      passcodebk: ary['passcode_bk'],
      ispos: ary['is_pos'],
      isinv: ary['is_inv'],
      iskitchen: ary['is_kitchen'],
      isfrontst: ary['is_frontst'],
      active: ary['active'],
      devip: ary['dev_ip'],
      devtoken: ary['dev_token'],
      status: ary['status'],
      staffimg: ary['staff_img'],
      imgw: ary['img_w'],
      imgh: ary['img_h'],
      phone: ary['phone'],
      name: ary['name'],
      addr: ary['addr'],
      addr2: ary['addr2'],
      city: ary['city'],
      zip: ary['zip'],
      state: ary['state'],
      country: ary['country'],
      devinfo: ary['devinfo'],
      created: DateTime.parse(ary['created']),
    );
  }

  factory AtcStoreUser.fromJsonDet(json) {
    return AtcStoreUser(
      id: json['id'],
      storeid: json['store_id'],
      storecode: json['store_code'],
      usrname: json['usr_name'],
      usrcode: json['usr_code'],
      usrpasscode: json['usr_passcode'],
      passcodebk: json['passcode_bk'],
      ispos: json['is_pos'],
      isinv: json['is_inv'],
      iskitchen: json['is_kitchen'],
      isfrontst: json['is_frontst'],
      active: json['active'],
      devip: json['dev_ip'],
      devtoken: json['dev_token'],
      status: json['status'],
      staffimg: json['staff_img'],
      imgw: json['img_w'],
      imgh: json['img_h'],
      phone: json['phone'],
      name: json['name'],
      addr: json['addr'],
      addr2: json['addr2'],
      city: json['city'],
      zip: json['zip'],
      state: json['state'],
      country: json['country'],
      devinfo: json['devinfo'],
      created: DateTime.parse(json['created']),
    );
  }

}

class PosSession {

int id;
int posid;
double startcash;
DateTime timestart;
double endcash;
DateTime endtime;
double curcash;
DateTime curtime;
String mgrnote;
String cashiernote;
int totcurtkt;
int totendtkt;
int isworking;
int isbreak;
int isclose;
int stkupd;
DateTime created;

  PosSession({required this.id, required this.posid, required this.startcash, required this.timestart, required this.endcash, required this.endtime,
              required this.curcash, required this.curtime, required this.mgrnote, required this.cashiernote, required this.totcurtkt, required this.totendtkt,
              required this.isworking, required this.isbreak, required this.isclose, required this.stkupd, required this.created});

  factory PosSession.fromArray(ary) {
    return PosSession(
      id: ary['id'],
      posid: ary['pos_id'],
      startcash: ary['startcash'].toDouble(),
      timestart: DateTime.parse(ary['timestart']),
      endcash: ary['endcash'].toDouble(),
      endtime: DateTime.parse(ary['endtime']),
      curcash: ary['curcash'].toDouble(),
      curtime: DateTime.parse(ary['curtime']),
      mgrnote: ary['mgr_note'],
      cashiernote: ary['cashier_note'],
      totcurtkt: ary['totcurtkt'],
      totendtkt: ary['totendtkt'],
      isworking: ary['is_working'],
      isbreak: ary['is_break'],
      isclose: ary['is_close'],
      stkupd: ary['stkupd'],
      created: DateTime.parse(ary['created'])
    );
  }

  factory PosSession.fromJsonDet(json) {
    return PosSession(
      id: json['id'],
      posid: json['pos_id'],
      startcash: json['startcash'].toDouble(),
      timestart: DateTime.parse(json['timestart']),
      endcash: json['endcash'].toDouble(),
      endtime: DateTime.parse(json['endtime']),
      curcash: json['curcash'].toDouble(),
      curtime: DateTime.parse(json['curtime']),
      mgrnote: json['mgr_note'],
      cashiernote: json['cashier_note'],
      totcurtkt: json['totcurtkt'],
      totendtkt: json['totendtkt'],
      isworking: json['is_working'],
      isbreak: json['is_break'],
      isclose: json['is_close'],
      stkupd: json['stkupd'],
      created: DateTime.parse(json['created'])
    );
  }

}


class PosTicket {

int id;
int posid;
int sessid;
String firstname;
String lastname;
String email;
String phone;
String billingaddress;
String billingaddress2;
String billingcity;
String billingzip;
String billingstate;
String billingcountry;
String shippingaddress;
String shippingaddress2;
String shippingcity;
String shippingzip;
String shippingstate;
String shippingcountry;
double weight;
int itemcount;
double subtotal;
double tax;
double shipping;
double total;
double cash;
double cashchg;
String shippingmethod;
String paymentmethod;
String cardowner;
String cardnumber;
String cardcode;
String cardyear;
String cardmonth;
String authorization;
String transaction;
String status;
String ipaddress;
String remotehost;
String note;
String tktpdf;
DateTime created;
DateTime modified;
List<PosTktDet> detail;

  PosTicket({required this.id, required this.posid, required this.sessid, required this.firstname, required this.lastname, required this.email, required this.phone,
            required this.billingaddress, required this.billingaddress2, required this.billingcity, required this.billingzip, required this.billingstate, required this.billingcountry,
            required this.shippingaddress, required this.shippingaddress2, required this.shippingcity, required this.shippingzip, required this.shippingstate, required this.shippingcountry, required this.weight,
            required this.itemcount, required this.subtotal, required this.tax, required this.shipping, required this.total, required this.cash, required this.cashchg,
            required this.shippingmethod, required this.paymentmethod, required this.cardowner, required this.cardnumber, required this.cardcode, required this.cardyear, required this.cardmonth,
            required this.authorization, required this.transaction, required this.status, required this.ipaddress, required this.remotehost, required this.note, required this.tktpdf,
            required this.created, required this.modified, required this.detail});

  factory PosTicket.fromArray(ary) {
    return PosTicket(
      id : ary['id'],
      posid : ary['pos_id'],
      sessid : ary['sess_id'],
      firstname : ary['first_name'],
      lastname : ary['last_name'],
      email : ary['email'],
      phone : ary['phone'],
      billingaddress : ary['billing_address'],
      billingaddress2 : ary['billing_address2'],
      billingcity : ary['billing_city'],
      billingzip : ary['billing_zip'],
      billingstate : ary['billing_state'],
      billingcountry : ary['billing_country'],
      shippingaddress : ary['shipping_address'],
      shippingaddress2 : ary['shipping_address2'],
      shippingcity : ary['shipping_city'],
      shippingzip : ary['shipping_zip'],
      shippingstate : ary['shipping_state'],
      shippingcountry : ary['shipping_country'],
      weight : ary['weight'].toDouble(),
      itemcount : ary['item_count'],
      subtotal : ary['subtotal'].toDouble(),
      tax : ary['tax'].toDouble(),
      shipping : ary['shipping'].toDouble(),
      total : ary['total'].toDouble(),
      cash : ary['cash'].toDouble(),
      cashchg : ary['cashchg'].toDouble(),
      shippingmethod : ary['shipping_method'],
      paymentmethod : ary['payment_method'],
      cardowner : ary['card_owner'],
      cardnumber : ary['card_number'],
      cardcode : ary['card_code'],
      cardyear : ary['card_year'],
      cardmonth : ary['card_month'],
      authorization : ary['authorization'],
      transaction : ary['transaction'],
      status : ary['status'],
      ipaddress : ary['ip_address'],
      remotehost : ary['remote_host'],
      note : ary['note'],
      tktpdf : ary['tktpdf'],
      created : DateTime.parse(ary['created']),
      modified : DateTime.parse(ary['created']),
      detail: modelAddTktDetail(ary['detail']),
    );
  }

  factory PosTicket.fromJsonDet(json) {
    return PosTicket(
      id : json['id'],
      posid : json['pos_id'],
      sessid : json['sess_id'],
      firstname : json['first_name'],
      lastname : json['last_name'],
      email : json['email'],
      phone : json['phone'],
      billingaddress : json['billing_address'],
      billingaddress2 : json['billing_address2'],
      billingcity : json['billing_city'],
      billingzip : json['billing_zip'],
      billingstate : json['billing_state'],
      billingcountry : json['billing_country'],
      shippingaddress : json['shipping_address'],
      shippingaddress2 : json['shipping_address2'],
      shippingcity : json['shipping_city'],
      shippingzip : json['shipping_zip'],
      shippingstate : json['shipping_state'],
      shippingcountry : json['shipping_country'],
      weight : json['weight'].toDouble(),
      itemcount : json['item_count'],
      subtotal : json['subtotal'].toDouble(),
      tax : json['tax'].toDouble(),
      shipping : json['shipping'].toDouble(),
      total : json['total'].toDouble(),
      cash : json['cash'].toDouble(),
      cashchg : json['cashchg'].toDouble(),
      shippingmethod : json['shipping_method'],
      paymentmethod : json['payment_method'],
      cardowner : json['card_owner'],
      cardnumber : json['card_number'],
      cardcode : json['card_code'],
      cardyear : json['card_year'],
      cardmonth : json['card_month'],
      authorization : json['authorization'],
      transaction : json['transaction'],
      status : json['status'],
      ipaddress : json['ip_address'],
      remotehost : json['remote_host'],
      note : json['note'],
      tktpdf : json['tktpdf'],
      created : DateTime.parse(json['created']),
      modified : DateTime.parse(json['created']),
      detail: modelAddTktDetail(json['detail']),
    );
  }

}

List<PosTktDet> modelAddTktDetail(detail) {
  List<PosTktDet> tmpdetail = [];
  if (detail.length>0) {
    detail.asMap().forEach((di, dv) {
      tmpdetail.add(PosTktDet.fromJsonDet(dv));
    });
  }
  return tmpdetail;
}


class PosTktDet {

int id;
int sessid;
int tktid;
int prodid;
String prdname;
int prdoptid;
String prdoptname;
String color;
int quantity;
double weight;
double price;
double tax;
double subtotal;
String note;
int stkupd;
DateTime created;

  PosTktDet({required this.id, required this.sessid, required this.tktid, required this.prodid, required this.prdname, required this.prdoptid, required this.prdoptname,
            required this.color, required this.quantity, required this.weight, required this.price, required this.tax, required this.subtotal,
            required this.note, required this.stkupd, required this.created});

  factory PosTktDet.fromArray(ary) {
    return PosTktDet(
      id : ary['id'],
      sessid : ary['sess_id'],
      tktid : ary['tkt_id'],
      prodid : ary['prod_id'],
      prdname : ary['prd_name'],
      prdoptid : ary['prdopt_id'],
      prdoptname : ary['prdopt_name'],
      color : ary['color'],
      quantity : ary['quantity'],
      weight : ary['weight'].toDouble(),
      price : ary['price'].toDouble(),
      tax : ary['tax'].toDouble(),
      subtotal : ary['subtotal'].toDouble(),
      note : ary['note'],
      stkupd : ary['stkupd'],
      created : DateTime.parse(ary['created']),
    );
  }

  factory PosTktDet.fromJsonDet(json) {
    return PosTktDet(
      id : json['id'],
      sessid : json['sess_id'],
      tktid : json['tkt_id'],
      prodid : json['prod_id'],
      prdname : json['prd_name'],
      prdoptid : json['prdopt_id'],
      prdoptname : json['prdopt_name'],
      color : json['color'],
      quantity : json['quantity'],
      weight : json['weight'].toDouble(),
      price : json['price'].toDouble(),
      tax : json['tax'].toDouble(),
      subtotal : json['subtotal'].toDouble(),
      note : json['note'],
      stkupd : json['stkupd'],
      created : DateTime.parse(json['created']),
    );
  }

}

class RescafTable {

  int id;
  int storeid;
  String storename;
  List<RescafOrder> orders = [];
  String tablename;

  RescafTable({required this.id, required this.storeid, required this.storename, required this.orders, required this.tablename});

  factory RescafTable.fromArray(ary) {
    return RescafTable(
      id: ary[0],
      storeid: ary[1],
      storename: ary[2],
      orders: ary[3],
      tablename: ary[4],
    );
  }

}

class RescafOrder {

  int id;
  int storeid;
  String storename;
  List<RescafOrdProd> detail;
  int sessid;
  int posid;
  int frontid;
  int kitchenid;
  int invid;
  int secposid;
  int secfrontid;
  int seckitid;
  int secinvid;
  int rescaf;
  int rescaftab;
  int rescaftake;
  int itemcount;
  double subtotal;
  double tax;
  double total;
  double cash;
  double cashchg;
  double shipfee;
  String status;
  int rescafcheckout;
  String rescafcheckoutlog;
  int rescafpaid;
  String rescafpaidlog;
  int paid;
  int shipped;
  DateTime created;

  RescafOrder({required this.id, required this.storeid, required this.storename, required this.detail, required this.sessid, required this.posid, required this.frontid, required this.kitchenid, required this.invid, 
              required this.secposid, required this.secfrontid, required this.seckitid, required this.secinvid, required this.rescaf, required this.rescaftab, 
              required this.rescaftake, required this.itemcount, required this.subtotal, required this.tax, required this.total, required this.cash, required this.cashchg, 
              required this.shipfee, required this.status, required this.rescafcheckout, required this.rescafcheckoutlog, required this.rescafpaid, required this.rescafpaidlog, 
              required this.paid, required this.shipped, required this.created});

  factory RescafOrder.fromArray(ary) {
    return RescafOrder(
      id: ary['id'],
      storeid: ary['store_id'],
      storename: ary['store_name'],
      detail: modelAddOrdDetail(ary['detail']),
      sessid: ary['sess_id'],
      posid: ary['pos_id'],
      frontid: ary['front_id'],
      kitchenid: ary['kitchen_id'],
      invid: ary['inv_id'],
      secposid: ary['secpos_id'],
      secfrontid: ary['secfront_id'],
      seckitid: ary['seckit_id'],
      secinvid: ary['secinv_id'],
      rescaf: ary['rescaf'],
      rescaftab: ary['rescaf_tab'],
      rescaftake: ary['rescaf_take'],
      itemcount: ary['item_count'],
      subtotal: ary['subtotal'].toDouble(),
      tax: ary['tax'].toDouble(),
      total: ary['total'].toDouble(),
      cash: ary['cash'].toDouble(),
      cashchg: ary['cashchg'].toDouble(),
      shipfee: ary['shipfee'].toDouble(),
      status: ary['status'],
      rescafcheckout: ary['rescaf_checkout'],
      rescafcheckoutlog: ary['rescafcheckout_log'],
      rescafpaid: ary['rescaf_paid'],
      rescafpaidlog: ary['rescafpaid_log'],
      paid: ary['paid'],
      shipped: ary['shipped'],
      created: DateTime.parse(ary['created']),
    );
  }

  factory RescafOrder.fromJsonDet(json) {
    return RescafOrder(
      id: json['id'],
      storeid: json['store_id'],
      storename: json['store_name'],
      detail: modelAddOrdDetail(json['detail']),
      sessid: json['sess_id'],
      posid: json['pos_id'],
      frontid: json['front_id'],
      kitchenid: json['kitchen_id'],
      invid: json['inv_id'],
      secposid: json['secpos_id'],
      secfrontid: json['secfront_id'],
      seckitid: json['seckit_id'],
      secinvid: json['secinv_id'],
      rescaf: json['rescaf'],
      rescaftab: json['rescaf_tab'],
      rescaftake: json['rescaf_take'],
      itemcount: json['item_count'],
      subtotal: json['subtotal'].toDouble(),
      tax: json['tax'].toDouble(),
      total: json['total'].toDouble(),
      cash: json['cash'].toDouble(),
      cashchg: json['cashchg'].toDouble(),
      shipfee: json['shipfee'].toDouble(),
      status: json['status'],
      rescafcheckout: json['rescaf_checkout'],
      rescafcheckoutlog: json['rescafcheckout_log'],
      rescafpaid: json['rescaf_paid'],
      rescafpaidlog: json['rescafpaid_log'],
      paid: json['paid'],
      shipped: json['shipped'],
      created: DateTime.parse(json['created']),
    );
  }

}

List<RescafOrdProd> modelAddOrdDetail(detail) {
  List<RescafOrdProd> tmpdetail = [];
  if (detail.length>0) {
    detail.asMap().forEach((di, dv) {
      tmpdetail.add(RescafOrdProd.fromJsonDet(dv));
    });
  }
  return tmpdetail;
}

class RescafOrdProd {

	int id;
	int orderid;
	int prodid;
	String prodcode;
	String prdname;
	int quantity;
	double price;
	double tax;
	double subtotal;
	int kitchenneed;
	int kitchenaccept;
	int kitchendone;
  String kitchenstatus;
	int kitchenid;
	int invneed;
	int invaccept;
	int invdone;
  String invstatus;
	int invid;
	int delivered;
	String frontstatus;
	int frontid;
	int rescaf;
	int rescaftab;
	int rescaftake;
  int secfrontid;
  String secfrontstatus;
  int seckitid;
  String seckitstatus;
  int secinvid;
  String secinvstatus;
  int secposid;
  String secposstatus;
  DateTime created;

  RescafOrdProd({required this.id, required this.orderid, required this.prodid, required this.prodcode, required this.prdname, required this.quantity, required this.price, required this.tax, 
                required this.subtotal, required this.kitchenneed, required this.kitchenaccept, required this.kitchendone, required this.kitchenstatus, required this.kitchenid, required this.invneed, 
                required this.invaccept, required this.invdone, required this.invstatus, required this.invid, required this.delivered, required this.frontstatus, required this.frontid, 
                required this.rescaf, required this.rescaftab, required this.rescaftake, required this.secfrontid, required this.secfrontstatus, required this.seckitid, required this.seckitstatus, 
                required this.secinvid, required this.secinvstatus, required this.secposid, required this.secposstatus, required this.created});

  factory RescafOrdProd.fromArray(ary) {
    return RescafOrdProd(
      id: ary['id'],
      orderid: ary['order_id'],
      prodid: ary['prod_id'],
      prodcode: ary['prod_code'],
      prdname: ary['prd_name'],
      quantity: ary['quantity'],
      price: ary['price'].toDouble(),
      tax: ary['tax'].toDouble(),
      subtotal: ary['subtotal'].toDouble(),
      kitchenneed: ary['kitchen_need'],
      kitchenaccept: ary['kitchen_accept'],
      kitchendone: ary['kitchen_done'],
      kitchenstatus: ary['kitchen_status'],
      kitchenid: ary['kitchen_id'],
      invneed: ary['inv_need'],
      invaccept: ary['inv_accept'],
      invdone: ary['inv_done'],
      invstatus: ary['inv_status'],
      invid: ary['inv_id'],
      delivered: ary['delivered'],
      frontstatus: ary['front_status'],
      frontid: ary['front_id'],
      rescaf: ary['rescaf'],
      rescaftab: ary['rescaf_tab'],
      rescaftake: ary['rescaf_take'],
      secfrontid: ary['secfront_id'],
      secfrontstatus: ary['secfront_status'],
      seckitid: ary['seckit_id'],
      seckitstatus: ary['seckit_status'],
      secinvid: ary['secinv_id'],
      secinvstatus: ary['secinv_status'],
      secposid: ary['secpos_id'],
      secposstatus: ary['secpos_status'],
      created: DateTime.parse(ary['created']),
    );
  }

  factory RescafOrdProd.fromJsonDet(json) {
    return RescafOrdProd(
      id: json['id'],
      orderid: json['order_id'],
      prodid: json['prod_id'],
      prodcode: json['prod_code'],
      prdname: json['prd_name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      tax: json['tax'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
      kitchenneed: json['kitchen_need'],
      kitchenaccept: json['kitchen_accept'],
      kitchendone: json['kitchen_done'],
      kitchenstatus: json['kitchen_status'],
      kitchenid: json['kitchen_id'],
      invneed: json['inv_need'],
      invaccept: json['inv_accept'],
      invdone: json['inv_done'],
      invstatus: json['inv_status'],
      invid: json['inv_id'],
      delivered: json['delivered'],
      frontstatus: json['front_status'],
      frontid: json['front_id'],
      rescaf: json['rescaf'],
      rescaftab: json['rescaf_tab'],
      rescaftake: json['rescaf_take'],
      secfrontid: json['secfront_id'],
      secfrontstatus: json['secfront_status'],
      seckitid: json['seckit_id'],
      seckitstatus: json['seckit_status'],
      secinvid: json['secinv_id'],
      secinvstatus: json['secinv_status'],
      secposid: json['secpos_id'],
      secposstatus: json['secpos_status'],
      created: DateTime.parse(json['created']),
    );
  }

}

class RescafCounted {

  int id;
  int storeid;
  String storename;
  List<RescafOrder> detail;
  int sessid;
  int posid;
  int ordercount;
  String orders;
  double subtotal;
  double tax;
  double total;
  String ipaddress;
  String remotehost;
  String comment;
  String note;
  DateTime created;
  String posname;
  String posusername;

  RescafCounted({required this.id, required this.storeid, required this.storename, required this.detail, required this.sessid, required this.posid, 
              required this.ordercount, required this.orders, required this.subtotal, required this.tax, required this.total, required this.ipaddress, 
              required this.remotehost, required this.comment, required this.note, required this.created, required this.posname, required this.posusername});

  factory RescafCounted.fromArray(ary) {
    return RescafCounted(
      id: ary['id'],
      storeid: ary['store_id'],
      storename: ary['store_name'],
      detail: modelAddSessDetail(ary['detail']),
      sessid: ary['sess_id'],
      posid: ary['pos_id'],
      ordercount: ary['order_count'],
      orders: ary['orders'],
      subtotal: ary['subtotal'].toDouble(),
      tax: ary['tax'].toDouble(),
      total: ary['total'].toDouble(),
      ipaddress: ary['ip_address'],
      remotehost: ary['remote_host'],
      comment: ary['comment'],
      note: ary['note'],
      created: DateTime.parse(ary['created']),
      posname: ary['pos_name'],
      posusername: ary['pos_username'],
    );
  }

  factory RescafCounted.fromJsonDet(json) {
    return RescafCounted(
      id: json['id'],
      storeid: json['store_id'],
      storename: json['store_name'],
      detail: modelAddSessDetail(json['detail']),
      sessid: json['sess_id'],
      posid: json['pos_id'],
      ordercount: json['order_count'],
      orders: json['orders'],
      subtotal: json['subtotal'].toDouble(),
      tax: json['tax'].toDouble(),
      total: json['total'].toDouble(),
      ipaddress: json['ip_address'],
      remotehost: json['remote_host'],
      comment: json['comment'],
      note: json['note'],
      created: DateTime.parse(json['created']),
      posname: json['pos_name'],
      posusername: json['pos_username'],
    );
  }

}

List<RescafOrder> modelAddSessDetail(detail) {
  List<RescafOrder> tmpdetail = [];
  if (detail.length>0) {
    detail.asMap().forEach((di, dv) {
      tmpdetail.add(RescafOrder.fromJsonDet(dv));
    });
  }
  return tmpdetail;
}

class ResCafProduct {

  int id;
  int storeid;
  String storename;
  int catid;
  String catname;
  String prodname;
  String prodcode;
  String prodslug;
  String proddesc;
  int prodsort;
  String prodico;
  String prodimga;
  String prodimgb;
  String prodimgc;
  double prodpricesell;
  double prodpricebuy;
  double prodtaxrate;
  int prodactive;
  int stockunits;
  int minstock;

  ResCafProduct({required this.id, required this.storeid, required this.storename, required this.catid, required this.catname, required this.prodname, required this.prodcode, 
      required this.prodslug, required this.proddesc, required this.prodsort, required this.prodico, required this.prodimga, required this.prodimgb, required this.prodimgc, 
      required this.prodactive, required this.prodpricesell, required this.prodpricebuy, required this.prodtaxrate, required this.stockunits, required this.minstock});

  factory ResCafProduct.fromArray(ary) {
    return ResCafProduct(
      id: ary['id'],
      storeid: ary['store_id'],
      storename: ary['store_name'],
      catid: ary['cat_id'],
      catname: ary['cat_name'],
      prodname: ary['name'],
      prodcode: ary['prod_code'],
      prodslug: ary['slug'],
      proddesc: ary['description'],
      prodsort: ary['sort'],
      prodico: ary['prod_ico'],
      prodimga: ary['prod_imga'],
      prodimgb: ary['prod_imgb'],
      prodimgc: ary['prod_imgc'],
      prodpricesell: ary['pricesell'].toDouble(),
      prodpricebuy: ary['pricebuy'].toDouble(),
      prodtaxrate: ary['taxrate'].toDouble(),
      prodactive: ary['active'],
      stockunits: ary['stockunits'],
      minstock: ary['minstock'],
    );
  }

  factory ResCafProduct.fromJsonDet(json) {
    return ResCafProduct(
      id: json['id'],
      storeid: json['store_id'],
      storename: json['store_name'],
      catid: json['cat_id'],
      catname: json['cat_name'],
      prodname: json['name'],
      prodcode: json['prod_code'],
      prodslug: json['slug'],
      proddesc: json['description'],
      prodsort: json['sort'],
      prodico: json['prod_ico'],
      prodimga: json['prod_imga'],
      prodimgb: json['prod_imgb'],
      prodimgc: json['prod_imgc'],
      prodpricesell: json['pricesell'].toDouble(),
      prodpricebuy: json['pricebuy'].toDouble(),
      prodtaxrate: json['taxrate'].toDouble(),
      prodactive: json['active'],
      stockunits: json['stockunits'],
      minstock: json['minstock'],
    );
  }

}

class Category {
  int id;
  String catname;
  String catslug;
  String catdesc;
  int catsort;
  int catactive;
  DateTime created;
  List<Product> prods;

  Category({required this.id, required this.catname, required this.catslug, required this.catdesc, 
            required this.catsort, required this.catactive, required this.created, required this.prods});

  factory Category.fromArray(ary) {
    return Category(
      id: ary['id'],
      catname: ary['name'],
      catslug: ary['slug'],
      catdesc: ary['description'],
      catsort: ary['sort'],
      catactive: ary['active'],
      created: DateTime.parse(ary['created']),
      prods: modelAddCatProds(ary['prods']),
    );
  }

  factory Category.fromJsonDet(json) {
    return Category(
      id: json['id'],
      catname: json['name'],
      catslug: json['slug'],
      catdesc: json['description'],
      catsort: json['sort'],
      catactive: json['active'],
      created: DateTime.parse(json['created']),
      prods: modelAddCatProds(json['prods']),
    );
  }

}

List<Product> modelAddCatProds(detail) {
  List<Product> tmpdetail = [];
  if (detail.length>0) {
    detail.asMap().forEach((di, dv) {
      tmpdetail.add(Product.fromJsonDet(dv));
    });
  }
  return tmpdetail;
}


class Product {

  int id;
  int storeid;
  String storename;
  int catid;
  String catname;
  String prodname;
  String prodcode;
  String prodslug;
  String proddesc;
  int prodsort;
  String prodico;
  String prodimga;
  String prodimgb;
  String prodimgc;
  double prodpricesell;
  double prodpricebuy;
  double prodtaxrate;
  int prodactive;
  int stockunits;
  int minstock;
  String prodcotype;
  String prodsku;
  String prodref;
  double weight;
  String weiunit;
  double sizew;
  double sizeh;
  double sized;
  String sizeunit;
  int supplid;
  DateTime created;

  Product({required this.id, required this.storeid, required this.storename, required this.catid, required this.catname, required this.prodname, required this.prodcode, 
      required this.prodslug, required this.proddesc, required this.prodsort, required this.prodico, required this.prodimga, required this.prodimgb, required this.prodimgc, 
      required this.prodactive, required this.prodpricesell, required this.prodpricebuy, required this.prodtaxrate, required this.stockunits, required this.minstock,
      required this.prodcotype, required this.prodsku, required this.prodref, required this.weight, required this.weiunit, 
      required this.sizew, required this.sizeh, required this.sized, required this.sizeunit, required this.supplid, required this.created});

  factory Product.fromArray(ary) {
    return Product(
      id: ary['id'],
      storeid: ary['store_id'],
      storename: ary['store_name'],
      catid: ary['cat_id'],
      catname: ary['cat_name'],
      prodname: ary['name'],
      prodcode: ary['prod_code'],
      prodslug: ary['slug'],
      proddesc: ary['description'],
      prodsort: ary['sort'],
      prodico: ary['prod_ico'],
      prodimga: ary['prod_imga'],
      prodimgb: ary['prod_imgb'],
      prodimgc: ary['prod_imgc'],
      prodpricesell: ary['pricesell'].toDouble(),
      prodpricebuy: ary['pricebuy'].toDouble(),
      prodtaxrate: ary['taxrate'].toDouble(),
      prodactive: ary['active'],
      stockunits: ary['stockunits'],
      minstock: ary['minstock'],
      prodcotype: ary['prod_cotype'],
      prodsku: ary['prod_sku'],
      prodref: ary['prod_ref'],
      weight: ary['weight'].toDouble(),
      weiunit: ary['weiunit'],
      sizew: ary['size_w'].toDouble(),
      sizeh: ary['size_h'].toDouble(),
      sized: ary['size_d'].toDouble(),
      sizeunit: ary['sizeunit'],
      supplid: ary['suppl_id'],
      created: DateTime.parse(ary['created']),
    );
  }

  factory Product.fromJsonDet(json) {
    return Product(
      id: json['id'],
      storeid: json['store_id'],
      storename: json['store_name'],
      catid: json['cat_id'],
      catname: json['cat_name'],
      prodname: json['name'],
      prodcode: json['prod_code'],
      prodslug: json['slug'],
      proddesc: json['description'],
      prodsort: json['sort'],
      prodico: json['prod_ico'],
      prodimga: json['prod_imga'],
      prodimgb: json['prod_imgb'],
      prodimgc: json['prod_imgc'],
      prodpricesell: json['pricesell'].toDouble(),
      prodpricebuy: json['pricebuy'].toDouble(),
      prodtaxrate: json['taxrate'].toDouble(),
      prodactive: json['active'],
      stockunits: json['stockunits'],
      minstock: json['minstock'],
      prodcotype: json['prod_cotype'],
      prodsku: json['prod_sku'],
      prodref: json['prod_ref'],
      weight: json['weight'].toDouble(),
      weiunit: json['weiunit'],
      sizew: json['size_w'].toDouble(),
      sizeh: json['size_h'].toDouble(),
      sized: json['size_d'].toDouble(),
      sizeunit: json['sizeunit'],
      supplid: json['suppl_id'],
      created: DateTime.parse(json['created']),
    );
  }

}
