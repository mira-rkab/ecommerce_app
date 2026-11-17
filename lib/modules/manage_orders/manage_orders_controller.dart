
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/api_service.dart';
import '../../core/api_endpoints.dart';

class ManageOrdersController extends GetxController {
  final RxList<Map<String, dynamic>> orders =
      <Map<String, dynamic>>[].obs;

  final RxBool isLoading = false.obs;
  final RxInt updatingOrderId = 0.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await ApiService.getData(
        endpoint: ApiEndpoints.getOrders,
        requiresAuth: true,
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          decoded is Map &&
          decoded['success'] == true) {
        final responseData = decoded['data'];

        List<dynamic> list = [];

        if (responseData is Map &&
            responseData['data'] is List) {
          list = responseData['data'];
        } else if (responseData is List) {
          list = responseData;
        }

        orders.assignAll(
          list
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList(),
        );
      } else {
        errorMessage.value = decoded is Map
            ? decoded['message']?.toString() ??
            'تعذر تحميل الطلبات'
            : 'استجابة غير صحيحة من الخادم';
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء تحميل الطلبات';
      debugPrint('Admin Fetch Orders Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus({
    required int orderId,
    required String status,
  }) async {
    if (updatingOrderId.value != 0) return;

    updatingOrderId.value = orderId;

    try {
      final response = await ApiService.postData(
        endpoint: ApiEndpoints.updateOrderStatus(orderId),
        requiresAuth: true,
        body: {
          'status': status,
        },
      );

      final decoded = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : null;

      if ((response.statusCode == 200 ||
          response.statusCode == 201) &&
          decoded is Map &&
          decoded['success'] == true) {
        final updatedOrder = decoded['data'];

        final index = orders.indexWhere(
              (order) => order['id'] == orderId,
        );

        if (index != -1 && updatedOrder is Map) {
          orders[index] = Map<String, dynamic>.from(
            updatedOrder,
          );
        }

        Get.snackbar(
          'تم بنجاح',
          'تم تحديث حالة الطلب رقم $orderId',
          snackPosition: SnackPosition.BOTTOM,
        );

        await fetchOrders();
      } else {
        Get.snackbar(
          'تعذر التحديث',
          decoded is Map
              ? decoded['message']?.toString() ??
              'لم يتم تحديث حالة الطلب'
              : 'استجابة غير صحيحة من الخادم',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Update Order Status Error: $e');

      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحديث حالة الطلب',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      updatingOrderId.value = 0;
    }
  }

  String statusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return 'قيد الانتظار';
      case 'processing':
        return 'قيد المعالجة';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return status ?? 'غير معروف';
    }
  }

  String customerName(Map<String, dynamic> order) {
    final user = order['user'];

    if (user is Map) {
      return user['name']?.toString() ?? 'عميل';
    }

    return 'عميل';
  }
}
