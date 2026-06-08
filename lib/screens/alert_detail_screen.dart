import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/alert_model.dart';

class AlertDetailScreen extends StatelessWidget {
  final AlertModel alert;

  const AlertDetailScreen({
    super.key,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'Alert Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full-size alert image
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: alert.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 300,
                    color: const Color(0xFFF3F4F6),
                    child: const Center(
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFFF8C00)),
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 300,
                    color: const Color(0xFFFEE2E2),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Color(0xFFDC2626),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Failed to load image',
                            style: TextStyle(color: Color(0xFFDC2626)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Alert status card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFCD34D),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber, color: Color(0xFFD97706), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Intrusion Alert',
                        style: TextStyle(
                          color: Color(0xFF78350F),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'A person was detected in your shop. Review the image above and take appropriate action.',
                    style: TextStyle(
                      color: Color(0xFF92400E),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Details section
            const Text(
              'Detection Details',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Timestamp card
            _DetailCard(
              icon: Icons.schedule,
              label: 'Detected at',
              value: DateFormat('MMMM dd, yyyy • hh:mm:ss a')
                  .format(alert.timestamp),
            ),
            const SizedBox(height: 10),

            // Confidence card
            _DetailCard(
              icon: Icons.analytics,
              label: 'Confidence Score',
              value: alert.confidencePercent,
              isHighConfidence: alert.confidence > 0.8,
            ),
            const SizedBox(height: 10),

            // Device ID card
            _DetailCard(
              icon: Icons.devices,
              label: 'Device ID',
              value: alert.deviceId,
            ),
            const SizedBox(height: 10),

            if (alert.locationName != null || alert.latitude != null) ...[
              _DetailCard(
                icon: Icons.place,
                label: 'Location',
                value: alert.locationName ??
                    'Lat ${alert.latitude?.toStringAsFixed(4)} ${alert.longitude?.toStringAsFixed(4)}',
              ),
              const SizedBox(height: 10),
            ],

            // Alert ID card
            _DetailCard(
              icon: Icons.fingerprint,
              label: 'Alert ID',
              value: alert.id.substring(0, 8),
            ),

            const SizedBox(height: 24),

            // Confidence info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDEF7FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFF0284C7),
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Understanding Confidence',
                        style: TextStyle(
                          color: Color(0xFF0284C7),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alert.confidence > 0.8
                        ? '${alert.confidencePercent} - High confidence. Likely a real threat.'
                        : '${alert.confidencePercent} - Moderate confidence. Review the image.',
                    style: const TextStyle(
                      color: Color(0xFF0C4A6E),
                      fontSize: 11,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Alert marked as reviewed. Contact police if needed.'),
                          backgroundColor: Color(0xFF16A34A),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text(
                      'Mark as Reviewed',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Alert details saved to device'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download Image'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF8C00),
                      side: const BorderSide(color: Color(0xFFFF8C00), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isHighConfidence;

  const _DetailCard({
    required this.icon,
    required this.label,
    required this.value,
    this.isHighConfidence = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isHighConfidence ? const Color(0xFFDC2626) : const Color(0xFFFF8C00),
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color:
                        isHighConfidence ? const Color(0xFFDC2626) : const Color(0xFF1F2937),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
