
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../product/product_details_screen.dart';
import '../product/product_details_binding.dart';

import '../cart/cart_screen.dart';

import '../orders/orders_binding.dart';
import '../orders/orders_screen.dart';
import '../orders/orders_controller.dart';

import '../profile/profile_binding.dart';
import '../profile/profile_screen.dart';

import 'home_controller.dart';
import 'widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.find<HomeController>();

  int selectedIndex = 0;

  final List<String> titles = [
    'المتجر الإلكتروني',
    'سلة التسوق',
    'طلباتي',
    'حسابي',
  ];

  @override
  void initState() {
    super.initState();

    // تجهيز Controller الطلبات
    OrdersBinding().dependencies();

    // تجهيز Controller الحساب
    ProfileBinding().dependencies();
  }

  Widget _buildHomeContent() {
    return Obx(() {
      if (controller.isLoading.value &&
          controller.products.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF5C4B99),
          ),
        );
      }

      if (controller.errorMessage.isNotEmpty &&
          controller.products.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 55,
                  color: Colors.red,
                ),
                const SizedBox(height: 12),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchProducts,
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

      if (controller.products.isEmpty) {
        return RefreshIndicator(
          color: const Color(0xFF5C4B99),
          onRefresh: controller.fetchProducts,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 180),
              Icon(
                Icons.inventory_2_outlined,
                size: 65,
                color: Color(0xFF9F91CC),
              ),
              SizedBox(height: 16),
              Center(
                child: Text('لا توجد منتجات حالياً'),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        color: const Color(0xFF5C4B99),
        onRefresh: controller.fetchProducts,
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          itemCount: controller.products.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (context, index) {
            final product = controller.products[index];

            return ProductCard(
              product: product,
              onTap: () {
                Get.to(
                      () => const ProductDetailsScreen(),
                  binding: ProductDetailsBinding(
                    productId: product.id,
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }

  Widget _buildOrdersContent() {
    return const OrdersScreen();
  }

  Widget _buildProfileContent() {
    return const ProfileScreen();
  }

  Widget _buildSelectedPage() {
    switch (selectedIndex) {
      case 0:
        return _buildHomeContent();

      case 1:
        return const CartScreen();

      case 2:
        return _buildOrdersContent();

      case 3:
        return _buildProfileContent();

      default:
        return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FB),

      appBar: selectedIndex == 1
          ? null
          : AppBar(
        backgroundColor: const Color(0xFF5C4B99),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          titles[selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: _buildSelectedPage(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });

          // تحديث الطلبات عند فتح تبويب طلباتي
          if (index == 2 &&
              Get.isRegistered<OrdersController>()) {
            Get.find<OrdersController>().fetchOrders();
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF5C4B99),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'السلة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'طلباتي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
