
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sign_in_controller.dart';
import 'widgets/sign_in_form.dart';

import '../sign_up/sign_up_screen.dart';
import '../sign_up/sign_up_binding.dart';

class SignInScreen extends GetView<SignInController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 30,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 440,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 25),

                  // App logo
                  Center(
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: const Color(0xFFECE8F7),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: Color(0xFF5C4B99),
                        size: 46,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'مرحباً بعودتك!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252238),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'سجّل الدخول لمتابعة التسوق واكتشاف المنتجات',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 38),

                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: SignInForm(
                      controller: controller,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Create account link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ليس لديك حساب؟',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(
                                () => const SignUpScreen(),
                            binding: SignUpBinding(),
                          );
                        },
                        child: const Text(
                          'إنشاء حساب',
                          style: TextStyle(
                            color: Color(0xFF5C4B99),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'تسوّق بسهولة وأمان',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF9F91CC),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
