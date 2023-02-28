import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopadmin_app/routes.dart';
import 'package:shopadmin_app/screens/splash/splash_screen.dart';
// import 'package:shopadmin_app/screens/sign_in/sign_in_screen.dart';
import 'package:shopadmin_app/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shopadmin_app/strconsts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebasePhoneAuthProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: txtAppTitle,
        onGenerateTitle: (BuildContext context) => txtAppTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,     
        supportedLocales: AppLocalizations.supportedLocales,
        localeResolutionCallback: (
            Locale? locale,
            Iterable<Locale> supportedLocales,
          ) {
            return locale;
          },    
        theme: theme(),
        initialRoute: SplashScreen.routeName,
        // initialRoute: SignInScreen.routeName,
        routes: routes,
      ),
    );
  }
}

