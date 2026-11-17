

import 'dart:convert';

import 'package:get/get.dart';

import '../../core/api_service.dart';
import '../../core/api_endpoints.dart';
import 'product_model.dart';

class ProductDetailsController extends GetxController {
  ProductDetailsController({
    required this.productId,
  });

  final int productId;

  final product = Rxn<ProductModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await ApiService.getData(
        endpoint: ApiEndpoints.productDetails(productId),
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
          throw Exception('بيانات المنتج غير موجودة');
        }

        product.value = ProductModel.fromJson(
          Map<String, dynamic>.from(data),
        );
      } else {
        errorMessage.value =
            decoded['message']?.toString() ??
                'تعذر تحميل تفاصيل المنتج';
      }
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
