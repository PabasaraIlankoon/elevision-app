class AlertModel {
  final String id;
  final DateTime timestamp;
  final String imageUrl;
  final double confidence;
  final String deviceId;
  final bool isNew;
  final String? locationName;
  final double? latitude;
  final double? longitude;

  AlertModel({
    required this.id,
    required this.timestamp,
    required this.imageUrl,
    required this.confidence,
    required this.deviceId,
    required this.isNew,
    this.locationName,
    this.latitude,
    this.longitude,
  });

  // Convert Firestore document to AlertModel object
  factory AlertModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AlertModel(
      id: id,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        data['timestampMs'] ?? 0,
      ),
      imageUrl: data['imageUrl'] ?? '',
      confidence: (data['confidence'] ?? 0.0).toDouble(),
      deviceId: data['deviceId'] ?? 'unknown',
      isNew: data['status'] == 'new',
      locationName: data['locationName'] as String?,
      latitude: data['latitude'] != null ? (data['latitude'] as num).toDouble() : null,
      longitude: data['longitude'] != null ? (data['longitude'] as num).toDouble() : null,
    );
  }

  String get confidencePercent => '${(confidence * 100).toStringAsFixed(0)}%';
}
