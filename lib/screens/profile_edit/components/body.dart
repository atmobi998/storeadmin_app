import 'package:flutter/material.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/size_config.dart';
import 'profile_edit_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
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
                Text(txtOwnerAccount, style: headingStyle, textAlign: TextAlign.center),
                Text(txtAcctCompDet,textAlign: TextAlign.center,),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                ProfileEditForm(),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                Text(txtAgree,textAlign: TextAlign.center,style: Theme.of(context).textTheme.caption,),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
