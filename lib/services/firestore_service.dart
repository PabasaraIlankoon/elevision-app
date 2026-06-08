import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/alert_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Real-time alert stream - updates instantly when Pi sends alerts
  Stream<List<AlertModel>> get alertsStream {
    return _db
        .collection('alerts')
        .orderBy('timestampMs', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return AlertModel.fromFirestore(
              doc.data(),
              doc.id,
            );
          }).toList();
        });
  }

  // Real-time system status stream
  Stream<bool> get systemArmedStream {
    return _db
        .collection('system')
        .doc('status')
        .snapshots()
        .map((doc) => doc.data()?['armed'] ?? false);
  }

  // ARM the system
  Future<void> setArmed(bool armed) async {
    await _db.collection('system').doc('status').set({
      'armed': armed,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': 'mobile_app',
    }, SetOptions(merge: true));
  }

  // Mark alert as seen
  Future<void> markAlertSeen(String alertId) async {
    await _db.collection('alerts').doc(alertId).update({
      'status': 'seen',
    });
  }

  // Count unseen alerts
  Stream<int> get unseenCountStream {
    return _db
        .collection('alerts')
        .where('status', isEqualTo: 'new')
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  // Get single alert details
  Future<AlertModel?> getAlertDetails(String alertId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection('alerts').doc(alertId).get();
      if (doc.exists) {
        return AlertModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching alert: $e');
      return null;
    }
  }
}
