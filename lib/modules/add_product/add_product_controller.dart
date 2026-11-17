
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/api_service.dart';
import '../../core/api_endpoints.dart';
import '../../core/app_constants.dart';
import 'package:get_storage/get_storage.dart';

class AddProductController extends GetxController {
  final GetStorage storage = GetStorage();

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final categoryController = TextEditingController();

  final isLoading = false.obs;

  Future<void> addProduct() async {
    if (isLoading.value) return;

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    // التأكد من أن الحساب الحالي مدير
    final role = storage.read(AppConstants.userRoleKey);

    if (role != 'admin') {
      Get.snackbar(
        'Access denied',
        'Only administrators can add products.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final price = double.tryParse(priceController.text.trim());
    final stock = int.tryParse(stockController.text.trim());

    if (price == null || price <= 0) {
      Get.snackbar('Invalid price', 'Enter a valid price.');
      return;
    }

    if (stock == null || stock < 0) {
      Get.snackbar('Invalid stock', 'Enter a valid stock quantity.');
      return;
    }

    isLoading.value = true;

    try {
      final response = await ApiService.postData(
        endpoint: ApiEndpoints.createProduct,
        requiresAuth: true,
        body: {
          'name': nameController.text.trim(),
          'description': descriptionController.text.trim(),
          'price': price,
          'stock': stock,
          'category': categoryController.text.trim(),
          'image': null,
        },
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          decoded is Map &&
          decoded['success'] == true) {
        clearFields();

        Get.back();

        Get.snackbar(
          'Success',
          decoded['message']?.toString() ??
              'Product created successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.black,
          margin: const EdgeInsets.all(12),
        );
      } else {
        String message = 'Failed to add product.';

        if (decoded is Map) {
          message = decoded['message']?.toString() ?? message;

          // عرض أخطاء التحقق القادمة من Laravel
          if (decoded['errors'] is Map) {
            final errors = decoded['errors'] as Map;
            final firstError = errors.values.first;

            if (firstError is List && firstError.isNotEmpty) {
              message = firstError.first.toString();
            }
          }
        }

        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
          margin: const EdgeInsets.all(12),
        );
      }
    } catch (e) {
      debugPrint('ADD PRODUCT ERROR: $e');

      Get.snackbar(
        'Connection error',
        'Could not add product. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    stockController.clear();
    categoryController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    categoryController.dispose();
    super.onClose();
  }
}
