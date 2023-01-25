import 'package:flutter/material.dart';
import 'package:sized_context/sized_context.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData = const MediaQueryData();
  static double screenWidth = 1920;
  static double screenWidthPx = 1920;
  static double screenHeight = 1080;
  static double screenHeightPx = 1080;
  static double defaultSize = 1080;
  static Orientation orientation = Orientation.landscape;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenWidthPx = context.widthPx;
    screenHeight = _mediaQueryData.size.height;
    screenHeightPx = context.heightPx;
    orientation = _mediaQueryData.orientation;
  }
}

double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  double screenHeightPx = SizeConfig.screenHeightPx;
  return (inputHeight / screenHeightPx) * screenHeight;
}

double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  double screenWidthPx = SizeConfig.screenWidthPx;
  return (inputWidth / screenWidthPx) * screenWidth;
}

double getHalfScreenHeight() {
  double screenHeightPx = SizeConfig.screenHeightPx;
  return (screenHeightPx / 2.05);
}

double getHalfScreenWidth() {
  double screenWidthPx = SizeConfig.screenWidthPx;
  return (screenWidthPx / 2.05);
}

double getScreenHeight() {
  double screenHeightPx = SizeConfig.screenHeightPx;
  return (screenHeightPx);
}

double getScreenWidth() {
  double screenWidthPx = SizeConfig.screenWidthPx;
  return (screenWidthPx);
}