import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/alert_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../services/settings_service.dart';
import 'alerts_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _logout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.logout();
  }

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const DashboardTab(),
      const MapTab(),
      const AlertsContent(),
      SettingsTab(onLogout: _logout),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/icon.jpeg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: const Text('Elevision'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AlertsScreen()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        selectedItemColor: const Color(0xFF1E3A8A),
        unselectedItemColor: const Color(0xFF6B7280),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_gmailerrorred_outlined),
            activeIcon: Icon(Icons.report_gmailerrorred),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService fs = FirestoreService();
    final List<Map<String, String>> trainStatus = [
      {
        'title': 'Colombo–Kandy Express',
        'status': 'On route',
        'detail': 'Speed check active',
      },
      {
        'title': 'Galle Coastal Line',
        'status': 'Stable',
        'detail': 'Monitoring wave impact',
      },
      {
        'title': 'Puttalam Local',
        'status': 'Delayed',
        'detail': 'Slower movement through station',
      },
    ];

    return SafeArea(
      child: StreamBuilder<List<AlertModel>>(
        stream: fs.alertsStream,
        builder: (context, snapshot) {
          final activeAlerts = snapshot.data ?? [];
          final activeAlert = activeAlerts.isNotEmpty ? activeAlerts.first : null;          final alertLat = activeAlert?.latitude;
          final alertLng = activeAlert?.longitude;          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        'assets/icon.jpeg',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Elevision',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Live alerts and train route control',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      DateTime.now().day.toString().padLeft(2, '0') +
                          ' May 2026',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFA726)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.signal_cellular_alt, color: Color(0xFFFFA726)),
                          SizedBox(width: 10),
                          Text(
                            'ACTIVE ALERT ZONE',
                            style: TextStyle(
                              color: Color(0xFFFFA726),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (activeAlert != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(
                                width: double.infinity,
                                height: 170,
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
                                            size: 36,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              activeAlert.locationName ?? 'Gal Oya Railway Crossing',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'DEVICE ID: ${activeAlert.deviceId}',
                              style: const TextStyle(color: Color(0xFF94A3B8)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              alertLat != null && alertLng != null
                                  ? 'LAT/LONG: ${alertLat.toStringAsFixed(4)}, ${alertLng.toStringAsFixed(4)}'
                                  : 'Lat/Long: 7.2211, 81.5764',
                              style: const TextStyle(color: Color(0xFF94A3B8)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'CONFIDENCE: ${activeAlert.confidencePercent}',
                              style: const TextStyle(color: Color(0xFF94A3B8)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'TIME: ${activeAlert.timestamp.toLocal()}',
                              style: const TextStyle(color: Color(0xFF94A3B8)),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'CAUTION: Train operation may be affected.',
                              style: TextStyle(
                                color: Color(0xFFF59E0B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E40AF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AlertsScreen(),
                                    ),
                                  );
                                },
                                child: const Text('ACKNOWLEDGE ALERT'),
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: const [
                            Text(
                              'No active alerts at the moment.',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'All stations are clear and train corridors are normal.',
                              style: TextStyle(color: Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recent detections',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...activeAlerts.take(2).map((alert) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.notifications_active, color: Color(0xFF1E3A8A)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          alert.locationName ?? 'Gal Oya Railway Crossing',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          alert.timestamp.toLocal().toString(),
                                          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          if (activeAlerts.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                              child: const Text(
                                'No recent detections yet. Your system is staying alert.',
                                style: TextStyle(color: Color(0xFF6B7280)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Map View',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 170,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: FlutterMap(
                                  options: MapOptions(
                                    center: const LatLng(7.8731, 80.7718),
                                    zoom: 6.8,
                                    interactiveFlags: 0,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName: 'com.elevision.shop_security_app',
                                    ),
                                    if (alertLat != null && alertLng != null)
                                      MarkerLayer(
                                        markers: [
                                          Marker(
                                            width: 32,
                                            height: 32,
                                            point: LatLng(alertLat, alertLng),
                                            builder: (_) => const Icon(
                                              Icons.location_on,
                                              color: Color(0xFFFF8C00),
                                              size: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'EMERGENCY SOS',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFB91C1C),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFDC2626),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const MapTab()),
                                      );
                                    },
                                    child: const Text('OPEN MAP'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Device Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ...trainStatus.map((item) {
                        final isOnline = item['status'] != 'Delayed';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['title']!,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: isOnline ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                isOnline ? 'Online' : 'Offline',
                                style: TextStyle(
                                  color: isOnline ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const MapTab()),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              'EMERGENCY SOS',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MapTab()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'View Live Map',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class SettingsTab extends StatefulWidget {
  final VoidCallback onLogout;

  const SettingsTab({required this.onLogout, super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final TextEditingController _emergencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentNumber();
  }

  Future<void> _loadCurrentNumber() async {
    final savedNumber = await SettingsService.loadEmergencyNumber();
    _emergencyController.text = savedNumber;
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _emergencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Manage the emergency contact number used by the SOS button and keep your alert flow connected.',
              style: TextStyle(color: Color(0xFF6B7280), height: 1.5),
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline, color: Color(0xFF1E3A8A)),
                title: const Text('Account'),
                subtitle: const Text('Manage your login and notification settings'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Emergency Call Number',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emergencyController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter SOS number',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          await SettingsService.saveEmergencyNumber(_emergencyController.text.trim());
                          if (!mounted) return;
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Emergency number saved.'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Update Number'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications_outlined, color: Color(0xFFFF8C00)),
                title: const Text('Notifications'),
                subtitle: const Text('Receive real-time alerts for new events'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.info_outline, color: Color(0xFF6B7280)),
                title: const Text('App Version'),
                subtitle: const Text('1.0.0'),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                ),
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
