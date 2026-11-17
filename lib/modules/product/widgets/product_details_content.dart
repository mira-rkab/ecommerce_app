
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../modules/cart/cart_controller.dart';
import '../product_model.dart';

class ProductDetailsContent extends StatefulWidget {
  const ProductDetailsContent({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  State<ProductDetailsContent> createState() =>
      _ProductDetailsContentState();
}

class _ProductDetailsContentState
    extends State<ProductDetailsContent> {
  final CartController cartController =
  Get.find<CartController>();

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final imageUrl = product.image;
    final uri = imageUrl == null ? null : Uri.tryParse(imageUrl);

    final hasImage = uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: double.infinity,
              height: 260,
              child: hasImage
                  ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _imagePlaceholder(),
              )
                  : _imagePlaceholder(),
            ),
          ),

          const SizedBox(height: 22),

          Text(
            product.name,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            product.category,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF9F91CC),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            product.price.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5C4B99),
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'وصف المنتج',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            product.description.isEmpty
                ? 'لا يوجد وصف لهذا المنتج'
                : product.description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.7,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 22),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2EFF8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xFF5C4B99),
                ),
                const SizedBox(width: 10),
                Text(
                  'الكمية المتوفرة: ${product.stock}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'اختيار الكمية',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _quantityButton(
                icon: Icons.remove,
                onPressed: quantity > 1
                    ? () {
                  setState(() {
                    quantity--;
                  });
                }
                    : null,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Text(
                  '$quantity',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              _quantityButton(
                icon: Icons.add,
                onPressed: quantity < product.stock
                    ? () {
                  setState(() {
                    quantity++;
                  });
                }
                    : null,
              ),
            ],
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: product.stock > 0
                  ? () {
                cartController.addToCart(
                  product,
                  quantity,
                );
              }
                  : null,
              icon: const Icon(Icons.shopping_cart_outlined),
              label: Text(
                product.stock > 0
                    ? 'إضافة إلى السلة'
                    : 'المنتج غير متوفر',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C4B99),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 42,
      height: 42,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: const Color(0xFF5C4B99),
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFFF2EFF8),
          disabledForegroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFF2EFF8),
      alignment: Alignment.center,
      child: const Icon(
        Icons.shopping_bag_outlined,
        size: 75,
        color: Color(0xFF9F91CC),
      ),
    );
  }
}
