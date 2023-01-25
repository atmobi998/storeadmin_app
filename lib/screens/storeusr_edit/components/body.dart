import 'package:flutter/material.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/size_config.dart';
// import 'package:shopadmin_app/app_globals.dart';

import 'storeusr_edit_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                Text("Store Staff", style: headingStyle),
                Text(
                  "Fill with your staff details",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                StoreUserEditForm(),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges01)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
