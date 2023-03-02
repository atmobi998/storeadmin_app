import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopadmin_app/components/custom_surfix_icon.dart';
import 'package:shopadmin_app/components/default_button.dart';
import 'package:shopadmin_app/components/form_error.dart';
import 'package:shopadmin_app/components/no_account_text.dart';
import 'package:shopadmin_app/screens/sign_in/sign_in_screen.dart';
import 'package:shopadmin_app/size_config.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              Text(
                txtForgotPass,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                txtForgotPhoneNbr,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              const ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({Key? key}) : super(key: key);

  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}


class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String phonenbr='';
  bool validphonenbr=false;
  bool validcode=false;
  bool sentreset=false;
  String resetcode='';
  String forgotsess='';
  String password='';
  int resetstep =1;

  @override
  Widget build(BuildContext context) {
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
              Container(
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
                    onSaved: (newValue) => setPhoneNbr(newValue),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          errors.remove(kPhoneNumberNullError);
                        });
                        setPhoneNbr(value);
                      }
                      return;
                    },
                    validator: (value) {
                      if (value!.isEmpty && !errors.contains(kPhoneNumberNullError)) {
                        setState(() {
                          errors.add(kPhoneNumberNullError);
                        });
                      } 
                      return null;
                    },
                    decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
                      labelText: lblPhoneNumber,
                      hintText: hintLoginPhoneText,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
                    ),
                  ),
                ),
              ),
              (phonenbr.isNotEmpty && resetstep >= 2)? Container(
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
                    onSaved: (newValue) => setResetCode(newValue),
                    onChanged: (value) {
                      if (value.isNotEmpty && errors.contains(hintPhoneVerifyErr)) {
                        setState(() {
                          errors.remove(hintPhoneVerifyErr);
                        });
                      }
                      setResetCode(value);
                      return;
                    },
                    validator: (value) {
                      if (value!.isEmpty && !errors.contains(hintPhoneVerifyErr)) {
                        setState(() {
                          errors.add(hintPhoneVerifyErr);
                        });
                      } 
                      return null;
                    },
                    decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
                      labelText: lblPhoneVerifyText,
                      hintText: hintPhoneVerifyText,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                    ),
                  ),
                ),
              ) : Container(),
              (phonenbr.isNotEmpty && resetstep == 3 && validphonenbr && validcode)? Container(
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
                    onSaved: (newValue) => setPassword(newValue),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          errors.remove(kPassNullError);
                        });
                      } else if (value.length >= 8) {
                        setState(() {
                          errors.remove(kShortPassError);
                        });
                      }
                      setPassword(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          errors.add(kPassNullError);
                        });
                        return "";
                      } else if (value.length < 8) {
                        setState(() {
                          errors.add(kShortPassError);
                        });
                        return "";
                      }
                      return null;
                    },
                    decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
                      labelText: lblNewPassword,
                      hintText: hintNewPassword,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                    ),
                  ),
                ),
              ) : Container(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges30)),
              DefaultButton(
                text: "Continue",
                press: () {
                  if (_formKey.currentState!.validate()) {
                    if (phonenbr.isNotEmpty && resetstep == 1) {
                      forgotqrya();
                    }
                    if (phonenbr.isNotEmpty && resetstep == 2) {
                      forgotqryb();
                    }
                    if (phonenbr.isNotEmpty && validphonenbr && validcode && resetstep == 3) {
                      forgotqryc();
                    }
                  }
                },
              ),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges30)),
              const NoAccountText(),
            ],
          ),
        ),
      ),
    );
  }

  setPhoneNbr(newval) {
    setState(() {
      phonenbr = newval;
    });
  }

  setResetCode(newval) {
    setState(() {
      resetcode = newval;
    });
  }

  setPassword(newval) {
    setState(() {
      password = newval;
    });
  }

    forgotqrya() {
      var postdata = {
          "step": "$resetstep",
          "phonenbr": phonenbr,
          "mobapp" : mobAppVal,
        };
      var posthdr = {
          'Accept': 'application/json',
          };
      http.post(
          forgotqryEndPoint, 
          body: postdata,
          headers: posthdr
        ).then((result) {
            if (result.statusCode == 200) {
              var resary = jsonDecode(result.body);
              setState(() {
                forgotsess=resary['data'];
                resetstep = 2;
              });
            } else {
              throw Exception(kforgotQryErr);
            }
        }).catchError((error) {
          // 
        });
    }

    forgotqryb() {
      var postdata = {
          "step": "$resetstep",
          "phonenbr": phonenbr,
          "token": forgotsess,
          "resetcode": resetcode,
          "mobapp" : mobAppVal,
        };
      var posthdr = {
          'Accept': 'application/json',
          };
      http.post(
          forgotqryEndPoint, 
          body: postdata,
          headers: posthdr
        ).then((result) {
            if (result.statusCode == 200) {
              var resary = jsonDecode(result.body);
              setState(() {
                if (resary['data'] == 'Verified') {
                  validphonenbr=true;
                  validcode=true;
                  resetstep = 3;
                  errors.remove(txtwrongCode);
                } else {
                  errors.add(txtwrongCode);
                }
              });
            } else {
              throw Exception(kforgotQryErr);
            }
        }).catchError((error) {
          print(error);
        });
    }

    forgotqryc() {
      var postdata = {
          "step": "$resetstep",
          "phonenbr": phonenbr,
          "token": forgotsess,
          "resetcode": resetcode,
          "password": password,
          "mobapp" : mobAppVal,
        };
      var posthdr = {
          'Accept': 'application/json',
          };
      // print(postdata);
      http.post(
          forgotqryEndPoint, 
          body: postdata,
          headers: posthdr
        ).then((result) {
            if (result.statusCode == 200) {
              var resary = jsonDecode(result.body);
              // print(resary);
              setState(() {
                if (resary['data'] == 'Changed') {
                  Navigator.pushNamed(context, SignInScreen.routeName);
                }
              });
            } else {
              throw Exception(kforgotQryErr);
            }
        }).catchError((error) {
          print(error);
        });
    }

}
