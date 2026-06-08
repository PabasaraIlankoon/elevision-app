import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import '../models/alert_model.dart';
import 'alert_detail_screen.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Alert History'),
      ),
      body: const AlertsContent(),
    );
  }
}

class AlertsContent extends StatelessWidget {
  const AlertsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService fs = FirestoreService();

    return StreamBuilder<List<AlertModel>>(
      stream: fs.alertsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: const Color(0x99DC2626),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Error loading alerts',
                  style: TextStyle(
                    color: Color(0xFFDC2626),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final alerts = snapshot.data ?? [];
        if (alerts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF8FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No alerts yet',
                  style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your system is monitoring the Sri Lanka network and waiting for new detections.',
                  style: TextStyle(color: Color(0xFF6B7280)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            final alert = alerts[index];
            return _AlertCard(
              alert: alert,
              onTap: () {
                fs.markAlertSeen(alert.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AlertDetailScreen(alert: alert),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _AlertCard extends StatelessWidget {
  final AlertModel alert;
  final VoidCallback onTap;

  const _AlertCard({required this.alert, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: alert.isNew ? const Color(0xFFFF8C00) : const Color(0xFFE5E7EB),
            width: alert.isNew ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: alert.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 100,
                  height: 100,
                  color: const Color(0xFFF3F4F6),
                  child: const Icon(
                    Icons.image_outlined,
                    color: Color(0xFFD1D5DB),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  color: const Color(0xFFFEE2E2),
                  child: const Icon(Icons.broken_image, color: Color(0xFFDC2626)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (alert.isNew)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF8C00),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const Icon(
                          Icons.warning_amber,
                          color: Color(0xFFFB923C),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Threat detected',
                            style: TextStyle(
                              color: Color(0xFF1F2937),
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateFormat('MMM dd, yyyy • hh:mm a').format(alert.timestamp),
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Device: ${alert.deviceId}',
                      style: const TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: alert.confidence > 0.8
                            ? const Color(0xFFFEE2E2)
                            : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Confidence: ${alert.confidencePercent}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: alert.confidence > 0.8
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.chevron_right, color: Color(0xFFD1D5DB)),
            ),
          ],
        ),
      ),
    );
  }
}
