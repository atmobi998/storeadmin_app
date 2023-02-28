import 'package:flutter/material.dart';
import 'package:shopadmin_app/screens/store_payment_edit/components/bottom_nav_bar_store_payment_edit.dart';
import 'package:shopadmin_app/enums.dart';
import 'package:shopadmin_app/strconsts.dart';
import 'components/body.dart';

class StorePaymentEditScreen extends StatelessWidget {
  static String routeName = "/store_payment_edit";

  const StorePaymentEditScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    gtextTranslate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(txtPayProfile),
        automaticallyImplyLeading: false,
      ),
      body: const Body(),
      bottomNavigationBar: const BottomNavBarStorePaymentEdit(selectedMenu: StoreMenuState.none),
    );
  }
}
