import 'package:flutter/material.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot_password";

  const ForgotPasswordScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(txtForgotPass),
      ),
      body: const Body(),
    );
  }
}
