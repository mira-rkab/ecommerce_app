
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/api_service.dart';
import '../../core/api_endpoints.dart';
import '../../core/app_constants.dart';

import '../home/home_screen.dart';
import '../home/home_binding.dart';

import '../admin/admin_screen.dart';
import '../admin/admin_binding.dart';

class SignInController extends GetxController {
  final GetStorage storage = GetStorage();

  // Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text fields
  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  // Password visibility
  final RxBool isPasswordHidden = true.obs;

  // Loading
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    if (isLoading.value) return;

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isLoading.value = true;

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      // 1. Login API
      final response = await ApiService.postData(
        endpoint: ApiEndpoints.login,
        body: {
          'email': email,
          'password': password,
        },
        requiresAuth: false,
      );

      debugPrint('LOGIN STATUS: ${response.statusCode}');

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        // لا نطبع بيانات الدخول أو أي token في السجل
        debugPrint('LOGIN ERROR RESPONSE: ${response.body}');

        throw Exception(
          'فشل تسجيل الدخول. تأكدي من البريد الإلكتروني وكلمة المرور.',
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('استجابة تسجيل الدخول غير صحيحة.');
      }

      final data = decoded['data'];

      if (data is! Map<String, dynamic>) {
        throw Exception('بيانات تسجيل الدخول غير موجودة.');
      }

      final token = data['token']?.toString();

      if (token == null || token.isEmpty) {
        throw Exception('لم يتم استلام رمز الدخول من الخادم.');
      }

      // 2. Save token
      await storage.write(AppConstants.tokenKey, token);

      // 3. Get user profile to know the role
      final profileResponse = await ApiService.getData(
        endpoint: ApiEndpoints.profile,
        requiresAuth: true,
      );

      if (profileResponse.statusCode < 200 ||
          profileResponse.statusCode >= 300) {
        throw Exception(
          'تم تسجيل الدخول، لكن تعذر جلب بيانات الحساب.',
        );
      }

      final profileDecoded = jsonDecode(profileResponse.body);

      if (profileDecoded is! Map<String, dynamic>) {
        throw Exception('بيانات الملف الشخصي غير صحيحة.');
      }

      final userData = profileDecoded['data'];

      if (userData is! Map<String, dynamic>) {
        throw Exception('لم يتم العثور على بيانات المستخدم.');
      }

      final role = userData['role']?.toString() ?? '';
      final userId = userData['id'];
      final userName = userData['name']?.toString() ?? '';
      final userEmail = userData['email']?.toString() ?? '';

      // 4. Save user information
      await storage.write(AppConstants.userRoleKey, role);
      await storage.write(AppConstants.userIdKey, userId);
      await storage.write(AppConstants.userNameKey, userName);
      await storage.write(AppConstants.userEmailKey, userEmail);

      debugPrint('PROFILE STATUS: ${profileResponse.statusCode}');
      debugPrint('USER ROLE: $role');

      // 5. Navigate according to role
      if (role == 'admin') {
        Get.offAll(
              () => const AdminScreen(),
          binding: AdminBinding(),
        );
      } else if (role == 'customer') {
        Get.offAll(
              () => const HomeScreen(),
          binding: HomeBinding(),
        );
      } else {
        throw Exception('نوع الحساب غير معروف: $role');
      }
    } catch (e, stackTrace) {
      debugPrint('LOGIN ERROR: $e');
      debugPrint('$stackTrace');

      Get.snackbar(
        'تنبيه',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
        margin: const EdgeInsets.all(12),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
