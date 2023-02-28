// import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:country_picker/country_picker.dart';
import 'package:shopadmin_app/components/custom_surfix_icon.dart';
import 'package:shopadmin_app/components/default_button.dart';
import 'package:shopadmin_app/components/form_error.dart';
import 'package:shopadmin_app/helper/keyboard.dart';
import 'package:shopadmin_app/app_globals.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/size_config.dart';
import 'package:shopadmin_app/curcountries.dart';
import 'package:shopadmin_app/countries.dart';

class StorePaymentEditForm extends StatefulWidget {
  const StorePaymentEditForm({Key? key}) : super(key: key);

  @override
  _StorePaymentEditFormState createState() => _StorePaymentEditFormState();
}

class _StorePaymentEditFormState extends State<StorePaymentEditForm> with AfterLayoutMixin<StorePaymentEditForm> {
  final _formKey = GlobalKey<FormState>();
  String billingphone = (admcurstore.isNotEmpty)? admcurstore.first.billingphone : "";
  String billingname = (admcurstore.isNotEmpty)? admcurstore.first.billingname : "";
  String billingaddr = (admcurstore.isNotEmpty)? admcurstore.first.billingaddr : "";
  String billingaddr2 = (admcurstore.isNotEmpty)? admcurstore.first.billingaddr2 : "";
  String billingcity = (admcurstore.isNotEmpty)? admcurstore.first.billingcity : "";
  String billingzip = (admcurstore.isNotEmpty)? admcurstore.first.billingzip : "";
  String billingstate = (admcurstore.isNotEmpty)? admcurstore.first.billingstate : "";
  String billingcountry = (admcurstore.isNotEmpty)? admcurstore.first.billingcountry : "";
  String shippingphone = (admcurstore.isNotEmpty)? admcurstore.first.shippingphone : "";
  String shippingname = (admcurstore.isNotEmpty)? admcurstore.first.shippingname : "";
  String shippingaddr = (admcurstore.isNotEmpty)? admcurstore.first.shippingaddr : "";
  String shippingaddr2 = (admcurstore.isNotEmpty)? admcurstore.first.shippingaddr2 : "";
  String shippingcity = (admcurstore.isNotEmpty)? admcurstore.first.shippingcity : "";
  String shippingzip = (admcurstore.isNotEmpty)? admcurstore.first.shippingzip : "";
  String shippingstate = (admcurstore.isNotEmpty)? admcurstore.first.shippingstate : "";
  String shippingcountry = (admcurstore.isNotEmpty)? admcurstore.first.shippingcountry : "";
  String paymentmethod = (admcurstore.isNotEmpty)? admcurstore.first.paymentmethod : "";
  String cardowner = (admcurstore.isNotEmpty)? admcurstore.first.cardowner : "";
  String cardnumber = (admcurstore.isNotEmpty)? admcurstore.first.cardnumber : "";
  String cardcode = (admcurstore.isNotEmpty)? admcurstore.first.cardcode : "";
  String cardyear = (admcurstore.isNotEmpty)? admcurstore.first.cardyear : "";
  String cardmonth = (admcurstore.isNotEmpty)? admcurstore.first.cardmonth : "";
  String authorization = (admcurstore.isNotEmpty)? admcurstore.first.authorization : "";
  String currency = (admcurstore.isNotEmpty)? admcurstore.first.currency : "";
  String bcntrycode = (admcurstore.isNotEmpty)? admcurstore.first.bcntrycode : "";
  String scntrycode = (admcurstore.isNotEmpty)? admcurstore.first.scntrycode : "";

  Country? pickedCountry;
  CcyCountry? pickedccyCountry;
  var billcntryTxtCtler = TextEditingController();
  var shipcntryTxtCtler = TextEditingController();
  var ccyTxtCtler = TextEditingController();
  var billphoneTxtCtler = TextEditingController();
  var shipphoneTxtCtler = TextEditingController();
  String countryName = '';
  String countryCode = '';
  String countryPhoneCode = '';


