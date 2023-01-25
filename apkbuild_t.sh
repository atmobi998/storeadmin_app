#!/bin/sh
cp appbuildmode_t.dart lib/appbuildmode.dart
builddate=`date +'%F'`
version=`cat pubspec.yaml|grep version:|cut -f2 -d' '|cut -f1 -d'+'`
buildnbr=`cat pubspec.yaml|grep version:|cut -f2 -d' '|cut -f2 -d'+'`
flutter clean;
flutter build apk;
mkdir -p /Users/devmob/Desktop/flutter_apps/macos_bk/storeadmin_app_apks
cp build/app/outputs/flutter-apk/app-release.apk /Users/devmob/Desktop/flutter_apps/macos_bk/storeadmin_app_apks/$version-$buildnbr-$builddate-app-test-apk.apk
ls -la /Users/devmob/Desktop/flutter_apps/macos_bk/storeadmin_app_apks/$version-$buildnbr-$builddate-app-test-apk.apk