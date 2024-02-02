import 'package:flutter/material.dart';
import 'package:shopadmin_app/size_config.dart';
import 'package:shopadmin_app/appbuildmode.dart';

const kPrimaryColor = Color(0xFF498cf2);
const kPrimaryLightColor = Color(0xFFFFECDF);
const colors = [Color(0xFF498cf2), Color(0xFF0c55c3)];
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF498cf2), Color(0xFF0c55c3)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const kAnimationDuration = Duration(milliseconds: 200);
final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(22),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);
const Color inActiveIconColor = Color(0xFFB6B6B6);
const defaultDuration = Duration(milliseconds: 250);

double defInpFormMaxWidth = getProportionateScreenWidth(500);
double defInpFormWidth = getProportionateScreenWidth(500);

double defListFormMaxWidth = getProportionateScreenWidth(450);
double defListFormWidth = getProportionateScreenWidth(450);
double defEditFormWidth = getProportionateScreenWidth(650);
double defEditFormMaxWidth = getProportionateScreenWidth(650);
double defCatListFormMaxWidth = getProportionateScreenWidth(450);
double defProdListFormWidth = getProportionateScreenWidth(650);

double defTxtInpWidth = getProportionateScreenWidth(400);
double defTxtInpMaxWidth = getProportionateScreenWidth(400);
double defTxtInpHeight = getProportionateScreenHeight(89);
double defTxtInpHeightRa = getProportionateScreenHeight(59);
double defTxtInpMaxHeight = getProportionateScreenHeight(89);
double defTxtInpEdge = getProportionateScreenHeight(3);

double defChkInpWidth = getProportionateScreenWidth(400);
double defChkInpMaxWidth = getProportionateScreenWidth(400);
double defChkInpHeight = getProportionateScreenHeight(89);
double defChkInpMaxHeight = getProportionateScreenHeight(89);

double defTxtBoxWidth = getProportionateScreenWidth(400);
double defTxtBoxMaxWidth = getProportionateScreenWidth(400);
double defTxtBoxHeight = getProportionateScreenHeight(130);
double defTxtBoxMaxHeight = getProportionateScreenHeight(140);
double defTxtBoxEdge = getProportionateScreenHeight(1);
int defTxtBoxLines02 = 2;
int defTxtBoxLines03 = 3;

double defSrearchInpWidth = getProportionateScreenWidth(300);
double defSrearchInpMaxWidth = getProportionateScreenWidth(300);
double defSrearchInpHeight = getProportionateScreenHeight(69);
double defSrearchInpMaxHeight = getProportionateScreenHeight(69);

double defFormFieldEdges01 = getProportionateScreenHeight(1);
double defFormFieldEdges02 = getProportionateScreenHeight(2);
double defFormFieldEdges05 = getProportionateScreenHeight(5);
double defFormFieldEdges10 = getProportionateScreenHeight(10);
double defFormFieldEdges20 = getProportionateScreenHeight(20);
double defFormFieldEdges30 = getProportionateScreenHeight(30);

double defBarcodeHeight = getProportionateScreenHeight(100);
double defBarcodeWidth = getProportionateScreenWidth(350);
double defBarcodeMaxHeight = getProportionateScreenHeight(110);
double defBarcodeMaxWidth = getProportionateScreenWidth(360);
double defAztecMaxHeight = getProportionateScreenHeight(200);
double defAztecMaxWidth = getProportionateScreenWidth(200);
double defQrCodeMaxHeight = getProportionateScreenHeight(200);
double defQrCodeMaxWidth = getProportionateScreenWidth(200);

double prodListScrlHeight = getScreenHeight() * (65 / 100);
double catListScrlHeight = getScreenHeight() * (65 / 100);
double storeListScrlHeight = getScreenHeight() * (73 / 100);
double posListScrlHeight = getScreenHeight() * (65 / 100);

double defUIsize60 = getProportionateScreenHeight(60);
double defUIsize50 = getProportionateScreenHeight(50);
double defUIsize40 = getProportionateScreenHeight(40);
double defUIsize30 = getProportionateScreenHeight(30);
double defUIsize20 = getProportionateScreenHeight(20);
double defUIsize18 = getProportionateScreenHeight(18);
double defUIsize16 = getProportionateScreenHeight(16);
double defUIsize14 = getProportionateScreenHeight(14);
double defUIsize13 = getProportionateScreenHeight(13);
double defUIsize12 = getProportionateScreenHeight(12);
double defUIsize11 = getProportionateScreenHeight(11);
double defUIsize10 = getProportionateScreenHeight(10);

const String kMapAPIkey = 'map key from google cloud console';

bool installedSMS = true;

// Rest URIs

const String mobAppVal = 'storeadmin_app';
const String imagehost = (appbuildmode == 'Release')? 'https://metroeconomics.com/' : 'http://metroeconomics.com/';
const String kapihost = (appbuildmode == 'Release')? 'https://metroeconomics.com/'  : 'http://metroeconomics.com/';

final Uri loginEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "profile/token") : Uri.http("metroeconomics.com", "profile/token");
final Uri registerEndPoint = (appbuildmode == 'Release') ? Uri.https("metroeconomics.com", "profile/register") : Uri.http("metroeconomics.com", "profile/register");
final Uri profileeditEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "profile/profileedit") : Uri.http("metroeconomics.com", "profile/profileedit");
final Uri forgotqryEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "profile/forgot") : Uri.http("metroeconomics.com", "profile/forgot");

final Uri storeaddEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "mobstore/addstore") : Uri.http("metroeconomics.com", "mobstore/addstore");
final Uri storeeditEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "mobstore/editstore") : Uri.http("metroeconomics.com", "mobstore/editstore");
final Uri storeqryEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "mobstore/storeqry") : Uri.http("metroeconomics.com", "mobstore/storeqry");

final Uri loginPosEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "mobstore/postoken") : Uri.http("metroeconomics.com", "mobstore/postoken");
final Uri storeaddPosEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "mobstore/addpos") : Uri.http("metroeconomics.com", "mobstore/addpos");
final Uri storeeditPosEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "mobstore/editpos") : Uri.http("metroeconomics.com", "mobstore/editpos");
final Uri storeqryPosEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "mobstore/posqry") : Uri.http("metroeconomics.com", "mobstore/posqry");

final Uri categoryqryEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "mobcat/catqry") : Uri.http("metroeconomics.com", "mobcat/catqry");
final Uri categoryeditEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "mobcat/editcat") : Uri.http("metroeconomics.com", "mobcat/editcat");
final Uri categoryaddEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "mobcat/addcat") : Uri.http("metroeconomics.com", "mobcat/addcat");

final Uri productqryEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "mobprod/prodqry") : Uri.http("metroeconomics.com", "mobprod/prodqry");
final Uri producteditEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "mobprod/editprod") : Uri.http("metroeconomics.com", "mobprod/editprod");
final Uri productaddEndPoint = (appbuildmode == 'Release')? Uri.https("metroeconomics.com", "mobprod/addprod") : Uri.http("metroeconomics.com", "mobprod/addprod");

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextColor),
  );
}
