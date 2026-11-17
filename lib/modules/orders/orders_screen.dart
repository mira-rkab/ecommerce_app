

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'orders_controller.dart';
import 'widgets/order_card.dart';

class OrdersScreen extends GetView<OrdersController> {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value &&
          controller.orders.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF5C4B99),
          ),
        );
      }

      if (controller.errorMessage.isNotEmpty &&
          controller.orders.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Colors.red,
                ),
                const SizedBox(height: 12),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchOrders,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C4B99),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.orders.isEmpty) {
        return RefreshIndicator(
          color: const Color(0xFF5C4B99),
          onRefresh: controller.fetchOrders,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 150),
              Icon(
                Icons.receipt_long_outlined,
                size: 75,
                color: Color(0xFF9F91CC),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'لا توجد طلبات حتى الآن',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text('ستظهر طلباتك هنا بعد إتمام الشراء'),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        color: const Color(0xFF5C4B99),
        onRefresh: controller.fetchOrders,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];

            return OrderCard(
              order: order,
              statusText: controller.statusText(
                order['status']?.toString(),
              ),
            );
          },
        ),
      );
    });
  }
}
