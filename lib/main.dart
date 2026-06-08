<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  await NotificationService().initialize();

  runApp(const ElevisionApp());
}

class ElevisionApp extends StatelessWidget {
  const ElevisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Elevision',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF8C00),
            brightness: Brightness.light,
            primary: const Color(0xFFFF8C00),
            secondary: const Color(0xFF1E3A8A),
            surface: const Color(0xFFFAFAFA),
            error: const Color(0xFFDC2626),
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: const Color(0xFFF6F7FB),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            labelStyle: const TextStyle(color: Color(0xFF6B7280)),
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Color(0xFF4B5563),
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        home: Consumer<AuthService>(
          builder: (context, auth, _) {
            return auth.isLoggedIn ? const HomeScreen() : const LoginScreen();
          },
        ),
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const ElevisionApp());
}

class ElevisionApp extends StatelessWidget {
  const ElevisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elevision',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF3F7FB),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFDF7600),
          secondary: Color(0xFF4DD2A5),
          surface: Color(0xFFFFFFFF),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
          displayLarge: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: -1.1, color: Color(0xFF102A43)),
          displayMedium: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Color(0xFF102A43)),
          titleLarge: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF102A43)),
          bodyLarge: const TextStyle(fontSize: 16, color: Color(0xFF334155)),
          bodyMedium: const TextStyle(fontSize: 14, color: Color(0xFF475569)),
        ),
        cardColor: const Color(0xFFFFFFFF),
        dividerColor: const Color(0xFFE2E8F0),
      ),
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int selectedIndex = 0;

  static final List<Widget> _pages = [
    const DashboardScreen(),
    const MapScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF3F7FB),
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (value) => setState(() => selectedIndex = value),
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFFDF7600),
          unselectedItemColor: const Color(0xFF64748B),
          showUnselectedLabels: true,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Elevision', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[400], letterSpacing: 1.2)),
                        const SizedBox(height: 6),
                        Text('Railway safety command center', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFFD28A), Color(0xFFFF7F79)]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(child: Text('AI', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black))),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const StatusPanel(),
              const SizedBox(height: 24),
              const TrainStatusCard(),
              const SizedBox(height: 24),
              const RainTrackingCard(),
              const SizedBox(height: 24),
              const ActiveAlertCard(),
              const SizedBox(height: 24),
              const EmergencyCallCard(),
              const SizedBox(height: 24),
              const Expanded(child: AlertTimeline()),
            ],
          ),
        ),
      ),
    );
  }
}

class EmergencyCallCard extends StatelessWidget {
  const EmergencyCallCard({super.key});

  static final Uri _emergencyUri = Uri(scheme: 'tel', path: '+94712345678');

  Future<void> _callEmergency(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    if (await canLaunchUrl(_emergencyUri)) {
      await launchUrl(_emergencyUri, mode: LaunchMode.externalApplication);
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text('Unable to place emergency call on this device.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4F3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF8D3D1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
            child: const Icon(Icons.call, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Emergency call SOS', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF0F172A))),
                SizedBox(height: 4),
                Text('Tap to open the phone dialer for urgent railway emergency support.', style: TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.4)),
                SizedBox(height: 4),
                Text('Configured SOS number is available in Settings.', style: TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.4, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _callEmergency(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            ),
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }
}

class StatusPanel extends StatelessWidget {
  const StatusPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: StatTile(title: 'Live Alerts', value: '3', accent: Color(0xFFFFC262))),
        SizedBox(width: 16),
        Expanded(child: StatTile(title: 'Safe Zones', value: '12', accent: Color(0xFF4DD2A5))),
      ],
    );
  }
}

class TrainStatusCard extends StatelessWidget {
  const TrainStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 18, offset: Offset(0, 8))],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Train tracking', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
              ),
              const Text('Live', style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 14),
          const Text('Real-time train location in Sri Lanka with route tracking and live status updates.', style: TextStyle(color: Color(0xFF475569), height: 1.5)),
          const SizedBox(height: 18),
          const _TrainInfoRow(label: 'Train ID', value: 'TE-590'),
          const SizedBox(height: 12),
          const _TrainInfoRow(label: 'ETA', value: '05:12 PM'),
          const SizedBox(height: 12),
          const _TrainInfoRow(label: 'Location', value: 'Near Habarana Junction'),
          const SizedBox(height: 12),
          const _TrainInfoRow(label: 'Speed', value: '68 km/h'),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(child: _TrainStatusChip(label: 'On schedule', color: Color(0xFF4DD2A5))),
              SizedBox(width: 12),
              Expanded(child: _TrainStatusChip(label: 'Signal green', color: Color(0xFFDF7600))),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrainInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _TrainInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
        ),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
      ],
    );
  }
}

class _TrainStatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TrainStatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
    );
  }
}

