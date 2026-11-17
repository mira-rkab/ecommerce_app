

import 'package:get/get.dart';
import 'orders_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<OrdersController>()) {
      Get.lazyPut<OrdersController>(
            () => OrdersController(),
      );
    }
  }
}
