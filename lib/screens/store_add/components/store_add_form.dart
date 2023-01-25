import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shopadmin_app/components/custom_surfix_icon.dart';
import 'package:shopadmin_app/components/default_button.dart';
import 'package:shopadmin_app/components/form_error.dart';
import 'package:shopadmin_app/screens/store_edit/store_edit_screen.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/size_config.dart';

class StoreAddForm extends StatefulWidget {
  @override
  _StoreAddFormState createState() => _StoreAddFormState();
}

class _StoreAddFormState extends State<StoreAddForm> {
  final _formKeyStoreAdd = GlobalKey<FormState>();
  // int storeid = admcurstore['id'];
  String storeName = '';
  String storeAddress = '';
  String storeAddress2 = '';
  String storeEmail = '';
  String storePhoneNumber = '';
  String storeFaxNumber = '';
  Future<XFile?>? logofile;
  String poststatus = '';
  String? base64LogoImage;
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
          key: _formKeyStoreAdd,
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
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              Text(poststatus, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              DefaultButton(
                text: lblSaveStore,
                press: () {
                  if (_formKeyStoreAdd.currentState!.validate()) {
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
    if (null == tmplogoFile) {
      setStatus(regerrNullLogo);
      return;
    }
    var logofileName = tmplogoFile!.path.split('/').last;
    var postdata = {
        // "id": "${admcurstore['id']}" ,
        "logo_text": storeName,
        "store_name": storeName,
        "store_addr": storeAddress,
        "store_addr2": storeAddress2,
        "store_email": storeEmail,
        "store_phone": storePhoneNumber,
        "store_fax": storeFaxNumber,
        // "newlogo" : "$newlogo",
        "logofile": logofileName,
        "logo_img64" : base64LogoImage,
      };
    var posthdr = {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $logintoken'
        };
    http.post(storeaddEndPoint, body: postdata, headers: posthdr ).then((result) {
        if (result.statusCode == 200) {
          var resary = jsonDecode(result.body);
          if (resary['status'] > 0) {
              setState(() {
                var tmpstore = AtcStore.fromJsonDet(resary['data']);
                admcurstore = []; 
                admcurstore.add(tmpstore);
                admcurstoreid = admcurstore.first.id;
                allappstores.add(tmpstore);
              });
              setStatus(txtStatSaved);
              Navigator.pushNamed(context, StoreEditScreen.routeName);
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
        } else if (null != snapshot.error) {
          return Text(
            lblPickStoreLogo,
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
            onSaved: (newValue) => storeName = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kStorenameNullError);
                storeName = value;
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
            initialValue: storeName,
          ),
      ),
    );
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
            onSaved: (newValue) => storeAddress = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kStoreaddressNullError);
                storeAddress = value;
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
            initialValue: storeAddress,
          ),
      ),
    );
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
            onSaved: (newValue) => storeAddress2 = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                storeAddress2 = value;
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
            initialValue: storeAddress2,
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
            initialValue: storePhoneNumber,
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
            initialValue: storeFaxNumber,
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
            initialValue: storeEmail,
          ),
      ),
    );
  }


}
