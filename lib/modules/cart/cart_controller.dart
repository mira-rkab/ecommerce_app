
import 'dart:convert';

import 'package:get/get.dart';

import '../../core/api_service.dart';
import '../../core/api_endpoints.dart';
import '../product/product_model.dart';
import 'cart_item_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> items = <CartItemModel>[].obs;

  final RxBool isCheckingOut = false.obs;

  // عدد القطع الموجودة في السلة
  int get totalItems {
    return items.fold(
      0,
          (total, item) => total + item.quantity,
    );
  }

  // الإجمالي الكلي
  double get totalPrice {
    return items.fold(
      0.0,
          (total, item) => total + item.totalPrice,
    );
  }

  // إضافة منتج إلى السلة
  bool addToCart(ProductModel product, int quantity) {
    if (quantity < 1) {
      Get.snackbar(
        'تنبيه',
        'يرجى اختيار كمية صحيحة',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (product.stock <= 0) {
      Get.snackbar(
        'غير متوفر',
        'هذا المنتج غير متوفر حالياً',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    final index = items.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index != -1) {
      final existingItem = items[index];
      final newQuantity = existingItem.quantity + quantity;

      if (newQuantity > product.stock) {
        Get.snackbar(
          'الكمية غير متوفرة',
          'الكمية المطلوبة أكبر من المخزون المتاح',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      existingItem.quantity = newQuantity;
      items.refresh();
    } else {
      if (quantity > product.stock) {
        Get.snackbar(
          'الكمية غير متوفرة',
          'الكمية المطلوبة أكبر من المخزون المتاح',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      items.add(
        CartItemModel(
          product: product,
          quantity: quantity,
        ),
      );
    }

    Get.snackbar(
      'تمت الإضافة',
      'تمت إضافة المنتج إلى السلة بنجاح',
      snackPosition: SnackPosition.BOTTOM,
    );

    return true;
  }

  // زيادة كمية منتج
  void increaseQuantity(int productId) {
    final index = items.indexWhere(
          (item) => item.product.id == productId,
    );

    if (index == -1) return;

    final item = items[index];

    if (item.quantity >= item.product.stock) {
      Get.snackbar(
        'تنبيه',
        'وصلت إلى الحد الأقصى للكمية المتوفرة',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    item.quantity++;
    items.refresh();
  }

  // تقليل كمية منتج
  void decreaseQuantity(int productId) {
    final index = items.indexWhere(
          (item) => item.product.id == productId,
    );

    if (index == -1) return;

    final item = items[index];

    if (item.quantity > 1) {
      item.quantity--;
      items.refresh();
    }
  }

  // حذف منتج من السلة
  void removeItem(int productId) {
    items.removeWhere(
          (item) => item.product.id == productId,
    );
  }

  // إفراغ السلة
  void clearCart() {
    items.clear();
  }

  // إتمام الطلب وإرساله إلى Laravel
  Future<void> createOrder() async {
    if (items.isEmpty) {
      Get.snackbar(
        'السلة فارغة',
        'أضف منتجات إلى السلة أولاً',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isCheckingOut.value) return;

    isCheckingOut.value = true;

    try {
      final orderItems = items.map((item) {
        return {
          'product_id': item.product.id,
          'quantity': item.quantity,
        };
      }).toList();

      final response = await ApiService.postData(
        endpoint: ApiEndpoints.createOrder,
        requiresAuth: true,
        body: {
          'items': orderItems,
        },
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        if (decoded is Map && decoded['success'] == true) {
          final orderData = decoded['data'];

          final orderId = orderData is Map
              ? orderData['id']
              : null;

          // إفراغ السلة بعد نجاح إنشاء الطلب فقط
          clearCart();

          Get.snackbar(
            'تم إنشاء الطلب بنجاح',
            orderId != null
                ? 'رقم طلبك: $orderId'
                : 'تم إرسال طلبك بنجاح',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );
        } else {
          Get.snackbar(
            'لم يتم إنشاء الطلب',
            decoded is Map
                ? (decoded['message']?.toString() ??
                'حدث خطأ أثناء إنشاء الطلب')
                : 'استجابة غير متوقعة من الخادم',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        final message = decoded is Map
            ? (decoded['message']?.toString() ??
            'حدث خطأ أثناء إرسال الطلب')
            : 'حدث خطأ أثناء إرسال الطلب';

        Get.snackbar(
          'فشل إنشاء الطلب',
          message,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ في الاتصال',
        'تعذر إرسال الطلب، تحقق من الاتصال وحاول مجدداً',
        snackPosition: SnackPosition.BOTTOM,
      );

      print('Create Order Error: $e');
    } finally {
      isCheckingOut.value = false;
    }
  }
}
