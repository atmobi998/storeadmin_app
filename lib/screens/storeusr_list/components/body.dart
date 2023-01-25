import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:pdf/pdf.dart';
// import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:shopadmin_app/components/custom_surfix_icon.dart';
import 'package:shopadmin_app/helper/keyboard.dart';
import 'package:shopadmin_app/components/default_button.dart';
import 'package:shopadmin_app/components/form_error.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/size_config.dart';
import 'package:barcode_widget/barcode_widget.dart';

class PosSess {
  int id;
  int posid;
  double startcash;
  String timestart;
  double endcash;
  String endtime;
  double curcash;
  String curtime;
  int totcurtkt;
  int totendtkt;
  int isworking;
  int isbreak;
  int isclose;

  PosSess({required this.id,required this.posid,required this.startcash,required this.timestart,required this.endcash,required this.endtime,
  required this.curcash,required this.curtime,required this.totcurtkt,required this.totendtkt,required this.isworking,required this.isbreak,required this.isclose});

  factory PosSess.fromJson(Map<String, dynamic> json) {
    return PosSess(
      id: json['id'],
      posid: json['pos_id'],
      startcash: json['startcash'].toDouble(),
      timestart: json['timestart'],
      endcash: json['endcash'].toDouble(),
      endtime: json['endtime'],
      curcash: json['curcash'].toDouble(),
      curtime: json['curtime'],
      totcurtkt: json['totcurtkt'],
      totendtkt: json['totendtkt'],
      isworking: json['is_working'],
      isbreak: json['is_break'],
      isclose: json['is_close'],
    );
  }
}

class StoreUserListBody extends StatefulWidget {

    @override
    _StoreUserListBody createState() => _StoreUserListBody();

}

class _StoreUserListBody extends State<StoreUserListBody> with AfterLayoutMixin<StoreUserListBody> {

  final _formUserKey = GlobalKey<FormState>();
  int storeid = (admcurstore.isNotEmpty)? admcurstore.first.id : 0;
  String storeCode = (admcurstore.isNotEmpty)? admcurstore.first.storecode : "";
  int strusrId = (admcurstrusr.isNotEmpty)? admcurstrusr.first.id : 0 ;
  String usrName = (admcurstrusr.isNotEmpty)? admcurstrusr.first.usrname : "" ;
  String usrCode = (admcurstrusr.isNotEmpty)? admcurstrusr.first.usrcode : "" ;
  String usrPassCode = '';
  String usrPassCodeBk = (admcurstrusr.isNotEmpty)? admcurstrusr.first.passcodebk : "" ;
  int usrActive = (admcurstrusr.isNotEmpty)? admcurstrusr.first.active : 0 ;
  int usrIsPos = (admcurstrusr.isNotEmpty)? admcurstrusr.first.ispos : 0 ;
  int usrIsInv = (admcurstrusr.isNotEmpty)? admcurstrusr.first.isinv : 0 ;
  int usrIsKitchen = (admcurstrusr.isNotEmpty)? admcurstrusr.first.iskitchen : 0 ;
  int usrIsFrontSt = (admcurstrusr.isNotEmpty)? admcurstrusr.first.isfrontst : 0 ;
  String usrStatus = (admcurstrusr.isNotEmpty)? admcurstrusr.first.status : "" ;
  String usrStaffPhone = (admcurstrusr.isNotEmpty)? admcurstrusr.first.phone : "" ;
  String usrStaffName = (admcurstrusr.isNotEmpty)? admcurstrusr.first.name : "" ;
  String usrStaffAddr = (admcurstrusr.isNotEmpty)? admcurstrusr.first.addr : "" ;
  String usrStaffAddr2 = (admcurstrusr.isNotEmpty)? admcurstrusr.first.addr2 : "" ;
  String usrStaffCity = (admcurstrusr.isNotEmpty)? admcurstrusr.first.city : "" ;
  String usrStaffZip = (admcurstrusr.isNotEmpty)? admcurstrusr.first.zip : "" ;
  String usrStaffState = (admcurstrusr.isNotEmpty)? admcurstrusr.first.state : "" ;
  String usrStaffCountry = (admcurstrusr.isNotEmpty)? admcurstrusr.first.country : "" ;
  bool usrNewCode = false;
  var usrnameCtler = new TextEditingController();
  var usrcodeCtler = new TextEditingController();
  var statusCtler = new TextEditingController();
  var phoneCtler = new TextEditingController();
  var nameCtler = new TextEditingController();
  var addrCtler = new TextEditingController();
  var addr2Ctler = new TextEditingController();
  var cityCtler = new TextEditingController();
  var stateCtler = new TextEditingController();
  var countryCtler = new TextEditingController();
  var storecodeCtler = new TextEditingController();
  var passcodeCtler = new TextEditingController();
  var zipCtler = new TextEditingController();

  Future<XFile?>? imgfile;
  String poststatus = '';
  String? base64StaffImage='';
  XFile? tmpimgFile;
  List<String> errors = [];
  bool pickimg=false;
  final ImagePicker _pickera = ImagePicker();
  pw.Document doc = pw.Document();
  ByteData? printfont;
  var liststrusrs = allstrusrs;

