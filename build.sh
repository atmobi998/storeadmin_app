#!/bin/sh
cp appbuildmode_r.dart lib/appbuildmode.dart
builddate=`date +'%F'`
version=`cat pubspec.yaml|grep version:|cut -f2 -d' '|cut -f1 -d'+'`
buildnbr=`cat pubspec.yaml|grep version:|cut -f2 -d' '|cut -f2 -d'+'`
# flutter clean;
flutter build appbundle;
mkdir -p /Users/devmob/Desktop/flutter_apps/macos_bk/storeadmin_app_releases
cp build/app/outputs/bundle/release/app-release.aab /Users/devmob/Desktop/flutter_apps/macos_bk/storeadmin_app_releases/$version-$buildnbr-$builddate-app-release.aab
ls -la /Users/devmob/Desktop/flutter_apps/macos_bk/storeadmin_app_releases/$version-$buildnbr-$builddate-app-release.aab
flutter build ipa --release 
