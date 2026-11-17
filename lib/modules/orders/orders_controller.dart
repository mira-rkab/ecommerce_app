

import 'dart:convert';

import 'package:get/get.dart';

import '../../core/api_service.dart';
import '../../core/api_endpoints.dart';

class OrdersController extends GetxController {
  final RxList<Map<String, dynamic>> orders =
      <Map<String, dynamic>>[].obs;

  final RxBool isLoading = false.obs;
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

        List<dynamic> ordersList = [];

        // استجابة Laravel paginated
        if (responseData is Map &&
            responseData['data'] is List) {
          ordersList = responseData['data'];
        }
        // في حال رجعت القائمة مباشرة
        else if (responseData is List) {
          ordersList = responseData;
        }

        orders.assignAll(
          ordersList
              .whereType<Map>()
              .map((order) => Map<String, dynamic>.from(order))
              .toList(),
        );
      } else {
        errorMessage.value = decoded is Map
            ? (decoded['message']?.toString() ??
            'تعذر جلب الطلبات')
            : 'استجابة غير صحيحة من الخادم';
      }
    } catch (e) {
      errorMessage.value =
      'حدث خطأ أثناء تحميل الطلبات، تحقق من الاتصال بالإنترنت';

      print('Fetch Orders Error: $e');
    } finally {
      isLoading.value = false;
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
}
