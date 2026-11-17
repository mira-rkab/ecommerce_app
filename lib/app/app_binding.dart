
import 'package:get/get.dart';

import '../modules/sign_in/sign_in_binding.dart';
import '../modules/cart/cart_binding.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    SignInBinding().dependencies();
    CartBinding().dependencies();
  }
}