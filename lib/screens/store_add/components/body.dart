import 'package:flutter/material.dart';
import 'package:shopadmin_app/constants.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'package:shopadmin_app/size_config.dart';
// import 'package:shopadmin_app/app_globals.dart';

import 'store_add_form.dart';

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
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                Text(txtStoreInfo, style: headingStyle),
                Text(txtFillStoreDetail,textAlign: TextAlign.center,),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
                const StoreAddForm(),
                SizedBox(height: getProportionateScreenHeight(defFormFieldEdges10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
