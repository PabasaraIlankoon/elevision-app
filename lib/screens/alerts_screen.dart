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
          final errorMessage = snapshot.error.toString();
          final isPermissionError = errorMessage.contains('permission') || 
                                   errorMessage.contains('permission-denied') ||
                                   errorMessage.contains('PERMISSION_DENIED');
          
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPermissionError ? Icons.lock_outline : Icons.error_outline,
                  size: 48,
                  color: const Color(0xFFDC2626),
                ),
                const SizedBox(height: 16),
                Text(
                  isPermissionError ? 'Permission Denied' : 'Error loading alerts',
                  style: const TextStyle(
                    color: Color(0xFFDC2626),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    isPermissionError 
                      ? 'Your Firebase database does not have proper read permissions configured.\n\nPlease update your Firestore Security Rules to allow reading from your user.\n\nExample rule:\nallow read if request.auth.uid != null;'
                      : errorMessage,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'To fix this:\n1. Go to Firebase Console\n2. Open Firestore Database\n3. Go to Rules tab\n4. Set rules to allow read/write for authenticated users\n5. Publish rules',
                        ),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  },
                  icon: const Icon(Icons.help_outline),
                  label: const Text('Learn More'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                  ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        _HighRiskTrainBadge(alert: alert),
                      ],
                    ),
                    if (alert.locationName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Location: ${alert.locationName}',
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

class _HighRiskTrainBadge extends StatelessWidget {
  final AlertModel alert;

  const _HighRiskTrainBadge({required this.alert});

  @override
  Widget build(BuildContext context) {
    final highRiskTrains = alert.getHighRiskTrainsAtLocation();
    
    if (highRiskTrains.isEmpty) {
      return const SizedBox.shrink();
    }

    final closestTrain = highRiskTrains.first;
    final trainData = closestTrain['train'];
    final minutesAway = closestTrain['minutesAway'] as int;
    final status = minutesAway < 0 
                ? 'Passed'
        : minutesAway == 0 
            ? 'NOW!'
            : minutesAway < 60 ? 'In ${minutesAway}m' : 'Later';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: trainData.riskColor.withOpacity(0.15),
        border: Border.all(color: trainData.riskColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🚂 #${trainData.trainNumber}',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: trainData.riskColor,
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 8,
              color: trainData.riskColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
