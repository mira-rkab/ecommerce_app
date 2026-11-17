
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/app_constants.dart';

class AdminController extends GetxController {
  final GetStorage storage = GetStorage();

  String get adminName =>
      storage.read(AppConstants.userNameKey) ?? 'المدير';

  String get adminEmail =>
      storage.read(AppConstants.userEmailKey) ?? '';
}