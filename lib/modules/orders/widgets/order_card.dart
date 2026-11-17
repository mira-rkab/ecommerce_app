

import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final String statusText;

  const OrderCard({
    super.key,
    required this.order,
    required this.statusText,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;

      case 'processing':
        return Colors.blue;

      case 'cancelled':
        return Colors.red;

      case 'pending':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = order['id']?.toString() ?? '-';

    final status = order['status']?.toString() ?? '';

    final total = double.tryParse(
      order['total_price']?.toString() ?? '0',
    ) ??
        0;

    final createdAt = order['created_at']?.toString();

    String formattedDate = 'غير محدد';

    if (createdAt != null) {
      final date = DateTime.tryParse(createdAt);

      if (date != null) {
        formattedDate =
        '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
      }
    }

    final orderItems = order['items'];

    final hasItems =
        orderItems is List && orderItems.isNotEmpty;

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
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طلب رقم #$id',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: _statusColor(status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: Color(0xFF9F91CC),
                ),
                const SizedBox(width: 8),
                Text(
                  'تاريخ الطلب: $formattedDate',
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 19,
                  color: Color(0xFF9F91CC),
                ),
                const SizedBox(width: 8),
                Text(
                  'الإجمالي: ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (hasItems)
              Text(
                'عدد المنتجات: ${orderItems.length}',
                style: const TextStyle(
                  color: Colors.black54,
                ),
              )
            else
              const Text(
                'تفاصيل المنتجات غير متاحة حالياً',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
