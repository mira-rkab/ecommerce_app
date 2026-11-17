

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  static const Color primaryColor = Color(0xFF5C4B99);
  static const Color backgroundColor = Color(0xFFF8F7FB);

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value.isEmpty ? 'غير متوفر' : value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value &&
          controller.user.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        );
      }

      if (controller.user.isEmpty &&
          controller.errorMessage.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 45,
                ),
                const SizedBox(height: 12),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchProfile,
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        );
      }

      final name = controller.user['name']?.toString() ?? '';
      final email = controller.user['email']?.toString() ?? '';
      final id = controller.user['id']?.toString() ?? '';

      return RefreshIndicator(
        color: primaryColor,
        onRefresh: controller.fetchProfile,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 12),

            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: primaryColor.withOpacity(0.12),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            Center(
              child: Text(
                name.isEmpty ? 'المستخدم' : name,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 6),

            Center(
              child: Text(
                controller.roleText,
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'معلومات الحساب',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            _buildInfoTile(
              icon: Icons.person_outline,
              title: 'الاسم',
              value: name,
            ),

            _buildInfoTile(
              icon: Icons.email_outlined,
              title: 'البريد الإلكتروني',
              value: email,
            ),

            _buildInfoTile(
              icon: Icons.badge_outlined,
              title: 'رقم الحساب',
              value: id,
            ),

            _buildInfoTile(
              icon: Icons.admin_panel_settings_outlined,
              title: 'نوع الحساب',
              value: controller.roleText,
            ),

            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: controller.fetchProfile,
              icon: const Icon(Icons.refresh),
              label: const Text('تحديث البيانات'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Obx(
                  () => ElevatedButton.icon(
                onPressed: controller.isLoggingOut.value
                    ? null
                    : controller.logout,
                icon: controller.isLoggingOut.value
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.logout),
                label: Text(
                  controller.isLoggingOut.value
                      ? 'جارٍ تسجيل الخروج...'
                      : 'تسجيل الخروج',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }
}
