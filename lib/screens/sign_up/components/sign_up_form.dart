import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:shopadmin_app/components/custom_surfix_icon.dart';
import 'package:shopadmin_app/components/default_button.dart';
import 'package:shopadmin_app/components/form_error.dart';
import 'package:shopadmin_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/size_config.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email='';
  String? password='';
  String? verifypassword='';
  String? firstName='';
  String? lastName='';
  String? phoneNumber='';
  String? address='';
  Future<XFile?>? logofile;
  Future<XFile?>? selffile;
  String poststatus = '';
  String? base64LogoImage='';
  XFile? tmplogoFile;
  String? base64SelfImage='';
  XFile? tmpselfFile;
  Country? pickedCountry;
  var countryTxtCtler = TextEditingController();
  var phoneTxtCtler = TextEditingController();
  String? countryName='';
  String? countryCode='';
  String? countryPhoneCode='';
  final ImagePicker _pickera = ImagePicker();
  final ImagePicker _pickerb = ImagePicker();

  bool remember = true;
  final List<String> errors = [];

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
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
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
                          Text(poststatus, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
                          SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                        ],
                      ),
              ),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              DefaultButton(
                text: lblContinue,
                press: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    regemail=email!;
                    regpassword=password!;
                    regverifypassword=verifypassword!;
                    regfirstName=firstName!;
                    reglastName=lastName!;
                    regphoneNumber=phoneNumber!;
                    regaddress=address!;
                    regcountryName=countryName!;
                    regcountryCode=countryCode!;
                    regcountryPhoneCode=countryPhoneCode!;
                    doRegister();
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

  chooseImageLogo() {
    setState(() {
      logofile = _pickera.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  chooseImageSelf() {
    setState(() {
      selffile = _pickerb.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      poststatus = message;
    });
  }

  doRegister() {
    setStatus(txtSavingAcct);
    // ignore: unnecessary_null_comparison
    if (null == tmplogoFile) {
      setStatus(regerrNullLogo);
      return;
    }
    String logofileName = tmplogoFile!.path.split('/').last;
    String selffileName = tmplogoFile!.path.split('/').last;
    var postdata = {
        "logo_img64": base64LogoImage,
        "logofile": logofileName,
        "self_img64": base64SelfImage,
        "selffile": selffileName,
        "logo_text": regfirstName + ' ' + reglastName,
        "email" : regemail,
        "username" : regcountryPhoneCode+regphoneNumber ,
        "password" : regpassword,
        "verify_password" : regverifypassword,
        "firstname" : regfirstName,
        "lastname" : reglastName,
        "name" : regfirstName + ' ' + reglastName,
        "phone" : regphoneNumber,
        "phone_code" : regcountryPhoneCode,
        "country_id" : regcountryCode,
        "country_name" : regcountryName,
        "address" : regaddress,
        "storename" : regstorename,
        "storeaddr" : regstoreaddr,
        "storephone" : regstorephone,
        "storefax" : regstorefax,
        "mobapp" : 'storeadmin_app',
      };
    var posthdr = {
        'Accept': 'application/json'
        };
    http.post(
      registerEndPoint, 
      body: postdata,
      headers: posthdr
    ).then((result) {
        if (result.statusCode == 200) {
          var resary = jsonDecode(result.body);
          if (resary['reg'] == -1) {
            setStatus("${resary['regerr']}");
          } else {
            regtoken=resary['token'];
            reguser=resary['reguser'];
            setStatus("Account added: ${resary['reguser']['username']}");
            Navigator.pushNamed(context, CompleteProfileScreen.routeName);
          }
        } else {
          throw Exception(regerrMessage);
        }
    }).catchError((error) {
      setStatus(regerrMessage);
    });
  }

  Widget showLogoImage() {
    return FutureBuilder<XFile?>(
      future: logofile,
      builder: (BuildContext context, AsyncSnapshot<XFile?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && null != snapshot.data) {
          tmplogoFile = snapshot.data!;
          base64LogoImage = base64Encode(File(snapshot.data!.path).readAsBytesSync());
          return Flexible(
            child: Image.file(
              File(snapshot.data!.path),
              fit: BoxFit.scaleDown,
            ),
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
          return Flexible(
            child: Image.file(
              File(snapshot.data!.path),
              fit: BoxFit.scaleDown,
            ),
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
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.isNotEmpty && password == verifypassword) {
                removeError(error: kMatchPassError);
              }
              verifypassword = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if ((password != value)) {
                addError(error: kMatchPassError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblRePassword,
              hintText: hintRePassword,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
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
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              password = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if (value.length < 8) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblPassword,
              hintText: hintPassword,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
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
              return;
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
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblEmail,
              hintText: hintEmail,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
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
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kAddressNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblAddr,
              hintText: hintAddr,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
            ),
          ),
      ),
    );
  }

  countryPickerForPhone() {
    // ignore: unnecessary_null_comparison
    if (null == pickedCountry) {
      showCountryPicker(
        context: context,
        showPhoneCode: true, 
        onSelect: (Country country) {
            setState(() {
              pickedCountry = country;
              countryName = country.displayName;
              countryCode = country.countryCode;
              countryPhoneCode = country.phoneCode;
              countryTxtCtler.text = countryName!;
            });
        },
      );
    }
  }

  countryPickerForCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true, 
      onSelect: (Country country) {
          setState(() {
            pickedCountry = country;
            countryName = country.displayName;
            countryCode = country.countryCode;
            countryPhoneCode = country.phoneCode;
            countryTxtCtler.text = countryName!;
          });
      },
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
            controller: countryTxtCtler,
            keyboardType: TextInputType.name,
            onSaved: (newValue) => countryName = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kcountryCodeNullError);
              }
              countryName = value;
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kcountryCodeNullError);
                return "";
              }
              return null;
            },
            onTap: countryPickerForCountry,
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblCountry,
              hintText: hintCountry,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/flag.svg"),
            ),
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
            controller: phoneTxtCtler,
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => phoneNumber = newValue!,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPhoneNumberNullError);
              }
              phoneNumber = value;
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPhoneNumberNullError);
                return "";
              }
              return null;
            },
            onTap: countryPickerForPhone,
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblPhoneNumber,
              hintText: hintPhoneNumber,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
              // ignore: unnecessary_null_comparison
              prefixText: (null == pickedCountry)? '' : '+' + pickedCountry!.phoneCode + '-',
            ),
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
              return;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblLastName,
              hintText: hintLastName,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
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
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
              labelText: lblFirstName,
              hintText: hintFirstName,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
      ),
    );
  }



}
