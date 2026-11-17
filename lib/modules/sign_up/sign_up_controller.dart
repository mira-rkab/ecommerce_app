

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../home/home_screen.dart';
import '../home/home_binding.dart';

import '../../core/api_service.dart';
import '../../core/api_endpoints.dart';
import '../../core/app_constants.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  final GetStorage storage = GetStorage();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await ApiService.postData(
        endpoint: ApiEndpoints.register,
        body: {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text,
        },
        requiresAuth: false,
      );
      debugPrint('REGISTER STATUS: ${response.statusCode}');
      debugPrint('REGISTER RESPONSE: ${response.body}');

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('استجابة غير متوقعة من السيرفر');
      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        final data = decoded['data'];

        final token = data is Map
            ? data['token']?.toString()
            : null;

        if (token == null || token.isEmpty) {
          throw Exception('لم يصل رمز الدخول من السيرفر');
        }

        await storage.write(
          AppConstants.tokenKey,
          token,
        );

        final user = data is Map ? data['user'] : null;

        if (user is Map) {
          if (user['id'] != null) {
            await storage.write(
              AppConstants.userIdKey,
              user['id'],
            );
          }

          if (user['name'] != null) {
            await storage.write(
              AppConstants.userNameKey,
              user['name'],
            );
          }

          if (user['email'] != null) {
            await storage.write(
              AppConstants.userEmailKey,
              user['email'],
            );
          }
        }

        Get.snackbar(
          'تم إنشاء الحساب',
          decoded['message']?.toString() ??
              'تم التسجيل بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        Get.offAll(
              () => const HomeScreen(),
          binding: HomeBinding(),
        );

        // سنضيف الانتقال للصفحة الرئيسية بعد تجهيزها.
      } else {
        final message = decoded['message']?.toString() ??
            'تعذر إنشاء الحساب';

        Get.snackbar(
          'فشل التسجيل',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      debugPrint('REGISTER ERROR: $e');
      String message;

      if (e.toString().contains('SocketException')) {
        message = 'تعذر الاتصال بالسيرفر، تحقق من الاتصال';
      } else if (e.toString().contains('TimeoutException')) {
        message = 'انتهت مهلة الاتصال بالسيرفر';
      } else {
        message = e.toString().replaceFirst('Exception: ', '');
      }

      Get.snackbar(
        'حدث خطأ',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