  String poststatus = '';
  final List<String> errors = [];

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      billphoneTxtCtler.text = billingphone;
      shipphoneTxtCtler.text = shippingphone;
      if (bcntrycode != '') {
        pickedCountry = CountryPickUtils.getCountryByIsoCode(bcntrycode);
        countryName = pickedCountry!.displayName;
        countryCode = pickedCountry!.countryCode;
        countryPhoneCode = pickedCountry!.phoneCode;
        billcntryTxtCtler.text = countryName;
        shipcntryTxtCtler.text = countryName;
        billingcountry = countryName;
        shippingcountry = countryName;
        pickedccyCountry = CurrencyPickUtils.getCountryByIsoCode(countryCode);
        currency=pickedccyCountry!.currencyCode;
        ccyTxtCtler.text = currency;
        ccyTxtCtler.text = currency;
        if (paymentmethod == 'Visa') {
          _paymethodva=1;
        } else if (paymentmethod == 'Master') {
          _paymethodva=0;
        } 
      }
    });
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
              buildBillingPhoneFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildBillingNameFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildBillingAddrFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildBillingAddr2FormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildBillingCityFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildBillingZipFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildBillingStateFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildBillingCountryFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildShippingPhoneFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildShippingNameFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildShippingAddrFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildShippingAddr2FormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildShippingCityFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildShippingCountryFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildPaymentMethodRaFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildCardOwnerFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildCardNumberFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildCardCodeFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildCardYearFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildCardMonthFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildAuthorizationFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              buildCurrencyFormField(),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              Text(poststatus, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
              SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              DefaultButton(
                text: lblSavePay,
                press: () {
                  if (_formKey.currentState!.validate()) {
                    storeSaveChanges();
                    KeyboardUtil.hideKeyboard(context);
                    
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  setStatus(String message) {
    setState(() {
      poststatus = message;
    });
  }

  storeSaveChanges() {
    setStatus(txtPaySavingInfo);
    var postdata = {
        "id": (admcurstore.isNotEmpty)? "${admcurstore.first.id}" : "0" ,
        "billing_phone" : (billingphone.isNotEmpty) ? billingphone : '',
        "billing_name" : (billingname.isNotEmpty) ? billingname : '', 
        "billing_addr" : (billingaddr.isNotEmpty) ? billingaddr : '', 
        "billing_addr2" : (billingaddr2.isNotEmpty) ? billingaddr2 : '', 
        "billing_city" : (billingcity.isNotEmpty) ? billingcity : '', 
        "billing_zip" : (billingzip.isNotEmpty) ? billingzip : '', 
        "billing_state" : (billingstate.isNotEmpty) ? billingstate : '', 
        "billing_country" : (billingcountry.isNotEmpty) ? billingcountry : '', 
        "shipping_phone" : (shippingphone.isNotEmpty) ? shippingphone : '', 
        "shipping_name" : (shippingname.isNotEmpty) ? shippingname : '', 
        "shipping_addr" : (shippingaddr.isNotEmpty) ? shippingaddr : '', 
        "shipping_addr2" : (shippingaddr2.isNotEmpty) ? shippingaddr2 : '', 
        "shipping_city" : (shippingcity.isNotEmpty) ? shippingcity : '', 
        "shipping_zip" : (shippingzip.isNotEmpty) ? shippingzip : '', 
        "shipping_state" : (shippingstate.isNotEmpty) ? shippingstate : '', 
        "shipping_country" : (shippingcountry.isNotEmpty) ? shippingcountry : '', 
        "bcntry_code" : (bcntrycode.isNotEmpty) ? bcntrycode : '', 
        "scntry_code" : (scntrycode.isNotEmpty) ? scntrycode : '', 
        "payment_method" : (paymentmethod.isNotEmpty) ? paymentmethod : '', 
        "card_owner" : (cardowner.isNotEmpty) ? cardowner : '', 
        "card_number" : (cardnumber.isNotEmpty) ? cardnumber : '', 
        "card_code" : (cardcode.isNotEmpty) ? cardcode : '', 
        "card_year" : (cardyear.isNotEmpty) ? cardyear : '', 
        "card_month" : (cardmonth.isNotEmpty) ? cardmonth : '', 
        "authorization" : (authorization.isNotEmpty) ? authorization : '', 
        "currency" : (currency.isNotEmpty) ? currency : '', 
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
                AtcStore tmpstore = AtcStore.fromJsonDet(resary['data']);
                if (admcurstore.isNotEmpty) {
                  syncCurStoresList(tmpstore, 0);
                } else {
                  admcurstore = [];
                  admcurstore.add(tmpstore);
                }
                admcurstoreid = admcurstore.first.id;
                if (allappstores.where((strelem) => (strelem.id == admcurstoreid)).isNotEmpty) {
                  syncStoresList(admcurstore.first,allappstores.indexWhere((strelem) => (strelem.id == admcurstoreid)));
                } else {
                  allappstores.add(admcurstore.first);
                }
              });
              setStatus(txtStatSaved);
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
      // 
    });
  }

  syncCurStoresList(AtcStore fromStore, int toStoreIdx) {
    admcurstore[toStoreIdx].id = fromStore.id;
    admcurstore[toStoreIdx].userid = fromStore.userid;
    admcurstore[toStoreIdx].storecode = fromStore.storecode;
    admcurstore[toStoreIdx].storename = fromStore.storename;
    admcurstore[toStoreIdx].storeemail = fromStore.storeemail;
    admcurstore[toStoreIdx].storephone = fromStore.storephone;
    admcurstore[toStoreIdx].storefax = fromStore.storefax;
    admcurstore[toStoreIdx].storeaddr = fromStore.storeaddr;
    admcurstore[toStoreIdx].storeaddr2 = fromStore.storeaddr2;
    admcurstore[toStoreIdx].storecity = fromStore.storecity;
    admcurstore[toStoreIdx].storezip = fromStore.storezip;
    admcurstore[toStoreIdx].storestate = fromStore.storestate;
    admcurstore[toStoreIdx].storecountry = fromStore.storecountry;
    admcurstore[toStoreIdx].currency = fromStore.currency;
    admcurstore[toStoreIdx].storelat = fromStore.storelat;
    admcurstore[toStoreIdx].storelng = fromStore.storelng;
    admcurstore[toStoreIdx].rescaf = fromStore.rescaf;
    admcurstore[toStoreIdx].rescaftabs = fromStore.rescaftabs;
    admcurstore[toStoreIdx].rescaftake = fromStore.rescaftake;
    admcurstore[toStoreIdx].cvsmart = fromStore.cvsmart;
    admcurstore[toStoreIdx].pharmacy = fromStore.pharmacy;
    admcurstore[toStoreIdx].logoimg = fromStore.logoimg;
    admcurstore[toStoreIdx].logow = fromStore.logow;
    admcurstore[toStoreIdx].logoh = fromStore.logoh;
    admcurstore[toStoreIdx].uplogoimg = fromStore.uplogoimg;
    admcurstore[toStoreIdx].uplogow = fromStore.uplogow;
    admcurstore[toStoreIdx].uplogoh = fromStore.uplogoh;
    admcurstore[toStoreIdx].bcntrycode = fromStore.bcntrycode;
    admcurstore[toStoreIdx].scntrycode = fromStore.scntrycode;
    admcurstore[toStoreIdx].billingphone = fromStore.billingphone;
    admcurstore[toStoreIdx].billingname = fromStore.billingname;
    admcurstore[toStoreIdx].billingaddr = fromStore.billingaddr;
    admcurstore[toStoreIdx].billingaddr2 = fromStore.billingaddr2;
    admcurstore[toStoreIdx].billingcity = fromStore.billingcity;
    admcurstore[toStoreIdx].billingzip = fromStore.billingzip;
    admcurstore[toStoreIdx].billingstate = fromStore.billingstate;
    admcurstore[toStoreIdx].billingcountry = fromStore.billingcountry;
    admcurstore[toStoreIdx].shippingphone = fromStore.shippingphone;
    admcurstore[toStoreIdx].shippingname = fromStore.shippingname;
    admcurstore[toStoreIdx].shippingaddr = fromStore.shippingaddr;
    admcurstore[toStoreIdx].shippingaddr2 = fromStore.shippingaddr2;
    admcurstore[toStoreIdx].shippingcity = fromStore.shippingcity;
    admcurstore[toStoreIdx].shippingzip = fromStore.shippingzip;
    admcurstore[toStoreIdx].shippingstate = fromStore.shippingstate;
    admcurstore[toStoreIdx].shippingcountry = fromStore.shippingcountry;
    admcurstore[toStoreIdx].paymentmethod = fromStore.paymentmethod;
    admcurstore[toStoreIdx].cardowner = fromStore.cardowner;
    admcurstore[toStoreIdx].cardnumber = fromStore.cardnumber;
    admcurstore[toStoreIdx].cardcode = fromStore.cardcode;
    admcurstore[toStoreIdx].cardyear = fromStore.cardyear;
    admcurstore[toStoreIdx].cardmonth = fromStore.cardmonth;
    admcurstore[toStoreIdx].authorization = fromStore.authorization;
    admcurstore[toStoreIdx].transaction = fromStore.transaction;
    admcurstore[toStoreIdx].balance = fromStore.balance;
    admcurstore[toStoreIdx].accip = fromStore.accip;
    admcurstore[toStoreIdx].acctoken = fromStore.acctoken;
    admcurstore[toStoreIdx].devinfo = fromStore.devinfo;
    admcurstore[toStoreIdx].created = fromStore.created;
    admcurstore[toStoreIdx].storeusers = fromStore.storeusers;
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

  Container buildAuthorizationFormField() {
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
          onSaved: (newValue) => authorization = newValue!,
          onChanged: (value) {
            authorization = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblAuthStat,
            hintText: hintAuthStat,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
          ),
          readOnly: true,
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.authorization : "",
        ),
      ),
    );
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
          controller: ccyTxtCtler,
          onSaved: (newValue) => currency = newValue!,
          onChanged: (value) {
            currency = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblCurrency,
            hintText: hintCurrency,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/dollar-sign.svg"),
          ),
        ),
      ),
    );
  }

  Container buildCardMonthFormField() {
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
          onSaved: (newValue) => cardmonth = newValue!,
          onChanged: (value) {
            cardmonth = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblCardMonth,
            hintText: hintCardMonth,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/credit-card.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.cardmonth : "",
        ),
      ),
    );
  }
  
  Container buildCardYearFormField() {
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
          onSaved: (newValue) => cardyear = newValue!,
          onChanged: (value) {
            cardyear = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblCardYear,
            hintText: hintCardYear,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/credit-card.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.cardyear : "",
        ),
      ),
    );
  }
  
  Container buildCardCodeFormField() {
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
          onSaved: (newValue) => cardcode = newValue!,
          onChanged: (value) {
            cardcode = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblCardCode,
            hintText: hintCardCode,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/credit-card.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.cardcode : "",
        ),
      ),
    );
  }
  
  Container buildCardNumberFormField() {
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
          onSaved: (newValue) => cardnumber = newValue!,
          onChanged: (value) {
            cardnumber = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblCardNumber,
            hintText: hintCardNumber,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/credit-card.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.cardnumber : "",
        ),
      ),
    );
  }

  Container buildCardOwnerFormField() {
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
          onSaved: (newValue) => cardowner = newValue!,
          onChanged: (value) {
            cardowner = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblCardOwner,
            hintText: hintCardOwner,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/credit-card.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.cardowner : "",
        ),
      ),
    );
  }

