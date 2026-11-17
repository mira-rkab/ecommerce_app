

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sign_up_controller.dart';

class SignUpForm extends StatelessWidget {
  final SignUpController controller;

  const SignUpForm({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'الاسم الكامل',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 9),

          TextFormField(
            controller: controller.nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.name],
            decoration: const InputDecoration(
              hintText: 'أدخل اسمك الكامل',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'يرجى إدخال الاسم';
              }

              if (value.trim().length < 2) {
                return 'يجب أن يتكون الاسم من حرفين على الأقل';
              }

              return null;
            },
          ),

          const SizedBox(height: 22),

          const Text(
            'البريد الإلكتروني',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 9),

          TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(
              hintText: 'example@email.com',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'يرجى إدخال البريد الإلكتروني';
              }

              if (!GetUtils.isEmail(value.trim())) {
                return 'يرجى إدخال بريد إلكتروني صحيح';
              }

              return null;
            },
          ),

          const SizedBox(height: 22),

          const Text(
            'كلمة المرور',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 9),

          Obx(
                () => TextFormField(
              controller: controller.passwordController,
              obscureText: controller.isPasswordHidden.value,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => controller.register(),
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                hintText: 'أدخل كلمة المرور',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: controller.togglePasswordVisibility,
                  icon: Icon(
                    controller.isPasswordHidden.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال كلمة المرور';
                }

                return null;
              },
            ),
          ),

          const SizedBox(height: 30),

          Obx(
                () => SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C4B99),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF9F91CC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
                    : const Text(
                  'إنشاء حساب',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
