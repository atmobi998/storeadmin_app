import 'package:flutter/material.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  const SignInScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(txtSignIn),
        automaticallyImplyLeading: false,
      ),
      body: const Body(),
    );
  }
}