int _paymethodva=1;
void _paymethodrachg(newValue) {
  setState(() {
    _paymethodva=newValue;
    if (_paymethodva == 1) {
      paymentmethod='Visa';
    } else {
      paymentmethod='Master';
    }
  });
}

  Container buildPaymentMethodRaFormField() {
    return Container(
      height: defTxtInpHeightRa,
      width: defTxtInpWidth,
      color: Colors.white,
      padding: EdgeInsets.all(defTxtInpEdge),
      child: Row(
        children: [
            Radio(
              value: 1,
              groupValue: _paymethodva,
              onChanged: _paymethodrachg,
            ),
            const Image(image: AssetImage("assets/images/visa.png"), 
              width: 24,
              height: 24,
              isAntiAlias: false,
            ),
            Radio(
              value: 0,
              groupValue: _paymethodva,
              onChanged: _paymethodrachg,
            ),
            const Image(image: AssetImage("assets/images/mastercard.png"), 
              width: 24,
              height: 24,
              isAntiAlias: false,
            ),
            Text(
              ' Master',
              style: TextStyle(fontSize: getProportionateScreenHeight(15)),
            ),
          ],
      ),
    );
  }

  Container buildPaymentMethodFormField() {
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
          onSaved: (newValue) => paymentmethod = newValue!,
          onChanged: (value) {
            paymentmethod = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblPayMethod,
            hintText: hintPayMethod,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/credit-card.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.paymentmethod : "",
        ),
      ),
    );
  }
  
  Container buildShippingCountryFormField() {
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
          controller: shipcntryTxtCtler,
          onSaved: (newValue) => shippingcountry = newValue!,
          onChanged: (value) {
            shippingcountry = value;
            return;
          },
          validator: (value) {
            return null;
          },
          onTap: countryPickerForCountry,
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblShipCountry,
            hintText: hintShipCountry,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
        ),
      ),
    );
  }
  
  Container buildShippingCityFormField() {
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
          onSaved: (newValue) => shippingcity = newValue!,
          onChanged: (value) {
            shippingcity = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblShipCity,
            hintText: hintShipCity,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.shippingcity : "",
        ),
      ),
    );
  }

  Container buildShippingAddr2FormField() {
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
          onSaved: (newValue) => shippingaddr2 = newValue!,
          onChanged: (value) {
            shippingaddr2 = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblShipAddress2,
            hintText: hintShipAddress2,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.shippingaddr2 : "",
        ),
      ),
    );
  }

  Container buildShippingAddrFormField() {
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
          onSaved: (newValue) => shippingaddr = newValue!,
          onChanged: (value) {
            shippingaddr = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblShipAddress,
            hintText: hintShipAddress,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.shippingaddr : "",
        ),
      ),
    );
  }
  
  Container buildShippingNameFormField() {
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
          onSaved: (newValue) => shippingname = newValue!,
          onChanged: (value) {
            shippingname = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblShipName,
            hintText: hintShipName,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.shippingname : "",
        ),
      ),
    );
  }

  Container buildShippingPhoneFormField() {
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
        controller: shipphoneTxtCtler,
	      onSaved: (newValue) => shippingphone = newValue!,
	      onChanged: (value) {
          shippingphone = value;
          return;
        },
        validator: (value) {
          return null;
        },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblShipPhone,
            hintText: hintShipPhone,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            prefixText: (null == pickedCountry)? '' : '+' + pickedCountry!.phoneCode + '-',
          ),
        ),
      ),
    );
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
            billcntryTxtCtler.text = countryName;
            shipcntryTxtCtler.text = countryName;
            billingcountry = countryName;
            shippingcountry = countryName;
            pickedccyCountry = CurrencyPickUtils.getCountryByIsoCode(countryCode);
            currency=pickedccyCountry!.currencyCode;
            ccyTxtCtler.text = currency;
            bcntrycode = countryCode;
            scntrycode = countryCode;
          });
      },
    );
  }

  Container buildBillingCountryFormField() {
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
          controller: billcntryTxtCtler,
          onSaved: (newValue) => billingcountry = newValue!,
          onChanged: (value) {
            billingcountry = value;
            return;
          },
          validator: (value) {
            return null;
          },
          onTap: countryPickerForCountry,
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblBillCountry,
            hintText: hintBillCountry,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
        ),
      ),
    );
  }

  Container buildBillingStateFormField() {
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
          onSaved: (newValue) => billingstate = newValue!,
          onChanged: (value) {
            billingstate = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblBillState,
            hintText: hintBillState,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.billingstate : "",
        ),
      ),
    );
  }

  Container buildBillingZipFormField() {
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
          onSaved: (newValue) => billingzip = newValue!,
          onChanged: (value) {
            billingzip = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblBillZip,
            hintText: hintBillZip,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.billingzip : "",
        ),
      ),
    );
  }

  Container buildBillingCityFormField() {
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
          onSaved: (newValue) => billingcity = newValue!,
          onChanged: (value) {
            billingcity = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblBillCity,
            hintText: hintBillCity,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.billingcity : "",
        ),
      ),
    );
  }

  Container buildBillingAddr2FormField() {
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
          onSaved: (newValue) => billingaddr2 = newValue!,
          onChanged: (value) {
            billingaddr2 = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblBillAddr2,
            hintText: hintBillAddr2,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.billingaddr2 : "",
        ),
      ),
    );
  }

  Container buildBillingAddrFormField() {
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
          onSaved: (newValue) => billingaddr = newValue!,
          onChanged: (value) {
            billingaddr = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblBillAddr,
            hintText: hintBillAddr,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.billingaddr : "",
        ),
      ),
    );
  }

  Container buildBillingNameFormField() {
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
          onSaved: (newValue) => billingname = newValue!,
          onChanged: (value) {
            billingname = value;
            return;
          },
          validator: (value) {
            return null;
          },
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblBillName,
            hintText: hintBillName,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
          ),
          initialValue: (admcurstore.isNotEmpty)? admcurstore.first.billingname : "",
        ),
      ),
    );
  }

  Container buildBillingPhoneFormField() {
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
          controller: billphoneTxtCtler,
          onSaved: (newValue) => billingphone = newValue!,
          onChanged: (value) {
            billingphone = value;
            return;
          },
          validator: (value) {
            return null;
          },
          onTap: countryPickerForPhone,
          decoration: InputDecoration(counterText: ' ', counterStyle: const TextStyle(fontSize: 0), helperStyle: const TextStyle(fontSize: 0), errorStyle: const TextStyle(fontSize: 0),
            labelText: lblBillPhone,
            hintText: hintBillPhone,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
            prefixText: (null == pickedCountry)? '' : '+' + pickedCountry!.phoneCode + '-',
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
              billcntryTxtCtler.text = countryName;
              shipcntryTxtCtler.text = countryName;
              pickedccyCountry = CurrencyPickUtils.getCountryByIsoCode(countryCode);
              currency=pickedccyCountry!.currencyCode;
              ccyTxtCtler.text = currency;
              bcntrycode = countryCode;
              scntrycode = countryCode;
            });
        },
      );
    }
  }
  

}
