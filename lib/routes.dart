import 'package:flutter/widgets.dart';
import 'package:shopadmin_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shopadmin_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:shopadmin_app/screens/store_list/store_list_screen.dart';
import 'package:shopadmin_app/screens/sign_in/sign_in_screen.dart';
import 'package:shopadmin_app/screens/splash/splash_screen.dart';
import 'package:shopadmin_app/screens/store_edit/store_edit_screen.dart';
import 'package:shopadmin_app/screens/store_add/store_add_screen.dart';
import 'package:shopadmin_app/screens/store_payment_edit/store_payment_edit_screen.dart';
import 'package:shopadmin_app/screens/store_loc/store_loc_screen.dart';
import 'package:shopadmin_app/screens/profile_edit/profile_edit_screen.dart';
import 'package:shopadmin_app/screens/category_list/category_list_screen.dart';
import 'package:shopadmin_app/screens/category_edit/category_edit_screen.dart';
import 'package:shopadmin_app/screens/category_add/category_add_screen.dart';
import 'package:shopadmin_app/screens/product_list/product_list_screen.dart';
import 'package:shopadmin_app/screens/product_edit/product_edit_screen.dart';
import 'package:shopadmin_app/screens/product_add/product_add_screen.dart';
import 'package:shopadmin_app/screens/storeusr_list/storeusr_list_screen.dart';
import 'package:shopadmin_app/screens/storeusr_edit/storeusr_edit_screen.dart';
import 'package:shopadmin_app/screens/storeusr_add/storeusr_add_screen.dart';


import 'screens/sign_up/sign_up_screen.dart';

final Map<String, WidgetBuilder> routes = {
  
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  StoreListScreen.routeName: (context) => StoreListScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  ProfileEditScreen.routeName: (context) => ProfileEditScreen(),
  StoreEditScreen.routeName: (context) => StoreEditScreen(),
  StoreAddScreen.routeName: (context) => StoreAddScreen(),
  StorePaymentEditScreen.routeName: (context) => StorePaymentEditScreen(),
  CategoryListScreen.routeName: (context) => CategoryListScreen(),
  CategoryEditScreen.routeName: (context) => const CategoryEditScreen(),
  CategoryAddScreen.routeName: (context) => const CategoryAddScreen(),
  ProductListScreen.routeName: (context) => ProductListScreen(),
  ProductEditScreen.routeName: (context) => ProductEditScreen(),
  ProductAddScreen.routeName: (context) => ProductAddScreen(),
  StoreLocationScreen.routeName: (context) => StoreLocationScreen(),
  StoreUserListScreen.routeName: (context) => StoreUserListScreen(),
  StoreUserEditScreen.routeName: (context) => StoreUserEditScreen(),
  StorePosAddScreen.routeName: (context) => StorePosAddScreen(),

};

// CategoryEditScreen