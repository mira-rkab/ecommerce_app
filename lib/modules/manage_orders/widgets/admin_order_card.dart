
import 'package:flutter/material.dart';
import '../manage_orders_controller.dart';

class AdminOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final ManageOrdersController controller;

  const AdminOrderCard({
    super.key,
    required this.order,
    required this.controller,
  });

  static const Color primaryColor = Color(0xFF5C4B99);

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'processing':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = int.tryParse(order['id'].toString()) ?? 0;
    final status = order['status']?.toString() ?? 'pending';
    final customer = controller.customerName(order);
    final total = order['total_price']?.toString() ?? '0';
    final date = order['created_at']?.toString() ?? '';

    final isUpdating = controller.updatingOrderId.value == id;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.receipt_long,
                  color: primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'الطلب رقم #$id',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    controller.statusText(status),
                    style: TextStyle(
                      color: _statusColor(status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            _infoRow(Icons.person_outline, 'العميل', customer),
            const SizedBox(height: 10),
            _infoRow(Icons.payments_outlined, 'المبلغ', '$total'),
            const SizedBox(height: 10),
            _infoRow(Icons.calendar_today_outlined, 'التاريخ', date),

            const SizedBox(height: 16),

            const Text(
              'تغيير حالة الطلب',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: [
                'pending',
                'processing',
                'completed',
                'cancelled',
              ].contains(status.toLowerCase())
                  ? status.toLowerCase()
                  : 'pending',
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'pending',
                  child: Text('قيد الانتظار'),
                ),
                DropdownMenuItem(
                  value: 'processing',
                  child: Text('قيد المعالجة'),
                ),
                DropdownMenuItem(
                  value: 'completed',
                  child: Text('مكتمل'),
                ),
                DropdownMenuItem(
                  value: 'cancelled',
                  child: Text('ملغي'),
                ),
              ],
              onChanged: isUpdating
                  ? null
                  : (newStatus) {
                if (newStatus == null ||
                    newStatus == status.toLowerCase()) {
                  return;
                }

                controller.updateStatus(
                  orderId: id,
                  status: newStatus,
                );
              },
            ),

            if (isUpdating) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(
                color: primaryColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 19, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          '$title:',
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
