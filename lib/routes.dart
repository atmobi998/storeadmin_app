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
  
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  StoreListScreen.routeName: (context) => const StoreListScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  ProfileEditScreen.routeName: (context) => const ProfileEditScreen(),
  StoreEditScreen.routeName: (context) => const StoreEditScreen(),
  StoreAddScreen.routeName: (context) => const StoreAddScreen(),
  StorePaymentEditScreen.routeName: (context) => const StorePaymentEditScreen(),
  CategoryListScreen.routeName: (context) => const CategoryListScreen(),
  CategoryEditScreen.routeName: (context) => const CategoryEditScreen(),
  CategoryAddScreen.routeName: (context) => const CategoryAddScreen(),
  ProductListScreen.routeName: (context) => const ProductListScreen(),
  ProductEditScreen.routeName: (context) => const ProductEditScreen(),
  ProductAddScreen.routeName: (context) => const ProductAddScreen(),
  StoreLocationScreen.routeName: (context) => const StoreLocationScreen(),
  StoreUserListScreen.routeName: (context) => const StoreUserListScreen(),
  StoreUserEditScreen.routeName: (context) => const StoreUserEditScreen(),
  StorePosAddScreen.routeName: (context) => const StorePosAddScreen(),

};

// CategoryEditScreen