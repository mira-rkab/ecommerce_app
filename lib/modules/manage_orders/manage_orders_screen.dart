

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'manage_orders_controller.dart';
import 'widgets/admin_order_card.dart';

class ManageOrdersScreen extends GetView<ManageOrdersController> {
  const ManageOrdersScreen({super.key});

  static const Color primaryColor = Color(0xFF5C4B99);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FB),
      appBar: AppBar(
        title: const Text(
          'إدارة الطلبات',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.orders.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
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
                    color: Colors.red,
                    size: 50,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.fetchOrders,
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.orders.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.fetchOrders,
            color: primaryColor,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 180),
                Icon(
                  Icons.receipt_long_outlined,
                  size: 65,
                  color: Color(0xFF9F91CC),
                ),
                SizedBox(height: 14),
                Center(
                  child: Text('لا توجد طلبات حالياً'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchOrders,
          color: primaryColor,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              return AdminOrderCard(
                order: controller.orders[index],
                controller: controller,
              );
            },
          ),
        );
      }),
    );
  }
}
