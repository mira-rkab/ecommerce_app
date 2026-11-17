
import 'package:get/get.dart';
import 'manage_orders_controller.dart';

class ManageOrdersBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ManageOrdersController>()) {
      Get.lazyPut<ManageOrdersController>(
            () => ManageOrdersController(),
      );
    }
  }
}
