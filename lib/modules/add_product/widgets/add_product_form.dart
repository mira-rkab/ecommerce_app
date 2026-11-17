
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../add_product_controller.dart';

class AddProductForm extends GetView<AddProductController> {
  const AddProductForm({super.key});

  static const Color primaryColor = Color(0xFF5C4B99);
  static const Color secondaryColor = Color(0xFF9F91CC);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildField(
            label: 'Product Name',
            hint: 'Enter product name',
            icon: Icons.shopping_bag_outlined,
            textController: controller.nameController,
          ),
          const SizedBox(height: 18),

          _buildField(
            label: 'Description',
            hint: 'Enter product description',
            icon: Icons.description_outlined,
            textController: controller.descriptionController,
            maxLines: 4,
          ),
          const SizedBox(height: 18),

          _buildField(
            label: 'Price',
            hint: 'Enter product price',
            icon: Icons.attach_money,
            textController: controller.priceController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d*\.?\d*'),
              ),
            ],
          ),
          const SizedBox(height: 18),

          _buildField(
            label: 'Stock',
            hint: 'Enter available quantity',
            icon: Icons.inventory_2_outlined,
            textController: controller.stockController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          const SizedBox(height: 18),

          _buildField(
            label: 'Category',
            hint: 'Enter product category',
            icon: Icons.category_outlined,
            textController: controller.categoryController,
          ),
          const SizedBox(height: 28),

          Obx(
                () => SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.addProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                  height: 23,
                  width: 23,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
                    : const Text(
                  'Add Product',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController textController,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textController,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }

            if (label == 'Price') {
              final price = double.tryParse(value.trim());
              if (price == null || price <= 0) {
                return 'Enter a valid price greater than zero';
              }
            }

            if (label == 'Stock') {
              final stock = int.tryParse(value.trim());
              if (stock == null || stock < 0) {
                return 'Enter a valid quantity';
              }
            }

            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: primaryColor),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: primaryColor,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
