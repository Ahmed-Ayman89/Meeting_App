import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  final locationController =
      TextEditingController(); // إضافة الـ controller هنا

  void _onMapTapped(LatLng latLng) {
    setState(() {
      selectedLatLng = latLng;
      selectedMarker = Marker(
        markerId: MarkerId("selected_location"),
        position: latLng,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Location selected")),
    );

    _openMeetingFormBottomSheet(latLng);
  }

  void _openMeetingFormBottomSheet(LatLng latLng) {
    locationController.text =
        "Lat: ${latLng.latitude}, Lng: ${latLng.longitude}"; // تحديث الحقل هنا
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<MeetingCubit>(),
        child: MeetingFormSheet(
          selectedLatLng: latLng,
          locationController: locationController, // تمرير الـ controller هنا
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: GoogleMap(
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(30.0444, 31.2357),
          zoom: 12,
        ),
        onMapCreated: (controller) => mapController = controller,
        onTap: _onMapTapped,
        markers: selectedMarker != null ? {selectedMarker!} : {},
      ),
    );
  }
}
