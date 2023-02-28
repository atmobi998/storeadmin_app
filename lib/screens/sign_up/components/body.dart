import 'package:flutter/material.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/size_config.dart';
import 'sign_up_form.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

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
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
                Text(txtRegHdr, style: headingStyle, textAlign: TextAlign.center),
                Text(
                  txtRegCompDet,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
                const SignUpForm(),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
                Text(
                  txtAgree,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
