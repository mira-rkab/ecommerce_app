

import 'dart:convert';

import 'package:get/get.dart';

import '../../core/api_service.dart';
import '../../core/api_endpoints.dart';
import '../product/product_model.dart';

class HomeController extends GetxController {
  final products = <ProductModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await ApiService.getData(
        endpoint: ApiEndpoints.products,
        requiresAuth: false,
      );

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('استجابة غير صحيحة من السيرفر');
      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        final data = decoded['data'];

        if (data is! Map) {
          throw Exception('تنسيق بيانات المنتجات غير صحيح');
        }

        final productList = data['data'];

        if (productList is! List) {
          throw Exception('قائمة المنتجات غير موجودة');
        }

        final loadedProducts = productList
            .whereType<Map>()
            .map(
              (item) => ProductModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .toList();

        products.assignAll(loadedProducts);
      } else {
        errorMessage.value =
            decoded['message']?.toString() ??
                'تعذر تحميل المنتجات';
      }
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
