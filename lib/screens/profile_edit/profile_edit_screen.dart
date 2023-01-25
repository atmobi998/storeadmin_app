import 'package:flutter/material.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class ProfileEditScreen extends StatelessWidget {
  static String routeName = "/profile_edit";
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(txtOwnerProfile),
      ),
      body: Body(),
    );
  }
}
