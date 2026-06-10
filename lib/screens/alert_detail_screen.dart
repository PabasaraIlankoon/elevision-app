import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../models/alert_model.dart';
import '../models/train_model.dart';

class AlertDetailScreen extends StatelessWidget {
  final AlertModel alert;
  const AlertDetailScreen({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    // Get trains approaching this alert location
    final locationName = alert.locationName ?? '';
    final approachingTrains = TrainData.getApproachingTrains(
      locationName,
      windowMinutes: 60,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Alert Details',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Detection Image ──────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                height: 220,
                child: alert.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: alert.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: const Color(0xFFF3F4F6),
                          child: const Center(
                              child: CircularProgressIndicator()),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: const Color(0xFFFEE2E2),
                          child: const Center(
                            child: Icon(Icons.broken_image,
                                size: 48, color: Color(0xFFDC2626)),
                          ),
                        ),
                      )
                    : Container(
                        color: const Color(0xFF1E293B),
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              size: 48, color: Colors.white38),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Elephant Alert banner ────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFCD34D)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber,
                      color: Color(0xFFD97706), size: 22),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Elephant Alert',
                          style: TextStyle(
                              color: Color(0xFF78350F),
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      Text('Elephant Detected',
                          style: TextStyle(
                              color: Color(0xFF92400E), fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Detection Details ────────────────────────────────
            const Text('Detection Details',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _DetailCard(
                icon: Icons.schedule,
                label: 'Detected at',
                value: DateFormat('MMMM dd, yyyy • hh:mm:ss a')
                    .format(alert.timestamp)),
            const SizedBox(height: 8),
            _DetailCard(
                icon: Icons.analytics,
                label: 'Confidence Score',
                value: alert.confidencePercent,
                isHighConfidence: alert.confidence > 0.8),
            const SizedBox(height: 8),
            _DetailCard(
                icon: Icons.devices,
                label: 'Device ID',
                value: alert.deviceId),
            const SizedBox(height: 8),
            if (alert.locationName != null)
              _DetailCard(
                  icon: Icons.place,
                  label: 'Location',
                  value: alert.locationName!),
            const SizedBox(height: 8),
            if (alert.latitude != null && alert.longitude != null)
              _DetailCard(
                  icon: Icons.gps_fixed,
                  label: 'Coordinates',
                  value:
                      '${alert.latitude!.toStringAsFixed(4)}, ${alert.longitude!.toStringAsFixed(4)}'),
            const SizedBox(height: 8),
            _DetailCard(
                icon: Icons.fingerprint,
                label: 'Alert ID',
                value: alert.id.length > 8
                    ? alert.id.substring(0, 8)
                    : alert.id),
            const SizedBox(height: 16),

            // ── ZOOMED MAP of detection location ────────────────
            if (alert.latitude != null && alert.longitude != null) ...[
              const Text('Detection Location',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: double.infinity,
                  height: 220,
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(
                          alert.latitude!, alert.longitude!),
                      zoom: 14.0, // ← zoomed in close
                      interactiveFlags:
                          InteractiveFlag.pinchZoom |
                          InteractiveFlag.drag,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'com.elevision.shop_security_app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 50,
                            height: 50,
                            point: LatLng(
                                alert.latitude!, alert.longitude!),
                            builder: (_) => Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF8C00)
                                    .withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color(0xFFFF8C00),
                                    width: 2),
                              ),
                              child: const Icon(
                                Icons.warning_amber_rounded,
                                color: Color(0xFFFF8C00),
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Nearest High-Risk Train at Alert Time ────────────
            ..._buildNearestHighRiskTrain(),
            const SizedBox(height: 16),

            // ── Train Risk Section ───────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFED7AA)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.train, color: Color(0xFFEA580C)),
                      SizedBox(width: 8),
                      Text('Train Risk Assessment',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF7C2D12))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (approachingTrains.isEmpty)
                    const Text(
                      'No trains approaching this location within 1 hour.',
                      style: TextStyle(
                          color: Color(0xFF16A34A), fontSize: 13),
                    )
                  else
                    ...approachingTrains.map((entry) {
                      final TrainSchedule train = entry['train'];
                      final int mins = entry['minutesAway'];
                      final isApproaching = mins > 0;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: train.riskColor.withOpacity(0.4)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: train.riskColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Train\n${train.trainNumber}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    train.trainName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    train.direction,
                                    style: const TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isApproaching
                                    ? const Color(0xFFFEE2E2)
                                    : const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isApproaching
                                    ? '${mins}m away'
                                    : 'Passed',
                                style: TextStyle(
                                  color: isApproaching
                                      ? const Color(0xFFDC2626)
                                      : const Color(0xFF6B7280),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Confidence info ──────────────────────────────────
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
                      Icon(Icons.info_outline,
                          color: Color(0xFF0284C7), size: 18),
                      SizedBox(width: 8),
                      Text('Understanding Confidence',
                          style: TextStyle(
                              color: Color(0xFF0284C7),
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    alert.confidence > 0.8
                        ? '${alert.confidencePercent} - High confidence. Likely a real threat.'
                        : '${alert.confidencePercent} - Moderate confidence. Review the image.',
                    style: const TextStyle(
                        color: Color(0xFF0C4A6E),
                        fontSize: 11,
                        height: 1.6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Action buttons ───────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alert marked as reviewed.'),
                      backgroundColor: Color(0xFF16A34A),
                    ),
                  );
                },
                icon: const Icon(Icons.check),
                label: const Text('Mark as Reviewed',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text('Download Image'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF8C00),
                  side: const BorderSide(
                      color: Color(0xFFFF8C00), width: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Get nearest high-risk train at the alert time
  List<Widget> _buildNearestHighRiskTrain() {
    final locationName = alert.locationName ?? '';
    final highRiskTrains =
        TrainData.getHighRiskTrainsAtLocation(locationName);

    if (highRiskTrains.isEmpty) {
      return [];
    }

    // Find the train with arrival time closest to alert time
    TrainSchedule? nearestTrain;
    int? minutesFromAlert;

    for (final entry in highRiskTrains) {
      final train = entry['train'] as TrainSchedule;
      final minutesAway = entry['minutesAway'] as int;

      if (nearestTrain == null || minutesAway.abs() < minutesFromAlert!.abs()) {
        nearestTrain = train;
        minutesFromAlert = minutesAway;
      }
    }

    if (nearestTrain == null) {
      return [];
    }

    return [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEAE5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFF7043)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.train_rounded,
                    color: Color(0xFFD84315), size: 22),
                SizedBox(width: 8),
                Text('Critical High-Risk Train',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFFBF360C))),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: nearestTrain.riskColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: nearestTrain.riskColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Train ${nearestTrain.trainNumber}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          nearestTrain.trainName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nearestTrain.direction,
                    style: const TextStyle(
                        color: Color(0xFF616161), fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: minutesFromAlert! < 0
                          ? const Color(0xFFFCE4EC)
                          : const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      minutesFromAlert < 0
                          ? 'Passed ${minutesFromAlert.abs()} minutes ago'
                          : 'Arriving in ${minutesFromAlert} minutes',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: minutesFromAlert < 0
                              ? const Color(0xFFAD1457)
                              : const Color(0xFFE65100)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
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
          Icon(icon,
              color: isHighConfidence
                  ? const Color(0xFFDC2626)
                  : const Color(0xFFFF8C00),
              size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value,
                    style: TextStyle(
                        color: isHighConfidence
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF1F2937),
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
