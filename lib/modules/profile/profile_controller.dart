
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/api_service.dart';
import '../../core/api_endpoints.dart';
import '../../core/app_constants.dart';

import '../sign_in/sign_in_screen.dart';
import '../sign_in/sign_in_binding.dart';

class ProfileController extends GetxController {
  final GetStorage storage = GetStorage();

  final RxMap<String, dynamic> user = <String, dynamic>{}.obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoggingOut = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await ApiService.getData(
        endpoint: ApiEndpoints.profile,
        requiresAuth: true,
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          decoded is Map &&
          decoded['success'] == true &&
          decoded['data'] is Map) {
        user.assignAll(
          Map<String, dynamic>.from(decoded['data']),
        );
      } else {
        errorMessage.value = decoded is Map
            ? decoded['message']?.toString() ?? 'تعذر تحميل بيانات الحساب'
            : 'استجابة غير صحيحة من الخادم';
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء تحميل بيانات الحساب';
      debugPrint('Fetch Profile Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String get roleText {
    final role = user['role']?.toString().toLowerCase();

    if (role == 'admin') return 'مدير النظام';
    if (role == 'customer') return 'عميل';

    return role ?? 'غير محدد';
  }

  Future<void> logout() async {
    if (isLoggingOut.value) return;

    isLoggingOut.value = true;

    try {
      final response = await ApiService.postData(
        endpoint: ApiEndpoints.logout,
        requiresAuth: true,
        body: {},
      );

      if (response.statusCode == 200 ||
          response.statusCode == 204) {
        await _clearSession();
        return;
      }

      final decoded = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : null;

      Get.snackbar(
        'تنبيه',
        decoded is Map
            ? decoded['message']?.toString() ?? 'تعذر تسجيل الخروج'
            : 'تعذر تسجيل الخروج',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint('Logout Error: $e');

      Get.snackbar(
        'خطأ',
        'تعذر الاتصال بالخادم أثناء تسجيل الخروج',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoggingOut.value = false;
    }
  }

  Future<void> _clearSession() async {
    await storage.remove(AppConstants.tokenKey);
    await storage.remove(AppConstants.userIdKey);
    await storage.remove(AppConstants.userNameKey);
    await storage.remove(AppConstants.userEmailKey);
    await storage.remove(AppConstants.userRoleKey);

    Get.offAll(
          () => const SignInScreen(),
      binding: SignInBinding(),
    );
  }
}
