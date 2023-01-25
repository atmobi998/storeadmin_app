import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:shopadmin_app/components/custom_surfix_icon.dart';
import 'package:shopadmin_app/components/default_button.dart';
import 'package:shopadmin_app/components/form_error.dart';
import 'package:shopadmin_app/screens/store_loc/store_loc_screen.dart';
import 'package:shopadmin_app/helper/keyboard.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/size_config.dart';

class StoreEditForm extends StatefulWidget {

  @override
  _StoreEditFormState createState() => _StoreEditFormState();
  
}

class _StoreEditFormState extends State<StoreEditForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  int storeid = (admcurstore.isNotEmpty)? admcurstore.first.id : 0; 
  String storeCode = (admcurstore.isNotEmpty)? admcurstore.first.storecode : ""; 
  String storeName = (admcurstore.isNotEmpty)? admcurstore.first.storename : ""; 
  String storeAddress = (admcurstore.isNotEmpty)? admcurstore.first.storeaddr : ""; 
  String storeAddress2 = (admcurstore.isNotEmpty)? admcurstore.first.storeaddr2 : ""; 
  String storeEmail = (admcurstore.isNotEmpty)? admcurstore.first.storeemail : ""; 
  String storePhoneNumber = (admcurstore.isNotEmpty)? admcurstore.first.storephone : ""; 
  String storeFaxNumber = (admcurstore.isNotEmpty)? admcurstore.first.storefax : ""; 
  String currency = (admcurstore.isNotEmpty)? admcurstore.first.currency : ""; 
  bool storeNewCode = false;

  double storeLat = (admcurstore.isNotEmpty)? admcurstore.first.storelat : 0; 
  double storeLng = (admcurstore.isNotEmpty)? admcurstore.first.storelng : 0; 

  Future<XFile?>? logofile;
  String poststatus = '';
  String? base64LogoImage='';
  XFile? tmplogoFile;
  final List<String> errors = [];
  bool picklogo=false;
  final ImagePicker _pickera = ImagePicker();

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

  void logError(error) {
    print(error);
  }

  void logMessage(String message) {
    print(message);
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
              buildStorenameFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildStoreaddressFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildStoreaddress2FormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildStorePhoneNumberFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildStoreFaxNumberFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildstoreEmailFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildCurrencyFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              GreyButton(
                text: lblPickStoreLogo,
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
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges02)),
              GreyButton(
                text: lblChangeLoc,
                press: () {
                    getstorePosition();
                },
              ),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              buildLocTextFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              buildStoreCodeFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges05)),
              GreyButton(
                text: lblResetStoreCode,
                press: () {
                    newStoreCode();
                },
              ),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              Text(poststatus, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              DefaultButton(
                text: lblSaveStore,
                press: () {
                  if (_formKey.currentState!.validate()) {
                    regstorename=storeName;
                    regstoreaddr=storeAddress;
                    regstorephone=storePhoneNumber;
                    regstorefax=storeFaxNumber;
                    storeSaveChanges();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  newStoreCode () {
    setState(() {
      storeNewCode = true;
    });
    storeSaveChanges();
  }

  chooseImageLogo() {
    setState(() {
      logofile = _pickera.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      poststatus = message;
    });
  }

  storeSaveChanges() {
    setStatus(txtStoreSavingInfo);
    String? logofileName='';
    String? newlogo='';
    if (picklogo) {
      newlogo = '1';
      logofileName = tmplogoFile!.path.split('/').last;
    } else {
      newlogo = '0';
      logofileName='';
      base64LogoImage='';
    }
    var postdata = {
        "id": (admcurstore.isNotEmpty)? "${admcurstore.first.id}" : "0", 
        "logo_text": (storeName.isNotEmpty) ? storeName : '', 
        "store_name": (storeName.isNotEmpty) ? storeName : '', 
        "currency": (currency.isNotEmpty) ? currency : '', 
        "store_addr": (storeAddress.isNotEmpty) ? storeAddress : '', 
        "store_addr2": (storeAddress2.isNotEmpty) ? storeAddress2 : '', 
        "store_email": (storeEmail.isNotEmpty) ? storeEmail : '', 
        "store_phone": (storePhoneNumber.isNotEmpty) ? storePhoneNumber : '', 
        "store_fax": (storeFaxNumber.isNotEmpty) ? storeFaxNumber : '', 
        "store_lat" : "${newlatlng.latitude.toString()}",
        "store_lng" : "${newlatlng.longitude.toString()}",
        "newlogo" : "$newlogo",
        "logofile": (logofileName.isNotEmpty) ? logofileName : '', 
        "logo_img64" : (base64LogoImage!.isNotEmpty) ? base64LogoImage : '', 
        "newcode" : (storeNewCode)? '1' : '0',
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    http.post(storeeditEndPoint, body: postdata, headers: posthdr ).then((result) {
        if (result.statusCode == 200) {
          var resary = jsonDecode(result.body);
          if (resary['status'] > 0) {
            setState(() {
              var tmpstore = AtcStore.fromJsonDet(resary['data']);
              admcurstore = []; 
              admcurstore.add(tmpstore);
              admcurstoreid = admcurstore.first.id;
              storeLat = (admcurstore.isNotEmpty)? admcurstore.first.storelat : 0; 
              storeLng = (admcurstore.isNotEmpty)? admcurstore.first.storelng : 0; 
              curlatlng = LatLng(storeLat,storeLng);
              storelatlng = curlatlng;
              if (storeLat == 0.0 && storeLng == 0.0) {
                curlatlng = curusrpos;
                storelatlng = curusrpos;
                storecamerapos = CameraPosition(target: curusrpos ,zoom: 14,);
              }      
            });
            getLocationAddr();
            setState(() {
              storeNewCode = false;
              storeCode = (admcurstore.isNotEmpty)? admcurstore.first.storecode : ""; 
              storecodeCtler.text = storeCode;
            });
            setStatus(txtStatSaved);
            KeyboardUtil.hideKeyboard(context);
          } else if (resary['status'] == -1) {
             setStatus(kstoreSaveErr);
          } else {
            setStatus(kstoreSaveErr);
          }
        } else {
          throw Exception(kstoreSaveErr);
        }
    }).catchError((error) {
      setStatus(kstoreSaveErr);
    });
  }

  getstorePosition() {
    setState(() {
      storeLat = (admcurstore.isNotEmpty)? admcurstore.first.storelat : 0; 
      storeLng = (admcurstore.isNotEmpty)? admcurstore.first.storelng : 0; 
      curlatlng = LatLng(storeLat,storeLng);
    });
    Navigator.pushNamed(context, StoreLocationScreen.routeName);
  }
  
  Widget showLogoImage() {
    setState(() {
      curlatlng = LatLng(storeLat,storeLng);
    });
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
        } else if (admcurstore.isNotEmpty && admcurstore.first.logoimg != '') {
          return Flexible(
            child: Image.network(imagehost+admcurstore.first.logoimg, fit: BoxFit.scaleDown, height: getProportionateScreenHeight(180),),
          );
        } else if (null != snapshot.error) {
          return Text(
            txtStoreImgErr,
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

  getLocationAddr() {
    txtLocTextCtlr..text = storeName + '\n' + storeAddress + '\n' + storeAddress2 ;
  }

  var txtLocTextCtlr = TextEditingController();
  Container buildLocTextFormField() {
    getLocationAddr();
    return Container(
      height: defTxtBoxHeight,
      width: defTxtBoxWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: defTxtBoxMaxHeight,
          maxWidth: defTxtBoxMaxWidth,
        ),
        child: TextField(
          readOnly: true,
          onTap: getLocationAddr,
          controller: txtLocTextCtlr,
          maxLines: defTxtBoxLines03,
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblMapAddr,
            hintText: hintMapAddr,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
        ),
      ),
    );
  }

  var storecodeCtler = new TextEditingController();
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

  saveStoreName(String newValue) {
    setState(() {
      storeName = newValue;
    });
    getLocationAddr();
  }

  Container buildCurrencyFormField() {
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
          onSaved: (newValue) => currency = newValue!,
          onChanged: (value) {
            currency = value;
            return null;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblCurrency,
            hintText: hintCurrency,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/dollar-sign.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.currency : "",
        ),
      ),
    );
  }

  Container buildStorenameFormField() {
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
          onSaved: (newValue) => saveStoreName(newValue!),
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kStorenameNullError);
              saveStoreName(value);
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kStorenameNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblStoreName,
            hintText: hintStoreName,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.storename : "",
        ),
      ),
    );
  }

  addressSaved(String newValue) {
    setState(() {
      storeAddress = newValue;
    });
    getLocationAddr();
  }

  Container buildStoreaddressFormField() {
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
              removeError(error: kStoreaddressNullError);
              addressSaved(value);
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kStoreaddressNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblStoreAddr,
            hintText: hintStoreAddr,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.storeaddr : "",
        ),
      ),
    );
  }

  address2Saved(String newValue) {
    setState(() {
      storeAddress2 = newValue;
    });
    getLocationAddr();
  }

  Container buildStoreaddress2FormField() {
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
              storeAddress2 = '';
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblStoreAddr2,
            hintText: hintStoreAddr2,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.storeaddr2 : "",
        ), 
      ),
    );
  }

  Container buildStorePhoneNumberFormField() {
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
          keyboardType: TextInputType.phone,
          onSaved: (newValue) => storePhoneNumber = newValue!,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kstorePhNbrNullError);
              storePhoneNumber = value;
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kstorePhNbrNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblStorePhone,
            hintText: hintStorePhone,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.storephone : "",
        ),
      ),
    );
  }

  Container buildStoreFaxNumberFormField() {
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
          keyboardType: TextInputType.phone,
          onSaved: (newValue) => storeFaxNumber = newValue!,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kstoreFaxNbrNullError);
              storeFaxNumber = value;
            }
            return null;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kstoreFaxNbrNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: TextStyle(fontSize: 0), helperStyle: TextStyle(fontSize: 0), errorStyle: TextStyle(fontSize: 0),
            labelText: lblStoreFax,
            hintText: hintStoreFax,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.storefax : "",
        ),
      ),
    );
  }

  Container buildstoreEmailFormField() {
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
          onSaved: (newValue) => storeEmail = newValue!,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kEmailNullError);
            } else if (emailValidatorRegExp.hasMatch(value)) {
              removeError(error: kInvalidEmailError);
            }
            storeEmail = value;
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
            labelText: lblStoreEmail,
            hintText: hintStoreEmai,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.storeemail : "",
        ),
      ),
    );
  }


}
