import 'dart:async';

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
  double _trainProgress = 0.0;
  Timer? _trainTimer;
  bool _numberReady = false;

  final List<LatLng> _routePoints = [
    const LatLng(6.9319, 79.8478),
    const LatLng(7.2906, 80.6337),
    const LatLng(6.9497, 80.7890),
    const LatLng(6.0320, 80.2165),
  ];

  final List<String> _stationLabels = [
    'Colombo Fort',
    'Kandy Station',
    'Nuwara Eliya',
    'Galle Line',
  ];

  @override
  void initState() {
    super.initState();
    _loadLocation();
    _startTrainSimulation();
    _prepareEmergencyNumber();
  }

  @override
  void dispose() {
    _trainTimer?.cancel();
    super.dispose();
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
          _errorText =
              'Location unavailable. Check your phone settings and grant permission.';
        }
      });
    }
  }

  void _startTrainSimulation() {
    _trainTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        _trainProgress += 0.08;
        if (_trainProgress > 1.0) {
          _trainProgress = 0.0;
        }
      });
    });
  }

  LatLng get _defaultSriLankaCenter => const LatLng(7.8731, 80.7718);

  LatLng get _trainPosition {
    final totalSegments = _routePoints.length - 1;
    final progress = (_trainProgress * totalSegments).clamp(0.0, totalSegments.toDouble());
    final currentSegment = progress.floor();
    final segmentFraction = progress - currentSegment;
    if (currentSegment >= _routePoints.length - 1) {
      return _routePoints.last;
    }
    final start = _routePoints[currentSegment];
    final end = _routePoints[currentSegment + 1];
    return LatLng(
      start.latitude + (end.latitude - start.latitude) * segmentFraction,
      start.longitude + (end.longitude - start.longitude) * segmentFraction,
    );
  }

  int get _passedStations {
    return (_trainProgress * (_stationLabels.length - 1)).floor().clamp(0, _stationLabels.length - 1);
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
                'Sri Lanka Train Tracking',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Follow active trains on the rail network, see stations passed, and respond to alerts in real time.',
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
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _routePoints,
                            color: const Color(0xFFFF8C00),
                            strokeWidth: 4,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          ..._routePoints.map(
                            (point) => Marker(
                              width: 34,
                              height: 34,
                              point: point,
                              builder: (_) => const Icon(
                                Icons.location_on,
                                color: Color(0xFF1E3A8A),
                                size: 26,
                              ),
                            ),
                          ),
                          Marker(
                            width: 48,
                            height: 48,
                            point: _trainPosition,
                            builder: (_) => const Icon(
                              Icons.train,
                              color: Color(0xFFDC2626),
                              size: 34,
                            ),
                          ),
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
                              width: 40,
                              height: 40,
                              point: alertLocation,
                              builder: (_) => const Icon(
                                Icons.warning_amber_rounded,
                                color: Color(0xFFFFA726),
                                size: 34,
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
                      'Train Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Current route: Colombo Fort → Kandy Station → Nuwara Eliya → Galle Line',
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: _trainProgress,
                      color: const Color(0xFF1E3A8A),
                      backgroundColor: const Color(0xFFE5E7EB),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Next station: ${_stationLabels[(_passedStations + 1).clamp(0, _stationLabels.length - 1)]}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${(_trainProgress * 100).round()}% complete',
                          style: const TextStyle(color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _stationLabels.asMap().entries.map((entry) {
                        final index = entry.key;
                        final label = entry.value;
                        final passed = index <= _passedStations;
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                          decoration: BoxDecoration(
                            color: passed ? const Color(0xFFE0F2FE) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: passed ? const Color(0xFF0EA5E9) : const Color(0xFFCBD5E1),
                            ),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: passed ? const Color(0xFF0369A1) : const Color(0xFF475569),
                              fontWeight: passed ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              if (activeAlert != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFCC9A6)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Color(0xFFE67719)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Active alert at ${activeAlert.locationName ?? 'Gal Oya'}',
                          style: const TextStyle(
                            color: Color(0xFF9A3412),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                        if (activeAlert != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AlertsScreen()),
                          );
                        }
                      },
                      icon: const Icon(Icons.map_outlined, color: Color(0xFF1E3A8A)),
                      label: const Text('View Alert'),
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
