import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/alert_model.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';
import '../services/settings_service.dart';
import 'alerts_screen.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  Position? _position;
  String? _errorText;
  bool _isLoading = true;
  bool _numberReady = false;

  final LatLng _defaultSriLankaCenter = const LatLng(7.8731, 80.7718);

  @override
  void initState() {
    super.initState();
    _loadLocation();
    _prepareEmergencyNumber();
  }

  Future<void> _prepareEmergencyNumber() async {
    await SettingsService.loadEmergencyNumber();
    if (mounted) {
      setState(() {
        _numberReady = true;
      });
    }
  }

  Future<void> _loadLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (mounted) {
      setState(() {
        _position = position;
        _isLoading = false;
        if (position == null) {
          _errorText = 'Location unavailable. Check your phone settings and grant permission.';
        }
      });
    }
  }

  Future<void> _callEmergency() async {
    final number = SettingsService.emergencyNumber;
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to place call.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<List<AlertModel>>(
      stream: FirestoreService().alertsStream,
      builder: (context, snapshot) {
        // Handle Firestore permission errors
        if (snapshot.hasError) {
          final errorMessage = snapshot.error.toString();
          final isPermissionError = errorMessage.contains('permission') || 
                                   errorMessage.contains('permission-denied');
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sri Lanka Railway Zone Map',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            isPermissionError ? Icons.lock_outline : Icons.error_outline,
                            color: const Color(0xFFDC2626),
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isPermissionError 
                              ? 'Firebase Permission Denied'
                              : 'Error Loading Map',
                            style: const TextStyle(
                              color: Color(0xFFDC2626),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isPermissionError
                              ? 'Your Firestore database does not have read permissions configured. Please update your Firebase security rules to allow authenticated users to read alert data.'
                              : 'Unable to load map data. Please check your Firebase connection.',
                            style: const TextStyle(
                              color: Color(0xFF7F1D1D),
                              fontSize: 13,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final alerts = snapshot.data ?? [];
        final activeAlert = alerts.isNotEmpty ? alerts.first : null;
        final alertLocation = activeAlert != null &&
                activeAlert.latitude != null &&
                activeAlert.longitude != null
            ? LatLng(activeAlert.latitude!, activeAlert.longitude!)
            : null;
        
        final mapCenter = alertLocation ??
            (_position != null
                ? LatLng(_position!.latitude, _position!.longitude)
                : _defaultSriLankaCenter);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sri Lanka Railway Zone Map',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'View alert locations on the rail network and respond to incidents in real time.',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorText!,
                  style: const TextStyle(color: Color(0xFFDC2626)),
                ),
              ],
              const SizedBox(height: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FlutterMap(
                    options: MapOptions(
                      center: mapCenter,
                      zoom: 7.2,
                      minZoom: 5.4,
                      maxZoom: 15,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.elevision.shop_security_app',
                      ),
                      MarkerLayer(
                        markers: [
                          if (_position != null)
                            Marker(
                              width: 40,
                              height: 40,
                              point: LatLng(_position!.latitude, _position!.longitude),
                              builder: (_) => const Icon(
                                Icons.my_location,
                                color: Color(0xFF16A34A),
                                size: 30,
                              ),
                            ),
                          if (alertLocation != null)
                            Marker(
                              width: 48,
                              height: 48,
                              point: alertLocation,
                              builder: (_) => const Icon(
                                Icons.warning_amber_rounded,
                                color: Color(0xFFFFA726),
                                size: 36,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Map Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_position != null) ...[
                      Text(
                        'Your Location',
                        style: const TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lat: ${_position!.latitude.toStringAsFixed(4)}, Lon: ${_position!.longitude.toStringAsFixed(4)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (activeAlert != null) ...[
                      Text(
                        'Active Alert Location',
                        style: const TextStyle(
                          color: Color(0xFFFFA726),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activeAlert.locationName ?? 'Gal Oya Railway Crossing',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lat: ${activeAlert.latitude?.toStringAsFixed(4) ?? "N/A"}, Lon: ${activeAlert.longitude?.toStringAsFixed(4) ?? "N/A"}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ] else
                      const Text(
                        'No active alerts at the moment.',
                        style: TextStyle(color: Color(0xFF6B7280)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _numberReady ? _callEmergency : null,
                      icon: const Icon(Icons.sos),
                      label: Text('Call ${SettingsService.emergencyNumber}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        if (alerts.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AlertsScreen()),
                          );
                        }
                      },
                      icon: const Icon(Icons.list_alt_outlined, color: Color(0xFF1E3A8A)),
                      label: const Text('View Alerts'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E3A8A),
                        side: const BorderSide(color: Color(0xFF1E3A8A)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
