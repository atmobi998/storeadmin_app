// import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopadmin_app/components/custom_surfix_icon.dart';
import 'package:shopadmin_app/components/form_error.dart';
import 'package:shopadmin_app/helper/keyboard.dart';
import 'package:shopadmin_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:shopadmin_app/screens/store_list/store_list_screen.dart';
import 'package:shopadmin_app/components/default_button.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/size_config.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';

class SignForm extends StatefulWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  _SignFormState createState() => _SignFormState();
}


class _SignFormState extends State<SignForm> with AfterLayoutMixin<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String emailphone = '';
  String password = '';
  String loginVerify = '888888';
  bool remember = false;
  String poststatus = ' ';
  final List<String> errors = [];
  String storeadmrem='';
  String storeadmlogin='';
  String storeadmpass='';
  String authphonenbr = '';
  String fbaseuserid = '';
  String fbaseusercreds = '';

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      getLocalSavedLogin();
    });
  }

  Future<void> getLocalSavedLogin() async {
    try {
      var storeadmrem = await FlutterKeychain.get(key: "storeadmrem");
      var storeadmlogin = await FlutterKeychain.get(key: "storeadmlogin");
      var storeadmpass = await FlutterKeychain.get(key: "storeadmpass");
      if (null == storeadmlogin) {
        await FlutterKeychain.put(key: "storeadmlogin", value: emailphone);
      }
      if (null == storeadmpass) {
        await FlutterKeychain.put(key: "storeadmpass", value: password);
      }
      if (null == storeadmrem) {
        await FlutterKeychain.put(key: "storeadmrem", value: remember.toString());
      }
      if (!mounted) return;

      setState(() {
        if (null != storeadmrem && storeadmrem == 'true') {
          remember = true;
          if (null != storeadmlogin) {
            emailphoneTxtCtrl.text = storeadmlogin;
          }
          if (null != storeadmpass) {
            passwordTxtCtrl.text = storeadmpass;
          }
        }
      });
      
    } on Exception catch (ae) {
      print("Exception: " + ae.toString());
    }
  }

  Future<void> saveLocalLogin() async {
    try {
      if (remember) {
        await FlutterKeychain.put(key: "storeadmlogin", value: emailphone);
        await FlutterKeychain.put(key: "storeadmpass", value: password);
        await FlutterKeychain.put(key: "storeadmrem", value: remember.toString());
      } else {
        await FlutterKeychain.put(key: "storeadmlogin", value: '');
        await FlutterKeychain.put(key: "storeadmpass", value: '');
        await FlutterKeychain.put(key: "storeadmrem", value: remember.toString());
      }
      if (!mounted) return;
    } on Exception catch (ae) {
      print("Exception: " + ae.toString());
    }
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
              buildEmailOrPhoneFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              buildPasswordFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              needFBaseVerify ? buildVerifyFireBase() : const SizedBox.shrink(),
              Text(poststatus, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0)),
              Container(
                alignment: Alignment.center,
                width: defTxtInpMaxWidth,
                child: Row(
                  children: [
                    Checkbox(
                      value: remember,
                      activeColor: kPrimaryColor,
                      onChanged: (value) {
                        setState(() {
                          remember = value!;
                        });
                      },
                    ),
                    Text(lblRememberMe),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, ForgotPasswordScreen.routeName),
                      child: Text(
                        lblForgotPassword,
                        style: const TextStyle(decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              ),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              Container(
                alignment: Alignment.center,
                width: defTxtInpMaxWidth,
                child: Row(
                  children: [
                    IconButton(
                      icon: Image.asset('assets/images/storeadminqr.png'),
                      iconSize: getProportionateScreenHeight(50),
                      onPressed: () {
                        scanLoginBarcode();
                      },
                    ),
                    Text(lblScanPass, style: const TextStyle(decoration: TextDecoration.underline)),
                    const Spacer(),
                    DefButton150(
                      text: lblContinue,
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          loginemail=emailphone;
                          loginpass=password;
                          doLogin();
                          KeyboardUtil.hideKeyboard(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scanLoginBarcode() async {
    String barcodeScanRes;
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", txtBcodeCancel, true, ScanMode.DEFAULT);
      } on PlatformException {
        barcodeScanRes = txtBcodeScanErr;
      }
      if (!mounted) return;
      setBcodePassvalue(barcodeScanRes);
  }

  setBcodePassvalue(String barcode) {
      setState(() {
        String bcodepass = stringToBase64.decode(barcode);
        var passary = bcodepass.split('|||');
        if (passary.length == 3) {
          emailphoneTxtCtrl.text = passary[1];
          passwordTxtCtrl.text = passary[2];
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            loginemail = emailphone;
            loginpass = password;
            doLogin();
            KeyboardUtil.hideKeyboard(context);
          }
        }
      });
  }

  doLogin() {
    var postdata = {
        "username": emailphone,
        "password": password,
        "mobapp" : mobAppVal,
        "token" : logintoken,
        "pn_verify" : loginVerify,
        "fbaseuserid" : fbaseuserid,
        "fbaseusercreds" : fbaseusercreds,
      };
    var posthdr = {
        'Accept': 'application/json',
        };
    showLoginDialog(context);
    http.post(
        loginEndPoint, 
        body: postdata,
        headers: posthdr
      ).then((result) {
          hideAlertDialog(context);
          if (result.statusCode == 200) {
            var resary = jsonDecode(result.body);
            if (resary['data']['token'] != '') {
              setState(() {
                logintoken=resary['data']['token'];
                reguser = [];
                reguser.add(AtcProfile.fromJsonDet(resary['data']['reguser']));
              });
              if (installedSMS && reguser.first.pnverify < 1) {
                setState(() {
                  if (needVerify) {
                    addError(error: kwrongVerifyCode);
                  }
                  removeError(error: kwrongUserPass);
                  poststatus = txtSentDigits+reguser.first.phonecode+reguser.first.phone;
                  authphonenbr = '+'+reguser.first.phonecode+reguser.first.phone;
                  needVerify=true;
                  needFBaseVerify = true;
                });
              } else {
                removeError(error: kwrongVerifyCode);
                removeError(error: kwrongUserPass);
                saveLocalLogin();
                Navigator.pushNamed(context, StoreListScreen.routeName);
              }            
            } else {
              addError(error: kwrongUserPass);
            }
          } else {
            throw Exception(kcannotLogin);
          }
      }).catchError((error) {
        // print('error: '+error.toString());
      });
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
          controller: passwordTxtCtrl,
          scrollPadding: EdgeInsets.all(defTxtInpEdge),
          obscureText: true,
          onSaved: (newValue) => password = newValue!,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kPassNullError);
            }
            password = value;
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kPassNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblPasswordText,
            hintText: hintPasswordText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
          ),
        ),
      ),
    );
  }

  Container buildEmailOrPhoneFormField() {
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
          controller: emailphoneTxtCtrl,
          keyboardType: TextInputType.phone,
          onSaved: (newValue) => emailphone = newValue!,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kPhoneNumberNullError);
              emailphone = value;
            }
            return;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kPhoneNumberNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblLoginPhoneText,
            hintText: hintLoginPhoneText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
          ),
        ),
      ),
    );
  }

  Container buildVerifyFireBase() {
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
              child: FirebasePhoneAuthHandler(
                phoneNumber: authphonenbr,
                builder: (context, controller) {
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
                        controller: verifypassTxtCtrl,
                        keyboardType: TextInputType.number,
                        onSaved: (newValue) => {

                        },
                        onChanged: (value) async {
                          if (value.isNotEmpty) {
                            removeError(error: kNbrVeriNullError);
                            if (value.length == 6) {
                              final res = await controller.verifyOTP(otp: value);
                              if (!res) {
                                setState(() {
                                  poststatus = "Please enter the correct OTP sent to $authphonenbr";
                                });
                              } else {
                                setState(() {
                                  poststatus = "$authphonenbr verified!";
                                  needVerify=false;
                                  needFBaseVerify = false;
                                });
                                // doLogin();
                              }
                            }
                          }
                          return;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            addError(error: kNbrVeriNullError);
                            return "";
                          }
                          return null;
                        },
                        decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
                          labelText: lblPhoneVerifyText,
                          hintText: hintPhoneVerifyText,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
                        ),
                      ),
                    ),
                  );
                },
          onLoginSuccess: (userCredential, autoVerified) {
              setState(() {
                needVerify=false;
                needFBaseVerify = false;
                fbaseuserid = userCredential.user!.uid;
                fbaseusercreds = userCredential.toString();
              });
              doLogin();
          },
          onLoginFailed: (authException) {
            print("An error occurred: ${authException.message}");
          },
        ),
      ),
    );
  }

}
