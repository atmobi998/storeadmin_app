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
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/screens/store_list/store_list_screen.dart';
import 'package:shopadmin_app/size_config.dart';
import 'package:barcode_widget/barcode_widget.dart';

class ProfileEditForm extends StatefulWidget {
  @override
  _ProfileEditFormState createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> with AfterLayoutMixin<ProfileEditForm> {
  final _formKey = GlobalKey<FormState>();
  String email= (reguser.isNotEmpty)? reguser.first.email : '';
  String firstName= (reguser.isNotEmpty)? reguser.first.firstname : '';
  String lastName= (reguser.isNotEmpty)? reguser.first.lastname : '';
  String phoneNumber= (reguser.isNotEmpty)? reguser.first.phone : '';
  String phoneCode= (reguser.isNotEmpty)? '+'+reguser.first.phonecode + '-' : '';
  String address= (reguser.isNotEmpty)? reguser.first.address : '';
  String countryName= (reguser.isNotEmpty)? reguser.first.countryname : '';
  String verifypasswordDB= (reguser.isNotEmpty)? reguser.first.verifypassword : '';
  var countryTxtCtler = TextEditingController();
  var phoneTxtCtler = TextEditingController();

  String password='';
  String verifypassword='';
  Future<XFile?>? logofile;
  Future<XFile?>? selffile;
  String poststatus = '';
  String? base64LogoImage;
  XFile? tmplogoFile;
  String? base64SelfImage;
  XFile? tmpselfFile;
  bool picklogo=false;
  bool pickself=false;
  final ImagePicker _pickera = ImagePicker();
  // final ImagePicker _pickerb = ImagePicker();

  bool remember = true;
  final List<String> errors = [];

  pw.Document doc = pw.Document();
  ByteData? printfont;

  loadPrintFont() async {
    printfont = await rootBundle.load("assets/fonts/open-sans/OpenSans-Regular.ttf");
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {

    });
    loadPrintFont();
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
              buildAdminCodeDraw(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              GreyButton(
                text: txtPrintAdminAccessCode,
                press: () {
                    printAdminAccessCode();
                },
              ),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              buildFirstNameFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildLastNameFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildPhoneNumberFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildCountryFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildAddressFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildEmailFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildPasswordFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildConformPassFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              GreyButton(
                text: lblPickLogo,
                press: () {
                    chooseImageLogo();
                },
              ),
              SizedBox(
                height: getProportionateScreenHeight(200),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                          showLogoImage(),
                          SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                        ],
                      ),
              ),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              GreyButton(
                text: lblPickSelf,
                press: () {
                    chooseImageSelf();
                },
              ),
              SizedBox(
                height: getProportionateScreenHeight(200),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                          showSelfImage(),
                          SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                        ],
                      ),
              ),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              Text(poststatus, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              DefaultButton(
                text: txtSaveAndStores,
                press: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    doProfileEdit();
                    
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
 
  chooseImageLogo() async {
    setState(() {
      logofile = _pickera.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  chooseImageSelf() async {
    setState(() {
      selffile = _pickera.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      poststatus = message;
    });
  }

  doProfileEdit() {
    setStatus(txtSavingAcct);
    var logofileName;
    var newlogo;
    if (picklogo) {
      newlogo = '1';
      logofileName = tmplogoFile!.path.split('/').last;
    } else {
      newlogo = '0';
      logofileName='';
      base64LogoImage='';
    }
    var selffileName;
    var newself;
    if (pickself) {
      newself = '1';
      selffileName = tmpselfFile!.path.split('/').last;
    } else {
      newself = '0';
      selffileName='';
      base64SelfImage='';
    }
    var postdata = {
        "logo_img64": base64LogoImage,
        "logofile": logofileName,
        "self_img64": base64SelfImage,
        "selffile": selffileName,
        "logo_text": firstName + ' ' + lastName,
        "email" : email,
        "username" : phoneNumber ,
        "password" : password,
        "verify_password" : verifypassword,
        "firstname" : firstName,
        "lastname" : lastName,
        "name" : firstName + ' ' + lastName,
        "phone" : phoneNumber,
        "address" : address,
        "newlogo" : "$newlogo",
        "newself" : "$newself",
        "mobapp" : 'storeadmin_app',
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    http.post(
      profileeditEndPoint, 
      body: postdata,
      headers: posthdr
    ).then((result) {
        if (result.statusCode == 200) {
          var resary = jsonDecode(result.body);
          if (resary['reg'] == -1) {
            setStatus("${resary['regerr']}");
          } else {
            setState(() {
              regtoken=resary['token'];
              logintoken=resary['token'];
              AtcProfile tmpuser = AtcProfile.fromJsonDet(resary['reguser']);
              if (reguser.isNotEmpty) {
                syncRegUser(tmpuser, 0);
              } else {
                reguser = [];
                reguser.add(tmpuser);
              }
              email= (reguser.isNotEmpty)? reguser.first.email : '';
              firstName= (reguser.isNotEmpty)? reguser.first.firstname : '';
              lastName= (reguser.isNotEmpty)? reguser.first.lastname : '';
              phoneNumber= (reguser.isNotEmpty)? reguser.first.phone : '';
              phoneCode= (reguser.isNotEmpty)? '+'+reguser.first.phonecode + '-' : '';
              address= (reguser.isNotEmpty)? reguser.first.address : '';
              countryName= (reguser.isNotEmpty)? reguser.first.countryname : '';
              verifypasswordDB= (reguser.isNotEmpty)? reguser.first.verifypassword : '';
            });
            setStatus(txtAccountSaved);
            Navigator.pushNamed(context, StoreListScreen.routeName);
          }
        } else {
          throw Exception(regerrMessage);
        }
    }).catchError((error) {
      setStatus(regerrMessage);
    });
  }

  syncRegUser(AtcProfile fromRegUser, int toRegUserIdx) {
      reguser[toRegUserIdx].id = fromRegUser.id;
      reguser[toRegUserIdx].roleid = fromRegUser.roleid;
      reguser[toRegUserIdx].username = fromRegUser.username;
      reguser[toRegUserIdx].password = fromRegUser.password;
      reguser[toRegUserIdx].verifypassword = fromRegUser.verifypassword;
      reguser[toRegUserIdx].name = fromRegUser.name;
      reguser[toRegUserIdx].firstname = fromRegUser.firstname;
      reguser[toRegUserIdx].lastname = fromRegUser.lastname;
      reguser[toRegUserIdx].email = fromRegUser.email;
      reguser[toRegUserIdx].website = fromRegUser.website;
      reguser[toRegUserIdx].address = fromRegUser.address;
      reguser[toRegUserIdx].address2 = fromRegUser.address2;
      reguser[toRegUserIdx].phone = fromRegUser.phone;
      reguser[toRegUserIdx].phonecode = fromRegUser.phonecode;
      reguser[toRegUserIdx].pnverify = fromRegUser.pnverify;
      reguser[toRegUserIdx].codesent = fromRegUser.codesent;
      reguser[toRegUserIdx].sentvalue = fromRegUser.sentvalue;
      reguser[toRegUserIdx].fax = fromRegUser.fax;
      reguser[toRegUserIdx].haslogo = fromRegUser.haslogo;
      reguser[toRegUserIdx].logotext = fromRegUser.logotext;
      reguser[toRegUserIdx].logoimg = fromRegUser.logoimg;
      reguser[toRegUserIdx].logow = fromRegUser.logow;
      reguser[toRegUserIdx].logoh = fromRegUser.logoh;
      reguser[toRegUserIdx].selfimg = fromRegUser.selfimg;
      reguser[toRegUserIdx].selfw = fromRegUser.selfw;
      reguser[toRegUserIdx].selfh = fromRegUser.selfh;
      reguser[toRegUserIdx].imghost = fromRegUser.imghost;
      reguser[toRegUserIdx].currency = fromRegUser.currency;
      reguser[toRegUserIdx].zipcode = fromRegUser.zipcode;
      reguser[toRegUserIdx].countryid = fromRegUser.countryid;
      reguser[toRegUserIdx].countryname = fromRegUser.countryname;
      reguser[toRegUserIdx].stateid = fromRegUser.stateid;
      reguser[toRegUserIdx].statename = fromRegUser.statename;
      reguser[toRegUserIdx].cityname = fromRegUser.cityname;
      reguser[toRegUserIdx].localname = fromRegUser.localname;
      reguser[toRegUserIdx].profilepath = fromRegUser.profilepath;
      reguser[toRegUserIdx].activationkey = fromRegUser.activationkey;
      reguser[toRegUserIdx].status = fromRegUser.status;
      reguser[toRegUserIdx].banned = fromRegUser.banned;
      reguser[toRegUserIdx].note = fromRegUser.note;
      reguser[toRegUserIdx].timezone = fromRegUser.timezone;
      reguser[toRegUserIdx].fbaseid = fromRegUser.fbaseid;
      reguser[toRegUserIdx].fbasecreds = fromRegUser.fbasecreds;
      reguser[toRegUserIdx].twitid = fromRegUser.twitid;
      reguser[toRegUserIdx].twitcreds = fromRegUser.twitcreds;
      reguser[toRegUserIdx].fbid = fromRegUser.fbid;
      reguser[toRegUserIdx].fbcreds = fromRegUser.fbcreds;
      reguser[toRegUserIdx].awsid = fromRegUser.awsid;
      reguser[toRegUserIdx].awscreds = fromRegUser.awscreds;
      reguser[toRegUserIdx].googleid = fromRegUser.googleid;
      reguser[toRegUserIdx].googlecreds = fromRegUser.googlecreds;
      reguser[toRegUserIdx].notifications = fromRegUser.notifications;
      reguser[toRegUserIdx].balance = fromRegUser.balance;
      reguser[toRegUserIdx].data = fromRegUser.data;
      reguser[toRegUserIdx].created = fromRegUser.created;
  }

  printAdminAccessCode() {
    final printttf = pw.Font.ttf(printfont!);
    doc = new pw.Document();
    var bcsvg = buildBarcode(Barcode.qrCode(),stringToBase64.encode(DateTime.now().toIso8601String()+'|||'+phoneCode+phoneNumber+'|||'+verifypasswordDB));
    doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.roll80,
          build: (pw.Context pcontext) {
            return pw.Center(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: 
                  <pw.Widget>[
                      pw.Center(child: pw.Text('Store Admin Login', style: pw.TextStyle(font: printttf, fontSize: 12))),
                      pw.ClipRect(child: pw.Container(width: 150,height: 150,child: pw.SvgImage(svg: bcsvg))),
                      pw.Center(child: pw.Text(email, style: pw.TextStyle(font: printttf, fontSize: 14))),
                      pw.Center(child: pw.Text('Login:'+phoneCode+phoneNumber, style: pw.TextStyle(font: printttf, fontSize: 14))),
                      pw.Center(child: pw.Text('keep secure!', style: pw.TextStyle(font: printttf, fontSize: 12))),
                    ]
                ),
              );
          }));
    Printing.layoutPdf(onLayout: (PdfPageFormat format) => doc.save());
  }

  buildBarcode(Barcode bc,String data, {double? width,double? height,double? fontHeight}) {
    return bc.toSvg(data,width: width ?? 150,height: height ?? 150,fontHeight: fontHeight);
  }

  Container buildAdminCodeDraw() {
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
          data: stringToBase64.encode(DateTime.now().toIso8601String()+'|||'+phoneCode+phoneNumber+'|||'+verifypasswordDB),
          width: defQrCodeMaxHeight,
          height: defQrCodeMaxWidth,
        ),
      ),
    );
  }

  Widget showLogoImage() {
    return FutureBuilder<XFile?>(
      future: logofile,
      builder: (BuildContext context, AsyncSnapshot<XFile?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && null != snapshot.data) {
          tmplogoFile = snapshot.data!;
          base64LogoImage = base64Encode(File(snapshot.data!.path).readAsBytesSync());
          picklogo=true;
          return Flexible(
            child: Image.file(File(snapshot.data!.path),fit: BoxFit.scaleDown, height: getProportionateScreenHeight(180),),
          );
        } else if (reguser.isNotEmpty && reguser.first.logoimg != '') {
          return Flexible(
            child: Image.network(imagehost+reguser.first.logoimg, fit: BoxFit.scaleDown, height: getProportionateScreenHeight(180),),
          );
        } else if (null != snapshot.error) {
          return Text(
            txtPickLogoErr,
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

  Widget showSelfImage() {
    return FutureBuilder<XFile?>(
      future: selffile,
      builder: (BuildContext context, AsyncSnapshot<XFile?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && null != snapshot.data) {
          tmpselfFile = snapshot.data!;
          base64SelfImage = base64Encode(File(snapshot.data!.path).readAsBytesSync());
          pickself=true;
          return Flexible(
            child: Image.file(File(snapshot.data!.path),fit: BoxFit.scaleDown, height: getProportionateScreenHeight(180),),
          );
        } else if (reguser.isNotEmpty && reguser.first.selfimg != '') {
          return Flexible(
            child: Image.network(imagehost+reguser.first.selfimg, fit: BoxFit.scaleDown, height: getProportionateScreenHeight(180),),
          );
        } else if (null != snapshot.error) {
          return Text(
            txtPickSelfErr,
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

  Container buildConformPassFormField() {
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
            onSaved: (newValue) => verifypassword = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty && password == verifypassword) {
                removeError(error: kMatchPassError);
              }
              verifypassword = value;
            },
            validator: (value) {
              if ((password.isNotEmpty && password != value)) {
                addError(error: kMatchPassError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
              labelText: lblRePassword,
              hintText: hintPasswordNC,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
            initialValue: verifypassword,
          ),
      ),
    );
  }

  Container buildPasswordFormField() {
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
            onSaved: (newValue) => password = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty && value.length >= 8) {
                removeError(error: kShortPassError);
              }
              password = value;
            },
            validator: (value) {
              if (value!.isNotEmpty && value.length < 8) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
              labelText: lblPassword,
              hintText: hintPasswordNC,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
            initialValue: password,
          ),
      ),
    );
  }

  Container buildEmailFormField() {
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
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
              email = value;
              return null;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
              labelText: lblEmail,
              hintText: hintEmail,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
            initialValue: email,
          ),
      ),
    );
  }

  Container buildAddressFormField() {
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
            onSaved: (newValue) => address = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kAddressNullError);
              }
              address = value;
              return null;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kAddressNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
              labelText: lblAddr,
              hintText: hintAddr,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
            ),
            initialValue: address,
          ),
      ),
    );
  }

  Container buildCountryFormField() {
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
            readOnly: true,
            keyboardType: TextInputType.name,
            onSaved: (newValue) => countryName = newValue!,
            onChanged: (value) {
              countryName = value;
              return null;
            },
            validator: (value) {
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
              labelText: lblCountry,
              hintText: hintCountry,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/flag.svg"),
            ),
            initialValue: countryName,
          ),
      ),
    );
  }

  Container buildPhoneNumberFormField() {
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
            readOnly: true,
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => phoneNumber = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPhoneNumberNullError);
              }
              phoneNumber = value;
              return null;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPhoneNumberNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
              labelText: lblPhoneNumber,
              hintText: hintPhoneNumber,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
              prefixText: (phoneCode.isEmpty)? '' : phoneCode ,
            ),
            initialValue: phoneNumber,
          ),
      ),
    );
  }

  Container buildLastNameFormField() {
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
          onSaved: (newValue) => lastName = newValue!,
          onChanged: (value) {
            if (value.isNotEmpty) {
              lastName = value;
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblLastName,
            hintText: hintLastName,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
          ),
          initialValue: lastName,
        )
      ),
    );
  }

  Container buildFirstNameFormField() {
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
            onSaved: (newValue) => firstName = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kNamelNullError);
              }
              firstName = value;
              return null;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
              labelText: lblFirstName,
              hintText: hintFirstName,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
            initialValue: firstName,
          ),
      ),
    );
  }


}
