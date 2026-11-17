
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_product_controller.dart';
import 'widgets/add_product_form.dart';

class AddProductScreen extends GetView<AddProductController> {
  const AddProductScreen({super.key});

  static const Color primaryColor = Color(0xFF5C4B99);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FA),
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: AddProductForm(),
        ),
      ),
    );
  }
}