class RainTrackingCard extends StatelessWidget {
  const RainTrackingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 18, offset: Offset(0, 8))],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rain tracking', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
          const SizedBox(height: 12),
          const Text('Weather-aware detection helps reduce false alarms and improves accuracy during heavy rain.', style: TextStyle(color: Color(0xFF475569), height: 1.5)),
          const SizedBox(height: 18),
          const Row(
            children: [
              _RainStat(label: 'Rain zones', value: '14'),
              SizedBox(width: 16),
              _RainStat(label: 'Accuracy boost', value: '+13%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RainStat extends StatelessWidget {
  final String label;
  final String value;

  const _RainStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, letterSpacing: 0.5)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          ],
        ),
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  final String title;
  final String value;
  final Color accent;

  const StatTile({super.key, required this.title, required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, letterSpacing: 1.25)),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: accent)),
          const SizedBox(height: 8),
          Text('24h status snapshot', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class ActiveAlertCard extends StatelessWidget {
  const ActiveAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 18, offset: Offset(0, 8))],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(child: Text('ELEPHANT DETECTED', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white))),
              ),
              const Spacer(),
              const Text('LIVE', style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 20),
          Text('Gal Oya Railway Crossing', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
          const SizedBox(height: 12),
          Text('14:57:02 • Confidence 92% • RW-001', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 20),
          const Row(
            children: [
              StatusBadge(label: 'Image captured', color: Color(0xFF4DD2A5)),
              SizedBox(width: 10),
              StatusBadge(label: 'Light triggered', color: Color(0xFFDF7600)),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: color.withAlpha(41), borderRadius: BorderRadius.circular(14)),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}

class AlertTimeline extends StatelessWidget {
  const AlertTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      TimelineEvent('Habarana Junction', 'Elephant detected', '20:37', Colors.orange),
      TimelineEvent('Wasgamuwa South', 'Alert cleared', '20:18', Colors.green),
      TimelineEvent('Minneriya Track', 'High confidence detection', '19:30', Colors.red),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent activity', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) => TimelineTile(event: items[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineEvent {
  final String location;
  final String detail;
  final String time;
  final Color color;

  TimelineEvent(this.location, this.detail, this.time, this.color);
}

class TimelineTile extends StatelessWidget {
  final TimelineEvent event;

  const TimelineTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: event.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.location, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
              const SizedBox(height: 4),
              Text(event.detail, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        Text(event.time, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
      ],
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static final LatLng _phoneLocation = LatLng(6.9271, 79.8612);
  static final LatLng _sriLankaCenter = LatLng(7.8731, 80.7718);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Live zone map', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)))),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.location_searching, color: Color(0xFF475569))),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: FlutterMap(
                    options: MapOptions(
                      center: _sriLankaCenter,
                      zoom: 7,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.elephant_railway_alerts',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 48,
                            height: 48,
                            point: _phoneLocation,
                            builder: (context) => const Icon(Icons.my_location, color: Color(0xFFEF4444), size: 32),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                padding: const EdgeInsets.all(18),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                    SizedBox(height: 8),
                    Text('Colombo, Sri Lanka', style: TextStyle(fontSize: 14, color: Color(0xFF475569))),
                    SizedBox(height: 6),
                    Text('Lat: 6.9271, Lon: 79.8612', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const DeviceStatusSummary(),
            ],
          ),
        ),
      ),
    );
  }
}

class DeviceStatusSummary extends StatelessWidget {
  const DeviceStatusSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final devices = [
      DeviceStatus('RW-001', 'Gal Oya', 'Online', '1m ago', Colors.green),
      DeviceStatus('RW-002', 'Habarana', 'Online', '2m ago', Colors.green),
      DeviceStatus('RW-003', 'Minneriya', 'Online', '10m ago', Colors.green),
      DeviceStatus('RW-005', 'Wasgamuwa', 'Online', '12m ago', Colors.green),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Device status', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          ...devices.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.zone, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                        const SizedBox(height: 4),
                        Text(item.id, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(item.status, style: TextStyle(color: item.color, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(item.lastSeen, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class DeviceStatus {
  final String id;
  final String zone;
  final String status;
  final String lastSeen;
  final Color color;

  DeviceStatus(this.id, this.zone, this.status, this.lastSeen, this.color);
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = [
      HistoryEvent('Gal Oya Railway Crossing', '2026-06-07 20:45', '92%', 'RW-001'),
      HistoryEvent('Habarana Junction', '2026-06-07 20:37', '88%', 'RW-002'),
      HistoryEvent('Caudulla Bridge East', '2026-06-07 20:01', '99%', 'RW-004'),
      HistoryEvent('Minneriya Track Zone', '2026-06-07 19:30', '97%', 'RW-003'),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detection history', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: history.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) => HistoryTile(event: history[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryEvent {
  final String location;
  final String timestamp;
  final String confidence;
  final String device;

  HistoryEvent(this.location, this.timestamp, this.confidence, this.device);
}

class HistoryTile extends StatelessWidget {
  final HistoryEvent event;

  const HistoryTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(event.location, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)))),
              Text(event.confidence, style: const TextStyle(color: Color(0xFFDF7600), fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          Text(event.timestamp, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          const SizedBox(height: 6),
          Text('Device ${event.device}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(radius: 30, backgroundColor: Color(0xFFFFC262), child: Text('A', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 24))),
                    SizedBox(width: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Administrator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                        SizedBox(height: 4),
                        Text('controller@trackguard.ai', style: TextStyle(color: Color(0xFF64748B))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              _profileItem('Push alerts', 'Enabled'),
              _profileItem('Live sync', 'Active'),
              _profileItem('Zone geofencing', 'Configured'),
              const SizedBox(height: 24),
              const Text('Emergency settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              _profileItem('Emergency SOS number', '+94 71 234 5678'),
              _profileItem('Available support', 'Sri Lanka railway line'),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DD2A5),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Export Alert Log', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, color: Color(0xFF0F172A))),
          Text(value, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
        ],
      ),
    );
  }
}
>>>>>>> 50fbc4deea5ac5dd3823ab6e6e54d43eff8b34b3
