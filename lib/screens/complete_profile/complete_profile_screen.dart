import 'package:flutter/material.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";

  const CompleteProfileScreen({Key? key}) : super(key: key);
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
