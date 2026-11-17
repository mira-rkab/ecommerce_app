

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart_controller.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/cart_summary.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FB),

      appBar: AppBar(
        title: const Text(
          'سلة التسوق',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5C4B99),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Obx(() {
        if (controller.items.isEmpty) {
          return _emptyCart();
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items[index];

                  return CartItemCard(
                    item: item,
                    onIncrease: () {
                      controller.increaseQuantity(
                        item.product.id,
                      );
                    },
                    onDecrease: () {
                      controller.decreaseQuantity(
                        item.product.id,
                      );
                    },
                    onRemove: () {
                      controller.removeItem(
                        item.product.id,
                      );

                      Get.snackbar(
                        'تم الحذف',
                        'تم حذف المنتج من السلة',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  );
                },
              ),
            ),

            CartSummary(
              totalItems: controller.totalItems,
              totalPrice: controller.totalPrice,
              onCheckout: () {
                controller.createOrder();
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _emptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 85,
              color: Color(0xFF9F91CC),
            ),

            const SizedBox(height: 18),

            const Text(
              'سلتك فارغة',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 9),

            const Text(
              'لم تقم بإضافة أي منتجات إلى السلة بعد',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 22),

            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('متابعة التسوق'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C4B99),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
