# CODE SNIPPETS - QUICK REFERENCE

## 1. COMPACT ALERT CARD CODE

**Location:** `lib/screens/home_screen.dart` lines 140-240

```dart
// Reduced alert card with compact layout
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(14),  // Reduced from 18
  decoration: BoxDecoration(
    color: const Color(0xFF0F172A),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: const Color(0xFFFFA726)),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: const [
          Icon(Icons.signal_cellular_alt,
              color: Color(0xFFFFA726), size: 18),  // Smaller icon
          SizedBox(width: 8),
          Text(
            'ACTIVE ALERT',
            style: TextStyle(
              color: Color(0xFFFFA726),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
              fontSize: 13,  // Smaller font
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      if (activeAlert != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                height: 120,  // REDUCED from 170
                child: activeAlert.imageUrl.isNotEmpty
                    ? Image.network(
                        activeAlert.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: const Color(0xFF1E293B),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white54,
                            size: 30,
                          ),
                        ),
                      ),
              ),
            ),
            // Rest of alert details...
          ],
        )
    ],
  ),
)
```

---

## 2. EMERGENCY SOS - DIRECT CALLING CODE

**Location:** `lib/screens/home_screen.dart` - Device Status Card button

```dart
import 'package:url_launcher/url_launcher.dart';

// Emergency SOS button that dials directly
SizedBox(
  width: double.infinity,
  height: 42,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFDC2626),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    onPressed: () async {
      final emergencyNumber = 
          await SettingsService.loadEmergencyNumber();
      final uri = Uri(scheme: 'tel', path: emergencyNumber);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    },
    child: const Text(
      'EMERGENCY SOS CALL',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
)
```

---

## 3. DEVICE STATUS - NEW LAYOUT

**Location:** `lib/screens/home_screen.dart` lines 310-365

```dart
// Device Status Card - Third image style
Container(
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: const Color(0xFFE5E7EB)),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Device Status',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 12),
      ...trainStatus.map((item) {
        final isOnline = item['status'] != 'Delayed';
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isOnline
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFDC2626),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                isOnline ? 'Online' : 'Offline',
                style: TextStyle(
                  color: isOnline
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFDC2626),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      const SizedBox(height: 12),
      // Emergency SOS Button
      SizedBox(
        width: double.infinity,
        height: 42,
        child: ElevatedButton(
          // ... (see code above)
        ),
      ),
    ],
  ),
)
```

---

## 4. QUICK ACTION BUTTONS CODE

**Location:** `lib/screens/home_screen.dart` - _buildQuickActionButton method

```dart
// Quick Actions Row
Row(
  children: [
    Expanded(
      child: _buildQuickActionButton(
        context,
        'Alert History',
        Icons.history,
        const Color(0xFF1E40AF),
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AlertHistoryScreen(),
            ),
          );
        },
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: _buildQuickActionButton(
        context,
        'Analytics',
        Icons.bar_chart,
        const Color(0xFF059669),
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AnalyticsScreen(),
            ),
          );
        },
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: _buildQuickActionButton(
        context,
        'Train Schedule',
        Icons.train,
        const Color(0xFFFF8C00),
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TrainScheduleScreen(),
            ),
          );
        },
      ),
    ),
  ],
)

// Button widget definition
Widget _buildQuickActionButton(
  BuildContext context,
  String label,
  IconData icon,
  Color color,
  VoidCallback onPressed,
) {
  return Material(
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
```

---

## 5. TRAIN SCHEDULE MODEL

**File:** `lib/models/train_model.dart`

```dart
class TrainStop {
  final String station;
  final String arrival;
  final String departure;

  TrainStop({
    required this.station,
    required this.arrival,
    required this.departure,
  });
}

class TrainSchedule {
  final String trainNumber;
  final String trainName;
  final String route;
  final String riskLevel;
  final List<TrainStop> stops;
  final String direction;

  TrainSchedule({
    required this.trainNumber,
    required this.trainName,
    required this.route,
    required this.riskLevel,
    required this.stops,
    required this.direction,
  });
}

// Example train data
final List<TrainSchedule> highRiskTrains = [
  TrainSchedule(
    trainNumber: '6076',
    trainName: 'Pulathisi',
    route: 'Batticaloa → Colombo',
    riskLevel: 'Very High (early morning)',
    direction: 'Batticaloa → Colombo',
    stops: [
      TrainStop(station: 'Welikanda', arrival: '03:01 AM', departure: '03:02 AM'),
      TrainStop(station: 'Gal Oya Junction', arrival: '~04:35 AM', departure: '~04:37 AM'),
      // ... more stops
    ],
  ),
  // ... more trains
];
```

---

## 6. ALERT HISTORY SCREEN

**File:** `lib/screens/alert_history_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/alert_model.dart';
import '../services/firestore_service.dart';

class AlertHistoryScreen extends StatefulWidget {
  const AlertHistoryScreen({super.key});

  @override
  State<AlertHistoryScreen> createState() => _AlertHistoryScreenState();
}

class _AlertHistoryScreenState extends State<AlertHistoryScreen> {
  String _filterPeriod = 'all';

  DateTime get _filterDate {
    final now = DateTime.now();
    switch (_filterPeriod) {
      case 'today':
        return now.subtract(const Duration(days: 1));
      case 'week':
        return now.subtract(const Duration(days: 7));
      case 'month':
        return now.subtract(const Duration(days: 30));
      default:
        return DateTime(2000);
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreService fs = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert History'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Today', 'today'),
                  const SizedBox(width: 10),
                  _buildFilterChip('Week', 'week'),
                  const SizedBox(width: 10),
                  _buildFilterChip('Month', 'month'),
                  const SizedBox(width: 10),
                  _buildFilterChip('All Time', 'all'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Alert list
            StreamBuilder<List<AlertModel>>(
              stream: fs.alertsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allAlerts = snapshot.data ?? [];
                final filteredAlerts = allAlerts
                    .where((alert) => alert.timestamp.isAfter(_filterDate))
                    .toList();

                // Build alert list items...
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredAlerts.length,
                  itemBuilder: (context, index) {
                    final alert = filteredAlerts[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.notification_important,
                                color: Color(0xFFFF8C00),
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      alert.locationName ?? 'Unknown',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Device: ${alert.deviceId}',
                                      style: const TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Confidence: ${alert.confidencePercent}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF92400E),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Time: ${DateFormat('MMM dd, yyyy - HH:mm:ss').format(alert.timestamp.toLocal())}',
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterPeriod == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _filterPeriod = value);
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF1E40AF),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF6B7280),
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: isSelected
            ? const Color(0xFF1E40AF)
            : const Color(0xFFE5E7EB),
      ),
    );
  }
}
```

