import 'package:flutter/material.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";

  const SignUpScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(txtSignUp),
      ),
      body: const Body(),
    );
  }
}
