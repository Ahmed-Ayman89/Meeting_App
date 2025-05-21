import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

import '../manager/meeting_cubit.dart';
import 'widget/meet_form_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? selectedLatLng;
  Marker? selectedMarker;
  loc.LocationData? currentLocation;
  final loc.Location location = loc.Location();
  final locationController = TextEditingController();
  MapType _currentMapType = MapType.normal;
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  bool _isLoading = true;
  bool _isTracking = false;
  StreamSubscription<loc.LocationData>? _locationSubscription;

  // للوقت
  DateTime? _trackingStartTime;
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _timer?.cancel();
    locationController.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    try {
      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          setState(() => _isLoading = false);
          return;
        }
      }

      loc.PermissionStatus _permissionGranted = await location.hasPermission();
      if (_permissionGranted == loc.PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != loc.PermissionStatus.granted) {
          setState(() => _isLoading = false);
          return;
        }
      }

      currentLocation = await location.getLocation();
      _moveCameraToLocation(
        currentLocation?.latitude,
        currentLocation?.longitude,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location error: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _moveCameraToLocation(double? lat, double? lng) {
    if (lat == null || lng == null) return;
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15),
    );
  }

  void _onMapTapped(LatLng latLng) {
    setState(() {
      selectedLatLng = latLng;
      selectedMarker = Marker(
        markerId: const MarkerId("selected_location"),
        position: latLng,
        infoWindow: const InfoWindow(title: "Selected Location"),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Location selected")),
    );

    _openMeetingFormBottomSheet(latLng);
  }

  void _openMeetingFormBottomSheet(LatLng latLng) {
    locationController.text =
        "Lat: ${latLng.latitude.toStringAsFixed(4)}, Lng: ${latLng.longitude.toStringAsFixed(4)}";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<MeetingCubit>(),
        child: MeetingFormSheet(
          selectedLatLng: latLng,
          locationController: locationController,
        ),
      ),
    );
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : _currentMapType == MapType.satellite
              ? MapType.terrain
              : MapType.normal;
    });
  }

  void _toggleTracking() {
    setState(() {
      _isTracking = !_isTracking;
      if (_isTracking) {
        _startTracking();
      } else {
        _stopTracking();
      }
    });
  }

  void _startTracking() {
    _polylineCoordinates.clear();
    _polylines.clear();

    // بدء حساب الوقت
    _trackingStartTime = DateTime.now();
    _elapsedTime = Duration.zero;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime = DateTime.now().difference(_trackingStartTime!);
      });
    });

    _locationSubscription =
        location.onLocationChanged.listen((loc.LocationData currentLoc) {
      final newLatLng = LatLng(currentLoc.latitude!, currentLoc.longitude!);

      setState(() {
        selectedMarker = Marker(
          markerId: const MarkerId("current_location"),
          position: newLatLng,
          infoWindow: const InfoWindow(title: "Your Location"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        );

        // Add to polyline
        _polylineCoordinates.add(newLatLng);
        _polylines.add(
          Polyline(
            polylineId: const PolylineId("tracking_route"),
            points: List.from(_polylineCoordinates),
            color: Colors.blue,
            width: 5,
            geodesic: true,
          ),
        );
      });

      // Move camera smoothly to follow user
      mapController?.animateCamera(
        CameraUpdate.newLatLng(newLatLng),
      );
    });
  }

  void _stopTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;

    _timer?.cancel();

    // Keep the recorded path but clear the current location marker
    setState(() {
      selectedMarker = null;
      _elapsedTime = Duration.zero;
      _trackingStartTime = null;
    });
  }

  void _clearTrackingPath() {
    setState(() {
      _polylineCoordinates.clear();
      _polylines.clear();
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  double _calculateDistance() {
    double totalDistance = 0;
    for (int i = 0; i < _polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        _polylineCoordinates[i].latitude,
        _polylineCoordinates[i].longitude,
        _polylineCoordinates[i + 1].latitude,
        _polylineCoordinates[i + 1].longitude,
      );
    }
    return totalDistance;
  }

  // دالة حساب المسافة بين نقطتين (بـ كيلومتر)
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    const p = 0.017453292519943295; // pi/180
    final a = 0.5 -
        (cos((lat2 - lat1) * p) / 2) +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R * asin...
  }

  @override
  Widget build(BuildContext context) {
    double distance = _calculateDistance();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.layers, color: Colors.black),
            onPressed: _toggleMapType,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: _currentMapType,
            zoomControlsEnabled: false,
            initialCameraPosition: const CameraPosition(
              target: LatLng(30.0444, 31.2357),
              zoom: 12,
            ),
            onMapCreated: (controller) => mapController = controller,
            onTap: _onMapTapped,
            markers: selectedMarker != null ? {selectedMarker!} : {},
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          // عرض المسافة والوقت فوق شمال الشاشة
          if (_isTracking)
            Positioned(
              top: 100,
              left: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Distance: ${distance.toStringAsFixed(2)} km",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Time: ${_formatDuration(_elapsedTime)}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'tracking_fab',
                  onPressed: _toggleTracking,
                  backgroundColor: _isTracking ? Colors.red : Colors.blue,
                  child: Icon(
                    _isTracking ? Icons.stop : Icons.directions_run,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                if (_polylines.isNotEmpty)
                  FloatingActionButton(
                    heroTag: 'clear_fab',
                    onPressed: _clearTrackingPath,
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.clear, color: Colors.white),
                  ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'location_fab',
                  onPressed: () {
                    if (currentLocation != null) {
                      _moveCameraToLocation(
                        currentLocation?.latitude,
                        currentLocation?.longitude,
                      );
                    }
                  },
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),
          if (selectedLatLng != null && !_isTracking)
            Positioned(
              bottom: 165,
              right: 20,
              child: FloatingActionButton(
                heroTag: 'meeting_fab',
                onPressed: () => _openMeetingFormBottomSheet(selectedLatLng!),
                child: const Icon(Icons.add),
              ),
            ),
        ],
      ),
    );
  }
}
