
import 'package:get/get.dart';

import 'product_details_controller.dart';

class ProductDetailsBinding extends Bindings {
  ProductDetailsBinding({
    required this.productId,
  });

  final int productId;

  @override
  void dependencies() {
    Get.lazyPut<ProductDetailsController>(
          () => ProductDetailsController(
        productId: productId,
      ),
    );
  }
}