  loadPrintFont() async {
    printfont = await rootBundle.load("assets/fonts/open-sans/OpenSans-Regular.ttf");
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // doQryStoreUsers();
    setSearch('');
    loadPrintFont();
    setState(() {
        
    });
  }

  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return SafeArea(
      child: Row(
          children: [
              Form( key: _formUserKey,
                child: Row(
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(defListFormMaxWidth),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(defFormFieldEdges05)),
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges05)),
                              storeUserListBody(),
                              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(defFormFieldEdges20)),
                    SizedBox(
                      width: (admcurstrusr.isNotEmpty && admusraction == 'edit')? getProportionateScreenWidth(defListFormMaxWidth) : (admcurstrusr.isNotEmpty && admusraction == 'list')? getProportionateScreenWidth(defEditFormMaxWidth) :getProportionateScreenWidth(defListFormMaxWidth), 
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(defFormFieldEdges05)),
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: (admcurstrusr.isNotEmpty && admusraction == 'edit')? storeUserEditBody() : Container(),
                        ),
                      ),
                    ),
                  ]
                ),
              ),
          ],
        ),
    );
  }

  storeUserEditBody() {
    return Container(
      width: defInpFormWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: defInpFormMaxWidth,
        ),
        child: Container(
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              buildUserCodeDraw(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              GreyButton(
                text: txtPrintUserAccessCode,
                press: () {
                    printUserAccessCode();
                },
              ),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              buildUserNameFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildStaffNameFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildStaffPhoneFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildStaffAddrFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildStaffAddress2FormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildStaffCityFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildStaffZipFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildStaffStateFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildStaffCountryFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildActiveFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildIsPosFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildIsInvFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildIsKitchenFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildIsFrontstFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              GreyButton(
                text: txtPickStaffPhoto,
                press: () {
                    chooseImageStaff();
                },
              ),
              SizedBox(
                height: getProportionateScreenHeight(200),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                          showStaffImage(),
                          SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                        ],
                      ),
              ),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              buildStoreCodeFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildPassCodeFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              buildUserCodeFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges05)),
              GreyButton(
                text: lblResetUserCode,
                press: () {
                    newUserCode();
                },
              ),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              Text(poststatus, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              DefaultButton(
                text: lblSaveUser,
                press: () {
                  if (_formUserKey.currentState!.validate()) {
                    storeUserSaveChanges();
                  }
                },
              ),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges30)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  setUserActive(bool newvalue) {
    setState(() {
      curusractive=newvalue;
      if (curusractive) {
        usrActive = 1;
      } else {
        usrActive = 0;
        setUserIsPos(false);
        setUserIsInv(false);
        setUserIsKitchen(false);
        setUserIsFrontst(false);
      }
    });
  }

  Container buildActiveFormField() {
    return Container(
      height: defChkInpHeight,
      width: defChkInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defChkInpMaxHeight,
          maxWidth: defChkInpMaxWidth,
        ),
        child: CheckboxListTile(
          activeColor: Theme.of(context).colorScheme.secondary,
          title: Text(txtTitleActStaff),
          value: curusractive,
          onChanged: (value) => setUserActive(value!),
          subtitle: !curusractive
            ? Padding(
                padding: EdgeInsets.fromLTRB(12.0, 0, 0, 0), 
                child: Text(txtChkActive, style: TextStyle(color: Color(0xFFe53935), fontSize: getProportionateScreenWidth(12))))
            : null,
        ),
      ),
    );
  }

  setUserIsPos(bool newvalue) {
    setState(() {
      curusrIsPos=newvalue;
      if (curusrIsPos) {
        usrIsPos = 1;
        setUserActive(true);
      } else {
        usrIsPos = 0;
      }
    });
  }

  Container buildIsPosFormField() {
    return Container(
      height: defChkInpHeight,
      width: defChkInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defChkInpMaxHeight,
          maxWidth: defChkInpMaxWidth,
        ),
        child: CheckboxListTile(
          activeColor: Theme.of(context).colorScheme.secondary,
          title: Text(txtTitleIsPos),
          value: curusrIsPos,
          onChanged: (value) => setUserIsPos(value!),
          subtitle: !curusrIsPos
            ? Padding(
                padding: EdgeInsets.fromLTRB(12.0, 0, 0, 0), 
                child: Text(txtChkIsPos, style: TextStyle(color: Color(0xFFe53935), fontSize: getProportionateScreenWidth(12))))
            : null,
        ),
      ),
    );
  }

  setUserIsInv(bool newvalue) {
    setState(() {
      curusrIsInv=newvalue;
      if (curusrIsInv) {
        usrIsInv = 1;
        setUserActive(true);
      } else {
        usrIsInv = 0;
      }
    });
  }

  Container buildIsInvFormField() {
    return Container(
      height: defChkInpHeight,
      width: defChkInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defChkInpMaxHeight,
          maxWidth: defChkInpMaxWidth,
        ),
        child: CheckboxListTile(
          activeColor: Theme.of(context).colorScheme.secondary,
          title: Text(txtTitleIsInv),
          value: curusrIsInv,
          onChanged: (value) => setUserIsInv(value!),
          subtitle: !curusrIsInv
            ? Padding(
                padding: EdgeInsets.fromLTRB(12.0, 0, 0, 0), 
                child: Text(txtChkIsInv, style: TextStyle(color: Color(0xFFe53935), fontSize: getProportionateScreenWidth(12))))
            : null,
        ),
      ),
    );
  }

  setUserIsKitchen(bool newvalue) {
    setState(() {
      curusrIsKitchen=newvalue;
      if (curusrIsKitchen) {
        usrIsKitchen = 1;
        setUserActive(true);
      } else {
        usrIsKitchen = 0;
      }
    });
  }

  Container buildIsKitchenFormField() {
    return Container(
      height: defChkInpHeight,
      width: defChkInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defChkInpMaxHeight,
          maxWidth: defChkInpMaxWidth,
        ),
        child: CheckboxListTile(
          activeColor: Theme.of(context).colorScheme.secondary,
          title: Text(txtTitleIsKitchen),
          value: curusrIsKitchen,
          onChanged: (value) => setUserIsKitchen(value!),
          subtitle: !curusrIsKitchen
            ? Padding(
                padding: EdgeInsets.fromLTRB(12.0, 0, 0, 0), 
                child: Text(txtChkIsKitchen, style: TextStyle(color: Color(0xFFe53935), fontSize: getProportionateScreenWidth(12))))
            : null,
        ),
      ),
    );
  }

  setUserIsFrontst(bool newvalue) {
    setState(() {
      curusrIsFrontSt=newvalue;
      if (curusrIsFrontSt) {
        usrIsFrontSt = 1;
        setUserActive(true);
      } else {
        usrIsFrontSt = 0;
      }
    });
  }

  Container buildIsFrontstFormField() {
    return Container(
      height: defChkInpHeight,
      width: defChkInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defChkInpMaxHeight,
          maxWidth: defChkInpMaxWidth,
        ),
        child: CheckboxListTile(
          activeColor: Theme.of(context).colorScheme.secondary,
          title: Text(txtTitleIsFrontst),
          value: curusrIsFrontSt,
          onChanged: (value) => setUserIsFrontst(value!),
          subtitle: !curusrIsFrontSt
            ? Padding(
                padding: EdgeInsets.fromLTRB(12.0, 0, 0, 0), 
                child: Text(txtChkIsFrontst, style: TextStyle(color: Color(0xFFe53935), fontSize: getProportionateScreenWidth(12))))
            : null,
        ),
      ),
    );
  }

  newUserCode () {
    setState(() {
      usrNewCode = true;
    });
    storeUserSaveChanges();
  }

  chooseImageStaff() {
    setState(() {
      imgfile = _pickera.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      poststatus = message;
    });
  }

  doQryStoreUsers() async {
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
              if (admcurstrusr.isNotEmpty && allstrusrs.where((prodelem) => (prodelem.id == admcurstrusrid)).isNotEmpty) {
                refreshUser(admcurstrusrid);
              }
            }
          });
        }
    }).catchError((error) {
      setStatus(kStoreAPIErr);
    });
  }

  storeUserSaveChanges() {
    setStatus(txtuserSavingInfo);
    var imgfileName;
    var newimg;
    if (pickimg) {
      newimg = '1';
      imgfileName = tmpimgFile!.path.split('/').last;
    } else {
      newimg = '0';
      imgfileName='';
      base64StaffImage='';
    }
    var postdata = {
        "id": "$strusrId" ,
        "store_id": "$storeid",
        "store_code": "$storeCode",
        "usr_name": "$usrName",
        "usr_code": "$usrCode",
        "usr_passcode": "$usrPassCode",
        "imgfile": "$imgfileName",
        "staff_img64" : "$base64StaffImage",
        "newimg" : "$newimg",
        "newusrcode" : (usrNewCode)? '1' : '0',
        "phone" : "$usrStaffPhone",
        "name" : "$usrStaffName",
        "addr" : "$usrStaffAddr",
        "addr2" : "$usrStaffAddr2",
        "city" : "$usrStaffCity",
        "zip" : "$usrStaffZip",
        "state" : "$usrStaffState",
        "country" : "$usrStaffCountry",
        "active" : (usrActive > 0)? '1' : '0',
        "is_pos" : (usrIsPos > 0)? '1' : '0',
        "is_inv" : (usrIsInv > 0)? '1' : '0',
        "is_kitchen" : (usrIsKitchen > 0)? '1' : '0',
        "is_frontst" : (usrIsFrontSt > 0)? '1' : '0',
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    http.post(storeeditPosEndPoint, body: postdata, headers: posthdr ).then((result) {
        if (result.statusCode == 200) {
          var resary = jsonDecode(result.body);
          if (resary['status'] > 0) {
              setState(() {
                AtcStoreUser tmpstrusr = AtcStoreUser.fromJsonDet(resary['data']);
                if (allstrusrs.where((strelem) => (strelem.id == tmpstrusr.id)).isNotEmpty) {
                  syncStoreUsersList(tmpstrusr,allstrusrs.indexWhere((strusrelem) => (strusrelem.id == tmpstrusr.id)));
                } else {
                  allstrusrs.add(tmpstrusr);
                }
                if (admcurstrusr.isNotEmpty && admcurstrusr.first.id == tmpstrusr.id) {
                  syncCurStoreUsersList(tmpstrusr, 0);
                } else {
                  admcurstrusr=[];
                  admcurstrusr.add(tmpstrusr);
                }
                admcurstrusrid = admcurstrusr.first.id;
                usrNewCode = false;
                usrCode = (admcurstrusr.isNotEmpty)? admcurstrusr.first.usrcode : "";
                usrcodeCtler.text = usrCode;
                storeCode = (admcurstrusr.isNotEmpty)? admcurstrusr.first.storecode : "";
                storecodeCtler.text = storeCode;
              });
              setStatus(txtStatSaved);
              KeyboardUtil.hideKeyboard(context);
          } else if (resary['status'] == -1) {
             setStatus(kuserSaveErr);
          } else {
            setStatus(kuserSaveErr);
          }
        } else {
          throw Exception(kuserSaveErr);
        }
    }).catchError((error) {
      setStatus(kuserSaveErr);
    });
  }

  syncCurStoreUsersList(AtcStoreUser fromStoreUser, int toStoreUserIdx) {
    admcurstrusr[toStoreUserIdx].id=fromStoreUser.id;
    admcurstrusr[toStoreUserIdx].storeid=fromStoreUser.storeid;
    admcurstrusr[toStoreUserIdx].storecode=fromStoreUser.storecode;
    admcurstrusr[toStoreUserIdx].usrname=fromStoreUser.usrname;
    admcurstrusr[toStoreUserIdx].usrcode=fromStoreUser.usrcode;
    admcurstrusr[toStoreUserIdx].usrpasscode=fromStoreUser.usrpasscode;
    admcurstrusr[toStoreUserIdx].passcodebk=fromStoreUser.passcodebk;
    admcurstrusr[toStoreUserIdx].ispos=fromStoreUser.ispos;
    admcurstrusr[toStoreUserIdx].isinv=fromStoreUser.isinv;
    admcurstrusr[toStoreUserIdx].iskitchen=fromStoreUser.iskitchen;
    admcurstrusr[toStoreUserIdx].isfrontst=fromStoreUser.isfrontst;
    admcurstrusr[toStoreUserIdx].active=fromStoreUser.active;
    admcurstrusr[toStoreUserIdx].devip=fromStoreUser.devip;
    admcurstrusr[toStoreUserIdx].devtoken=fromStoreUser.devtoken;
    admcurstrusr[toStoreUserIdx].status=fromStoreUser.status;
    admcurstrusr[toStoreUserIdx].staffimg=fromStoreUser.staffimg;
    admcurstrusr[toStoreUserIdx].imgw=fromStoreUser.imgw;
    admcurstrusr[toStoreUserIdx].imgh=fromStoreUser.imgh;
    admcurstrusr[toStoreUserIdx].phone=fromStoreUser.phone;
    admcurstrusr[toStoreUserIdx].name=fromStoreUser.name;
    admcurstrusr[toStoreUserIdx].addr=fromStoreUser.addr;
    admcurstrusr[toStoreUserIdx].addr2=fromStoreUser.addr2;
    admcurstrusr[toStoreUserIdx].city=fromStoreUser.city;
    admcurstrusr[toStoreUserIdx].zip=fromStoreUser.zip;
    admcurstrusr[toStoreUserIdx].state=fromStoreUser.state;
    admcurstrusr[toStoreUserIdx].country=fromStoreUser.country;
    admcurstrusr[toStoreUserIdx].devinfo=fromStoreUser.devinfo;
    admcurstrusr[toStoreUserIdx].created=fromStoreUser.created;
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

  posqry() {
    var postdata = {
        "qrymode": 'by_id',
        "id": "$admcurstrusrid",
        "store_id": "$admcurstoreid",
        "mobapp" : mobAppVal
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    http.post(
        storeqryPosEndPoint, 
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

  Widget showStaffImage() {
    return FutureBuilder<XFile?>(
      future: imgfile,
      builder: (BuildContext context, AsyncSnapshot<XFile?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpimgFile = snapshot.data!;
          base64StaffImage = base64Encode(File(snapshot.data!.path).readAsBytesSync());
          pickimg=true;
          return Flexible(
            child: Image.file(File(snapshot.data!.path),fit: BoxFit.scaleDown, height: getProportionateScreenHeight(180),),
          );
        } else if (admcurstrusr.isNotEmpty && admcurstrusr.first.staffimg != '') {
          return Flexible(
            child: Image.network(imagehost+admcurstrusr.first.staffimg, fit: BoxFit.scaleDown, height: getProportionateScreenHeight(180),),
          );
        } else if (null != snapshot.error) {
          return Text(
            txtPickImgErr,
            textAlign: TextAlign.center,
          );
        } else {
          return Text(
            txtNoImgSel,
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  Container buildUserCodeFormField() {
    usrcodeCtler.value = new TextEditingController.fromValue(new TextEditingValue(text: (usrCode.isNotEmpty)? usrCode: '')).value;
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
          keyboardType: TextInputType.visiblePassword,
          onSaved: (newValue) => usrCode = newValue!,
          onChanged: (value) {
            usrCode = value;
            return null;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblUserCode,
            hintText: hintUserCode,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
          ),
          readOnly: true,
          controller: usrcodeCtler,
        ),
      ),
    );
  }

  Container buildStoreCodeFormField() {
    storecodeCtler.value = new TextEditingController.fromValue(new TextEditingValue(text: (storeCode.isNotEmpty)? storeCode: '')).value;
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
          keyboardType: TextInputType.visiblePassword,
          onSaved: (newValue) => storeCode = newValue!,
          onChanged: (value) {
            storeCode = value;
            return null;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblStoreCode,
            hintText: hintStoreCode,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
          ),
          readOnly: true,
          controller: storecodeCtler,
        ),
      ),
    );
  }

  saveUsrName(String newValue) {
    setState(() {
      usrName = newValue;
    });
  }

  printUserAccessCode() {
    final printttf = pw.Font.ttf(printfont!);
    doc = new pw.Document();
    var bcsvg = buildBarcode(Barcode.qrCode(),stringToBase64.encode(storeCode+'|||'+usrCode+'|||'+usrPassCodeBk));
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.roll80,
      build: (pw.Context pcontext) {
        return pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: 
              <pw.Widget>[
                  pw.Center(child: pw.Text('Store Staff Login', style: pw.TextStyle(font: printttf, fontSize: 14))),
                  pw.ClipRect(child: pw.Container(width: 150,height: 150,child: pw.SvgImage(svg: bcsvg))),
                  pw.Center(child: pw.Text(usrName, style: pw.TextStyle(font: printttf, fontSize: 14))),
                  pw.Center(child: pw.Text('UserCode:'+usrCode, style: pw.TextStyle(font: printttf, fontSize: 14))),
                  pw.Center(child: pw.Text('keep secure!', style: pw.TextStyle(font: printttf, fontSize: 14))),
                ]
            ),
          );
      }));
    Printing.layoutPdf(onLayout: (PdfPageFormat format) => doc.save());
  }

  buildBarcode(Barcode bc,String data, {double? width,double? height,double? fontHeight}) {
    return bc.toSvg(data,width: width ?? 150,height: height ?? 150,fontHeight: fontHeight);
  }
 
  Container buildUserCodeDraw() {
    return Container(
      height: defQrCodeMaxHeight,
      width: defQrCodeMaxWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defQrCodeMaxHeight,
          maxWidth: defQrCodeMaxWidth,
        ),
        child: BarcodeWidget(
          barcode:  Barcode.qrCode(),
          data: stringToBase64.encode(storeCode+'|||'+usrCode+'|||'+usrPassCodeBk),
          width: defQrCodeMaxHeight,
          height: defQrCodeMaxWidth,
        ),
      ),
    );
  }

  Container buildUserNameFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
          onSaved: (newValue) => saveUsrName(newValue!),
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kUserNameNullError);
              saveUsrName(value);
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrName = '';
              addError(error: kUserNameNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblUserName,
            hintText: hintUserName,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
          ),
          controller: usrnameCtler,
        ),
      ),
    );
  }

  savePassCode(String newValue) {
    setState(() {
      usrPassCode = newValue;
      usrPassCodeBk = newValue;
    });
  }

  Container buildPassCodeFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
          obscureText: true,
          onSaved: (newValue) => savePassCode(newValue!),
          onChanged: (value) {
            if (value.isNotEmpty) {
              savePassCode(value);
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrPassCode = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblPassCode,
            hintText: hintPassCode,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
          ),
          controller: passcodeCtler,
        ),
      ),
    );
  }

  saveStaffName(String newValue) {
    setState(() {
      usrStaffName = newValue;
    });
  }

  Container buildStaffNameFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
          onSaved: (newValue) => saveStaffName(newValue!),
          onChanged: (value) {
            if (value.isNotEmpty) {
              saveStaffName(value);
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffName = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblStaffName,
            hintText: hintStaffName,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
          ),
          controller: nameCtler,
        ),
      ),
    );
  }

  saveStaffPhone(String newValue) {
    setState(() {
      usrStaffPhone = newValue;
    });
  }

  Container buildStaffPhoneFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
          onSaved: (newValue) => saveStaffPhone(newValue!),
          onChanged: (value) {
            if (value.isNotEmpty) {
              saveStaffPhone(value);
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffPhone = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblStaffPhone,
            hintText: hintStaffPhone,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
          ),
          controller: phoneCtler,
        ),
      ),
    );
  }


  addressSaved(String newValue) {
    setState(() {
      usrStaffAddr = newValue;
    });
  }

  Container buildStaffAddrFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
          onSaved: (newValue) => addressSaved(newValue!),
          onChanged: (value) {
            if (value.isNotEmpty) {
              addressSaved(value);
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffAddr = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblStaffAddr,
            hintText: hintStaffAddr,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          controller: addrCtler,
        ),
      ),
    );
  }

  address2Saved(String newValue) {
    setState(() {
      usrStaffAddr2 = newValue;
    });
  }

  Container buildStaffAddress2FormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
          onSaved: (newValue) => address2Saved(newValue!),
          onChanged: (value) {
            if (value.isNotEmpty) {
              address2Saved(value);
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffAddr2 = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblStaffAddr2,
            hintText: hintStaffAddr2,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          controller: addr2Ctler,
        ), 
      ),
    );
  }

  staffCitySaved(String newValue) {
    setState(() {
      usrStaffCity = newValue;
    });
  }

  Container buildStaffCityFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
          onSaved: (newValue) => staffCitySaved(newValue!),
          onChanged: (value) {
            if (value.isNotEmpty) {
              staffCitySaved(value);
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffCity = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblStaffCity,
            hintText: hintStaffCity,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          controller: cityCtler,
        ), 
      ),
    );
  }

  staffZipSaved(String newValue) {
    setState(() {
      usrStaffCity = newValue;
    });
  }

  Container buildStaffZipFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
          onSaved: (newValue) => staffZipSaved(newValue!),
          onChanged: (value) {
            if (value.isNotEmpty) {
              staffZipSaved(value);
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffZip = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblStaffZip,
            hintText: hintStaffZip,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          controller: zipCtler,
        ), 
      ),
    );
  }

  staffStateSaved(String newValue) {
    setState(() {
      usrStaffCity = newValue;
    });
  }

  Container buildStaffStateFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
          onSaved: (newValue) => staffStateSaved(newValue!),
          onChanged: (value) {
            if (value.isNotEmpty) {
              staffStateSaved(value);
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffState = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblStaffState,
            hintText: hintStaffState,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          controller: stateCtler,
        ), 
      ),
    );
  }

  staffCountrySaved(String newValue) {
    setState(() {
      usrStaffCountry = newValue;
    });
  }

  Container buildStaffCountryFormField() {
    return Container(
      height: defTxtInpHeight,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtInpMaxHeight,
          maxWidth: defTxtInpMaxWidth,
        ),
        child: TextFormField(
          onSaved: (newValue) => staffCountrySaved(newValue!),
          onChanged: (value) {
            if (value.isNotEmpty) {
              staffCountrySaved(value);
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffCountry = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblStaffCountry,
            hintText: hintStaffCountry,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          controller: countryCtler,
        ), 
      ),
    );
  }

  storeUserListBody() {
    return SafeArea(
        child: SizedBox(
          width: getProportionateScreenWidth(defListFormMaxWidth),
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(defFormFieldEdges05)),
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(defFormFieldEdges05)),
                  Text(((admcurstore.isNotEmpty)? admcurstore.first.storename : "") + '\'s staffs', style: headingStyle, textAlign: TextAlign.center),
                  SizedBox(height: getProportionateScreenHeight(defFormFieldEdges05)),
                  buildUserSearchFormField(),
                  storeUserListView(),
                  SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                ],
              ),
            ),
          ),
        ),
      );
  }

  storeposSessListBody() {
    return Container(
      width: getProportionateScreenWidth(defListFormMaxWidth),
      height: getProportionateScreenHeight(posListScrlHeight),
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: getProportionateScreenWidth(defListFormMaxWidth),
        ),
        child: FutureBuilder<List<PosSess>>(
            future: _fetchPosSess(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<PosSess>? data = snapshot.data;
                return _storesPosSessView(data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return doingapialert;
            },
          ),
      ),
    );
  }

  Future<List<PosSess>> _fetchPosSess() async {
    var postdata = {
        "mobapp" : mobAppVal,
        "qrymode" : "sessbypos",
        "pos_id" : "$admcurstrusrid",
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    final storesPosListAPIUrl = storeqryPosEndPoint;
    final response = await http.post(storesPosListAPIUrl, body: postdata, headers: posthdr );
    if (response.statusCode == 200) {
      Map<String, dynamic> alljsonResponse = json.decode(response.body);
      List jsonResponse = alljsonResponse['data'];
      return jsonResponse.map((posess) => new PosSess.fromJson(posess)).toList();
    } else {
      throw Exception(kStoreAPIErr);
    }
  }

    ListView _storesPosSessView(data) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          String tmpstartcash = 'start cash: ' + posCcy.format(data[index].startcash) + ' ' + ((admcurstore.isNotEmpty)? admcurstore.first.currency : "");
          String tmpcurcash = 'cur cash: ' + posCcy.format(data[index].curcash) + ' ' + ((admcurstore.isNotEmpty)? admcurstore.first.currency : "");
          String tmpendcash = 'closed cash: ' + posCcy.format(data[index].endcash) + ' ' + ((admcurstore.isNotEmpty)? admcurstore.first.currency : "");
          String tmptotcurtkt = 'cur tickets: ' + data[index].totcurtkt.toString();
          String tmptotendtkt = 'end tickets: ' + data[index].totendtkt.toString();
          String tmptimestart = (null != data[index].timestart)? 'start:' + DateFormat.yMMMEd().add_jms().format(DateTime.tryParse(data[index].timestart) as DateTime) : 'start:';
          String tmpendtime = (null != data[index].endtime)? 'exit:' + DateFormat.yMMMEd().add_jms().format(DateTime.tryParse(data[index].endtime) as DateTime) : 'exit:';
          String tmpcurtime = (null != data[index].curtime)? 'saved:' + DateFormat.yMMMEd().add_jms().format(DateTime.tryParse(data[index].curtime) as DateTime) : 'saved:';
          String tmpstatus = (data[index].isworking > 0)? 'Working' : (data[index].isbreak > 0)? 'Breaking' : (data[index].isclose > 0)? 'Closed' : '';
          String tmptimestr = (data[index].isworking > 0)? tmptimestart + '\n' + tmpcurtime : tmptimestart + '\n' + tmpendtime ;
          String tmpcashstr = (data[index].isworking > 0)? tmpstartcash + '\n'+ tmpcurcash : tmpstartcash + '\n'+ tmpendcash ;
          String tmptktstr = (data[index].isworking > 0)? tmptotcurtkt : tmptotendtkt;
          return _posSesstile(data[index].id, tmptktstr, tmpcashstr , data[index].id.toString(), tmptimestr + '\n' + tmpstatus);
        },
      );
    }

    ListTile _posSesstile(int possessid, String title, String subtitle, String leadingtext,String tailingtext) => ListTile(
          title: Text(title,
              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20,color: (possessid == admcurstrusrsessid)? kPrimaryColor : kTextColor,)),
          subtitle: Text(subtitle),
          leading: Text(leadingtext),
          trailing: Text(tailingtext),
          onTap: () => refreshPosSess(possessid),
    );

    void refreshPosSess(int possessid) {
        setState(() {
          admcurstrusrsessid = possessid;
        });
      }

  storeUserListView() {
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

    ListView _storesUserListView(List<AtcStoreUser> data) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _usrtile(data[index].id, data[index].usrname, data[index].name + '\n'+ data[index].usrcode, data[index].staffimg, Icons.account_circle_rounded);
        },
      );
    }
  
    ListTile _usrtile(int storestrusrid, String title, String subtitle, String imgpath, IconData icon) => ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      leading: Icon(
        icon,
        color: admcurstrusrid == storestrusrid ? kPrimaryColor : inActiveIconColor,
        size: 48.0,
      ),
      trailing: Image.network(imagehost+imgpath, fit: BoxFit.cover, height: 60.0, width: 60.0),
      onTap: () => refreshUser(storestrusrid),
    );

  refreshUser(int storestrusrid) {
    setState(() {
      setStatus('');
      errors=[];
      admcurstrusrid = storestrusrid;
      admcurstrusr=allstrusrs.where((element) => (element.id == storestrusrid)).toList();
      liststrusrs = allstrusrs.where((element) => (element.name.toLowerCase().contains(admcurstrusrsearch) || 
                                                    element.usrname.toLowerCase().contains(admcurstrusrsearch) || 
                                                    element.phone.toLowerCase().contains(admcurstrusrsearch))).toList();
      storeid = (admcurstore.isNotEmpty)? admcurstore.first.id : 0;
      storeCode = (admcurstore.isNotEmpty)? admcurstore.first.storecode : "";
      strusrId = (admcurstrusr.isNotEmpty)? admcurstrusr.first.id : 0;
      usrName = (admcurstrusr.isNotEmpty)? admcurstrusr.first.usrname : "";
      usrCode = (admcurstrusr.isNotEmpty)? admcurstrusr.first.usrcode : "";
      usrPassCode = '';
      usrPassCodeBk = (admcurstrusr.isNotEmpty)? admcurstrusr.first.passcodebk : "";
      usrActive = (admcurstrusr.isNotEmpty)? admcurstrusr.first.active : 1;
      curusractive = (usrActive > 0);
      usrIsPos = (admcurstrusr.isNotEmpty)? admcurstrusr.first.ispos : 1;
      curusrIsPos = (usrIsPos > 0);
      usrIsInv = (admcurstrusr.isNotEmpty)? admcurstrusr.first.isinv : 1;
      curusrIsInv = (usrIsInv > 0);
      usrIsKitchen = (admcurstrusr.isNotEmpty)? admcurstrusr.first.iskitchen : 1;
      curusrIsKitchen = (usrIsKitchen > 0);
      usrIsFrontSt = (admcurstrusr.isNotEmpty)? admcurstrusr.first.isfrontst : 1;
      curusrIsFrontSt = (usrIsFrontSt > 0);
      usrStatus = (admcurstrusr.isNotEmpty)? admcurstrusr.first.status : "";
      usrStaffPhone = (admcurstrusr.isNotEmpty)? admcurstrusr.first.phone : "";
      usrStaffName = (admcurstrusr.isNotEmpty)? admcurstrusr.first.name : "";
      usrStaffAddr = (admcurstrusr.isNotEmpty)? admcurstrusr.first.addr : "";
      usrStaffAddr2 = (admcurstrusr.isNotEmpty)? admcurstrusr.first.addr2 : "";
      usrStaffCity = (admcurstrusr.isNotEmpty)? admcurstrusr.first.city : "";
      usrStaffZip = (admcurstrusr.isNotEmpty)? admcurstrusr.first.zip : "";
      usrStaffState = (admcurstrusr.isNotEmpty)? admcurstrusr.first.state : "";
      usrStaffCountry = (admcurstrusr.isNotEmpty)? admcurstrusr.first.country : "";
      usrNewCode = false;
      usrnameCtler.text = usrName;
      usrcodeCtler.text = usrCode;
      statusCtler.text = usrStatus;
      phoneCtler.text = usrStaffPhone;
      nameCtler.text = usrStaffName;
      addrCtler.text = usrStaffAddr;
      addr2Ctler.text = usrStaffAddr2;
      cityCtler.text = usrStaffCity;
      stateCtler.text = usrStaffState;
      countryCtler.text = usrStaffCountry;
      storecodeCtler.text = storeCode;
      passcodeCtler.text = usrPassCode;
      zipCtler.text = usrStaffZip;
    });
  }

  storeuserqry() {
    var postdata = {
        "qrymode": 'by_id',
        "id": "$admcurstrusrid",
        "store_id" : "$admcurstoreid",
        "mobapp" : mobAppVal
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    http.post(
        storeqryPosEndPoint, 
        body: postdata,
        headers: posthdr
      ).then((result) {
          if (result.statusCode == 200) {
            var resary = jsonDecode(result.body);
            setState(() {
              var tmpstrusr=AtcStoreUser.fromJsonDet(resary['data']);
              admcurstrusr = [];
              admcurstrusr.add(tmpstrusr);
              admcurstrusrid=tmpstrusr.id;
              storeid = (admcurstore.isNotEmpty)? admcurstore.first.id : 0;
              storeCode = (admcurstore.isNotEmpty)? admcurstore.first.storecode : "";
              strusrId = (admcurstrusr.isNotEmpty)? admcurstrusr.first.id : 0;
              usrName = (admcurstrusr.isNotEmpty)? admcurstrusr.first.usrname : "";
              usrCode = (admcurstrusr.isNotEmpty)? admcurstrusr.first.usrcode : "";
              usrPassCode = '';
              usrPassCodeBk = (admcurstrusr.isNotEmpty)? admcurstrusr.first.passcodebk : "";
              usrActive = (admcurstrusr.isNotEmpty)? admcurstrusr.first.active : 1;
              curusractive = (usrActive > 0);
              usrIsPos = (admcurstrusr.isNotEmpty)? admcurstrusr.first.ispos : 1;
              curusrIsPos = (usrIsPos > 0);
              usrIsInv = (admcurstrusr.isNotEmpty)? admcurstrusr.first.isinv : 1;
              curusrIsInv = (usrIsInv > 0);
              usrIsKitchen = (admcurstrusr.isNotEmpty)? admcurstrusr.first.iskitchen : 1;
              curusrIsKitchen = (usrIsKitchen > 0);
              usrIsFrontSt = (admcurstrusr.isNotEmpty)? admcurstrusr.first.isfrontst : 1;
              curusrIsFrontSt = (usrIsFrontSt > 0);
              usrStatus = (admcurstrusr.isNotEmpty)? admcurstrusr.first.status : "";
              usrStaffPhone = (admcurstrusr.isNotEmpty)? admcurstrusr.first.phone : "";
              usrStaffName = (admcurstrusr.isNotEmpty)? admcurstrusr.first.name : "";
              usrStaffAddr = (admcurstrusr.isNotEmpty)? admcurstrusr.first.addr : "";
              usrStaffAddr2 = (admcurstrusr.isNotEmpty)? admcurstrusr.first.addr2 : "";
              usrStaffCity = (admcurstrusr.isNotEmpty)? admcurstrusr.first.city : "";
              usrStaffZip = (admcurstrusr.isNotEmpty)? admcurstrusr.first.zip : "";
              usrStaffState = (admcurstrusr.isNotEmpty)? admcurstrusr.first.state : "";
              usrStaffCountry = (admcurstrusr.isNotEmpty)? admcurstrusr.first.country : "";
              usrNewCode = false;
              usrnameCtler.text = usrName;
              usrcodeCtler.text = usrCode;
              statusCtler.text = usrStatus;
              phoneCtler.text = usrStaffPhone;
              nameCtler.text = usrStaffName;
              addrCtler.text = usrStaffAddr;
              addr2Ctler.text = usrStaffAddr2;
              cityCtler.text = usrStaffCity;
              stateCtler.text = usrStaffState;
              countryCtler.text = usrStaffCountry;
              storecodeCtler.text = storeCode;
              passcodeCtler.text = usrPassCode;
              zipCtler.text = usrStaffZip;
            });
          } else {
            throw Exception(kstoreqryErr);
          }
      }).catchError((error) {
        print(error);
      });
  }

  setSearch(String newValue) {
    setState(() {
      admcurstrusrsearch = newValue.toLowerCase();
      liststrusrs = allstrusrs.where((element) => (element.name.toLowerCase().contains(admcurstrusrsearch) || 
                                                    element.usrname.toLowerCase().contains(admcurstrusrsearch) || 
                                                    element.phone.toLowerCase().contains(admcurstrusrsearch))).toList();
    });
  }
    
  Container buildUserSearchFormField() {
    return Container(
      height: defSrearchInpHeight,
      width: defSrearchInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defSrearchInpMaxHeight,
          maxWidth: defSrearchInpMaxWidth,
        ),
        child: TextFormField(
          onSaved: (newValue) => setSearch(newValue!),
          onChanged: (value) {
            setSearch(value);
            return null;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblSearch,
            hintText: hintSearch,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Search Icon.svg"),
          ),
          initialValue: admcurstrusrsearch,
        ),
      ),
    );
  }

}



