import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; 
import 'package:pdf/pdf.dart';
// import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:shopadmin_app/components/custom_surfix_icon.dart';
import 'package:shopadmin_app/components/default_button.dart';
import 'package:shopadmin_app/components/form_error.dart';
import 'package:shopadmin_app/helper/keyboard.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/size_config.dart';
import 'package:barcode_widget/barcode_widget.dart';

class StoreUserEditForm extends StatefulWidget {
  const StoreUserEditForm({Key? key}) : super(key: key);


  @override
  _StoreUserEditFormState createState() => _StoreUserEditFormState();
  
}

class _StoreUserEditFormState extends State<StoreUserEditForm> with AfterLayoutMixin<StoreUserEditForm> {

  final _formKey = GlobalKey<FormState>();


  int storeid = (admcurstore.isNotEmpty)? admcurstore.first.id : 0;
  String storeCode = (admcurstore.isNotEmpty)? admcurstore.first.storecode : "";
  int strusrId = (admcurstrusr.isNotEmpty)? admcurstrusr.first.id : 0;
  String usrName = (admcurstrusr.isNotEmpty)? admcurstrusr.first.usrname : "";
  String usrCode = (admcurstrusr.isNotEmpty)? admcurstrusr.first.usrcode : "";
  String usrPassCode = '';
  String usrPassCodeBk = (admcurstrusr.isNotEmpty)? admcurstrusr.first.passcodebk : "";
  int usrActive = (admcurstrusr.isNotEmpty)? admcurstrusr.first.active : 1;
  int usrIsPos = (admcurstrusr.isNotEmpty)? admcurstrusr.first.ispos: 1;
  int usrIsInv = (admcurstrusr.isNotEmpty)? admcurstrusr.first.isinv : 1;
  int usrIsKitchen = (admcurstrusr.isNotEmpty)? admcurstrusr.first.iskitchen : 1;
  int usrIsFrontSt = (admcurstrusr.isNotEmpty)? admcurstrusr.first.isfrontst : 1;
  String usrStatus = (admcurstrusr.isNotEmpty)? admcurstrusr.first.status : "";
  String usrStaffPhone = (admcurstrusr.isNotEmpty)? admcurstrusr.first.phone : "";
  String usrStaffName = (admcurstrusr.isNotEmpty)? admcurstrusr.first.name : "";
  String usrStaffAddr = (admcurstrusr.isNotEmpty)? admcurstrusr.first.addr : "";
  String usrStaffAddr2 = (admcurstrusr.isNotEmpty)? admcurstrusr.first.addr2 : "";
  String usrStaffCity = (admcurstrusr.isNotEmpty)? admcurstrusr.first.city : "";
  String usrStaffZip = (admcurstrusr.isNotEmpty)? admcurstrusr.first.zip : "";
  String usrStaffState = (admcurstrusr.isNotEmpty)? admcurstrusr.first.state : "";
  String usrStaffCountry = (admcurstrusr.isNotEmpty)? admcurstrusr.first.country : "";
  bool usrNewCode = false;

  Future<XFile?>? imgfile;
  String poststatus = '';
  String? base64StaffImage='';
  XFile? tmpimgFile;
  final List<String> errors = [];
  bool pickimg=false;
  final ImagePicker _pickera = ImagePicker();
  pw.Document doc = pw.Document();
  ByteData? printfont;
  var usrcodeCtler = TextEditingController();
  var storecodeCtler = TextEditingController();

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

  loadPrintFont() async {
    printfont = await rootBundle.load("assets/fonts/open-sans/OpenSans-Regular.ttf");
  }

  @override
  void afterFirstLayout(BuildContext context) {
    loadPrintFont();
  }

  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Container(
      width: defInpFormWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: defInpFormMaxWidth,
        ),
        child: Form(
          key: _formKey,
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
                    newUsrCode();
                },
              ),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              Text(poststatus, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              DefaultButton(
                text: lblSaveUser,
                press: () {
                  if (_formKey.currentState!.validate()) {
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
                padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0), 
                child: Text(txtChkActive, style: TextStyle(color: const Color(0xFFe53935), fontSize: getProportionateScreenWidth(12))))
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
                padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0), 
                child: Text(txtChkIsPos, style: TextStyle(color: const Color(0xFFe53935), fontSize: getProportionateScreenWidth(12))))
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
                padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0), 
                child: Text(txtChkIsInv, style: TextStyle(color: const Color(0xFFe53935), fontSize: getProportionateScreenWidth(12))))
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
                padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0), 
                child: Text(txtChkIsKitchen, style: TextStyle(color: const Color(0xFFe53935), fontSize: getProportionateScreenWidth(12))))
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
                padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0), 
                child: Text(txtChkIsFrontst, style: TextStyle(color: const Color(0xFFe53935), fontSize: getProportionateScreenWidth(12))))
            : null,
        ),
      ),
    );
  }

  newUsrCode () {
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

  storeUserSaveChanges() {
    setStatus(txtuserSavingInfo);
    String imgfileName;
    String newimg;
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
        "store_code": storeCode,
        "usr_name": usrName,
        "usr_code": usrCode,
        "usr_passcode": usrPassCode,
        "imgfile": imgfileName,
        "staff_img64" : "$base64StaffImage",
        "newimg" : newimg,
        "newusrcode" : (usrNewCode)? '1' : '0',
        "phone" : usrStaffPhone,
        "name" : usrStaffName,
        "addr" : usrStaffAddr,
        "addr2" : usrStaffAddr2,
        "city" : usrStaffCity,
        "zip" : usrStaffZip,
        "state" : usrStaffState,
        "country" : usrStaffCountry,
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
      // 
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

  Widget showStaffImage() {
    return FutureBuilder<XFile?>(
      future: imgfile,
      builder: (BuildContext context, AsyncSnapshot<XFile?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && null != snapshot.data) {
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
    usrcodeCtler.value = TextEditingController.fromValue(TextEditingValue(text: (usrCode.isNotEmpty)? usrCode: '')).value;
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
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblUserCode,
            hintText: hintUserCode,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
          ),
          readOnly: true,
          controller: usrcodeCtler,
        ),
      ),
    );
  }

  Container buildStoreCodeFormField() {
    storecodeCtler.value = TextEditingController.fromValue(TextEditingValue(text: (storeCode.isNotEmpty)? storeCode: '')).value;
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
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblStoreCode,
            hintText: hintStoreCode,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
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
    doc = pw.Document();
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
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrName = '';
              addError(error: kUserNameNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblUserName,
            hintText: hintUserName,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
          ),
          initialValue: usrName,
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
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrPassCode = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblPassCode,
            hintText: hintPassCode,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
          ),
          initialValue: usrPassCode,
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
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffName = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblStaffName,
            hintText: hintStaffName,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
          ),
          initialValue: usrStaffName,
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
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffPhone = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblStaffPhone,
            hintText: hintStaffPhone,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
          ),
          initialValue: usrStaffPhone,
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
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffAddr = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblStaffAddr,
            hintText: hintStaffAddr,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: usrStaffAddr,
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
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffAddr2 = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblStaffAddr2,
            hintText: hintStaffAddr2,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: usrStaffAddr2,
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
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffCity = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblStaffCity,
            hintText: hintStaffCity,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: usrStaffCity,
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
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffZip = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblStaffZip,
            hintText: hintStaffZip,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: usrStaffZip,
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
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffState = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblStaffState,
            hintText: hintStaffState,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: usrStaffState,
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
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              usrStaffCountry = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblStaffCountry,
            hintText: hintStaffCountry,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: usrStaffCountry,
        ), 
      ),
    );
  }

  
}