---

## 7. ANALYTICS SCREEN - KEY METRICS

**File:** `lib/screens/analytics_screen.dart` (Key section)

```dart
// Key metrics calculation
final allAlerts = snapshot.data ?? [];
final totalAlerts = allAlerts.length;

// Calculate average confidence
final avgConfidence = allAlerts.isEmpty
    ? 0.0
    : allAlerts.fold<double>(0, (sum, alert) => sum + alert.confidence) 
      / allAlerts.length;

// High confidence alerts
final highConfidenceAlerts = allAlerts
    .where((alert) => alert.confidence > 0.8)
    .length;

// Unique locations
final uniqueLocations = allAlerts
    .map((e) => e.locationName)
    .toSet()
    .where((e) => e != null)
    .length;

// Display metrics
Row(
  children: [
    Expanded(
      child: _buildMetricCard(
        'Total Alerts',
        totalAlerts.toString(),
        const Color(0xFF1E40AF),
        Icons.notifications_active,
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: _buildMetricCard(
        'Avg Confidence',
        '${(avgConfidence * 100).toStringAsFixed(1)}%',
        const Color(0xFF059669),
        Icons.trending_up,
      ),
    ),
  ],
)
```

---

## 8. LANGUAGE SETTINGS CODE

**Location:** `lib/services/settings_service.dart`

```dart
class SettingsService {
  static const String _languageKey = 'app_language';
  static String language = 'en';

  static Future<String> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString(_languageKey) ?? 'en';
    return language;
  }

  static Future<void> saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, lang);
    language = lang;
  }
}

// In Settings Tab - Language selector
Row(
  children: [
    Expanded(
      child: _buildLanguageOption('English', 'en'),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: _buildLanguageOption('සිංහල', 'si'),
    ),
  ],
)

Widget _buildLanguageOption(String label, String code) {
  final isSelected = _selectedLanguage == code;
  return GestureDetector(
    onTap: () async {
      await SettingsService.saveLanguage(code);
      setState(() {
        _selectedLanguage = code;
      });
    },
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF1E40AF).withOpacity(0.1)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF1E40AF)
              : const Color(0xFFE5E7EB),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isSelected
                  ? const Color(0xFF1E40AF)
                  : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            code == 'en' ? 'English' : 'Sinhala',
            style: TextStyle(
              fontSize: 11,
              color: isSelected
                  ? const Color(0xFF1E40AF)
                  : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    ),
  );
}
```

---

## 9. ABOUT ELEVISION SECTION

**Location:** `lib/screens/home_screen.dart` - Settings Tab

```dart
Card(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.info_outline, color: Color(0xFF6B7280)),
            SizedBox(width: 10),
            Text(
              'About Elevision',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Elevision - Elephant Guard System',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Real-time AI-powered elephant detection system '
          'for railway safety. Provides live alerts, train '
          'scheduling, and emergency coordination to protect '
          'both wildlife and rail operations.',
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 12,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF0284C7)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Version: 1.0.0',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Build: 2026.06.09',
                style: TextStyle(
                  color: const Color(0xFF0284C7).withOpacity(0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
)
```

---

## 10. TRAIN SCHEDULE DISPLAY

**File:** `lib/screens/train_schedule_screen.dart` - _buildTrainCard method

```dart
Widget _buildTrainCard(TrainSchedule train) {
  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: Column(
      children: [
        // Train header with risk level
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _getRiskColor(train.riskLevel).withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getRiskColor(train.riskLevel),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Train ${train.trainNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      train.trainName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      train.direction,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getRiskColor(train.riskLevel)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  train.riskLevel,
                  style: TextStyle(
                    color: _getRiskColor(train.riskLevel),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Train stops and schedule
        // ... (full schedule display)
      ],
    ),
  );
}

Color _getRiskColor(String riskLevel) {
  if (riskLevel.contains('Very High')) {
    return const Color(0xFFDC2626);  // Red
  } else if (riskLevel.contains('High')) {
    return const Color(0xFFEA580C);  // Orange
  } else {
    return const Color(0xFFFCD34D);  // Yellow
  }
}
```

---

## 11. IMPORTS REQUIRED IN home_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';  // NEW
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/alert_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../services/settings_service.dart';
import 'alerts_screen.dart';
import 'map_screen.dart';
import 'alert_history_screen.dart';      // NEW
import 'analytics_screen.dart';          // NEW
import 'train_schedule_screen.dart';    // NEW
```

---

## 12. PUBSPEC.yaml ADDITIONS

Add to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # ... existing dependencies ...
  url_launcher: ^6.1.0          # For Emergency SOS calling
  intl: ^0.18.0                 # For date formatting in Alert History
```

Then run:
```bash
flutter pub get
```

---

**All code is complete and ready to use!**
