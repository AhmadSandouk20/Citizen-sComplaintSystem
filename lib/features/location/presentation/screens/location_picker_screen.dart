import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/di/injector.dart';
import '../../data/services/reverse_geocoding_service.dart';

class LocationPickerResult {
  final double latitude;
  final double longitude;
  final String address;

  const LocationPickerResult({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class LocationPickerScreen extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final String? initialAddress;

  const LocationPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.initialAddress,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final MapController _mapController = MapController();

  final ReverseGeocodingService _reverseGeocodingService =
      getIt<ReverseGeocodingService>();

  LatLng? _selectedLocation;

  String? _selectedAddress;

  bool _isGettingCurrentLocation = false;
  bool _isLoadingAddress = false;

  static const LatLng _defaultLocation = LatLng(33.5138, 36.2765);

  @override
  void initState() {
    super.initState();

    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selectedLocation = LatLng(
        widget.initialLatitude!,
        widget.initialLongitude!,
      );
    } else {
      _selectedLocation = _defaultLocation;
    }

    _selectedAddress = widget.initialAddress;
  }

  Future<void> _selectLocation(LatLng location) async {
    setState(() {
      _selectedLocation = location;
      _isLoadingAddress = true;
    });

    try {
      final address = await _reverseGeocodingService.getAddress(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedAddress = address;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _selectedAddress = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديد الموقع، لكن تعذر جلب اسم العنوان'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAddress = false;
        });
      }
    }
  }

  Future<void> _goToCurrentLocation() async {
    setState(() {
      _isGettingCurrentLocation = true;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('يرجى تفعيل خدمة الموقع')));

        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم رفض صلاحية الموقع')));

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'صلاحية الموقع مرفوضة بشكل دائم. يرجى تفعيلها من الإعدادات.',
            ),
          ),
        );

        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final currentLocation = LatLng(position.latitude, position.longitude);

      if (!mounted) {
        return;
      }

      _mapController.move(currentLocation, 16);

      await _selectLocation(currentLocation);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر الحصول على الموقع الحالي')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGettingCurrentLocation = false;
        });
      }
    }
  }

  Future<void> _confirmLocation() async {
    final location = _selectedLocation;

    if (location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار موقع على الخريطة')),
      );

      return;
    }

    String? address = _selectedAddress;

    if (address == null || address.trim().isEmpty) {
      setState(() {
        _isLoadingAddress = true;
      });

      try {
        address = await _reverseGeocodingService.getAddress(
          latitude: location.latitude,
          longitude: location.longitude,
        );
      } catch (_) {
        address = null;
      } finally {
        if (mounted) {
          setState(() {
            _isLoadingAddress = false;
          });
        }
      }
    }

    if (!mounted) {
      return;
    }

    if (address == null || address.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر الحصول على اسم العنوان، حاول اختيار موقع آخر'),
        ),
      );

      return;
    }

    Navigator.of(context).pop(
      LocationPickerResult(
        latitude: location.latitude,
        longitude: location.longitude,
        address: address.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedLocation = _selectedLocation ?? _defaultLocation;

    return Scaffold(
      appBar: AppBar(title: const Text('تحديد الموقع')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: selectedLocation,
              initialZoom: 14,
              onTap: (_, point) {
                _selectLocation(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.final_flutter',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: selectedLocation,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.location_pin,
                      size: 48,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            right: 16,
            top: 16,
            child: FloatingActionButton.small(
              heroTag: 'current-location',
              onPressed: _isGettingCurrentLocation
                  ? null
                  : _goToCurrentLocation,
              child: _isGettingCurrentLocation
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 90,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: _isLoadingAddress
                    ? const Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Expanded(child: Text('جارٍ تحديد اسم الموقع...')),
                        ],
                      )
                    : Text(
                        _selectedAddress ?? 'اضغط على الخريطة لاختيار الموقع',
                      ),
              ),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: ElevatedButton.icon(
              onPressed: _isLoadingAddress ? null : _confirmLocation,
              icon: const Icon(Icons.check),
              label: const Text('تأكيد الموقع'),
            ),
          ),
        ],
      ),
    );
  }
}
