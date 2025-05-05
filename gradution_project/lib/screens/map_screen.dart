// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:gradution_project/core/utils/App_color.dart';
// import 'package:geocoding/geocoding.dart';

// import 'contact_info.dart'; // 📍 مهم جداً

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});

//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController? mapController;
//   LatLng? _selectedLocation;
//   String? _address; // 🆕 علشان نجيب العنوان

//   final MarkerId _selectedMarkerId = MarkerId('selected_location');
//   Set<Marker> _markers = {};

//   // 🆕 دالة تجيب العنوان من الاحداثيات
//   Future<void> _getAddressFromLatLng(LatLng position) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
//       Placemark place = placemarks[0];

//       setState(() {
//         _address = "${place.street}, ${place.locality}, ${place.country}";
//       });
//     } catch (e) {
//       print('Error getting address: $e');
//       setState(() {
//         _address = "Unknown location";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           color: AppColor.black,
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back),
//         ),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             zoomControlsEnabled: false,
//             initialCameraPosition: const CameraPosition(
//               target: LatLng(30.0444, 31.2357),
//               zoom: 12,
//             ),
//             markers: _markers,
//             onMapCreated: (GoogleMapController controller) {
//               mapController = controller;
//             },
//             onTap: (LatLng latLng) {
//               setState(() {
//                 _selectedLocation = latLng;
//                 _markers = {
//                   Marker(
//                     markerId: _selectedMarkerId,
//                     position: latLng,
//                     infoWindow: const InfoWindow(title: 'Selected Location'),
//                   ),
//                 };
//               });
//               _getAddressFromLatLng(latLng); // 🆕 نجيب العنوان لما نضغط
//             },
//           ),

//           // الزرار فوق الخريطة
//           if (_selectedLocation != null)
//             Positioned(
//               bottom: 30,
//               left: 30,
//               right: 30,
//               child: OutlinedButton(
//                 onPressed: () {
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled: true,
//                     backgroundColor: Colors.transparent,
//                     builder: (context) => DraggableScrollableSheet(
//                       initialChildSize: 0.7,
//                       minChildSize: 0.5,
//                       maxChildSize: 0.9,
//                       builder: (_, controller) => Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           borderRadius:
//                               BorderRadius.vertical(top: Radius.circular(25)),
//                         ),
//                         child: ListView(
//                           controller: controller,
//                           children: [
//                             // Pickup Location
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   "Pickup Location",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 TextButton.icon(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => ContactsScreen(),
//                                       ),
//                                     );
//                                   },
//                                   label: const Text("Add contact"),
//                                   icon: const Icon(Icons.contact_phone,
//                                       color: AppColor.black),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade100,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(Icons.location_on,
//                                       color: Colors.red),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       _address ??
//                                           'Loading address...', // 🆕 العنوان اللي طالع
//                                       style: const TextStyle(fontSize: 16),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 20),

//                             // Sender Information
//                             const Text(
//                               "Sender Information",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             TextField(
//                               decoration: const InputDecoration(
//                                 labelText: 'Name',
//                                 border: OutlineInputBorder(),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             TextField(
//                               keyboardType: TextInputType.phone,
//                               decoration: const InputDecoration(
//                                 labelText: 'Phone',
//                                 border: OutlineInputBorder(),
//                               ),
//                             ),
//                             const SizedBox(height: 20),

//                             // زرار Continue
//                             SizedBox(
//                               width: double.infinity,
//                               height: 55,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.black,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: const Text(
//                                         'Location Set Successfully!',
//                                         style: TextStyle(
//                                           color: Color(0xFF4A148C),
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                       backgroundColor: Colors.white,
//                                       elevation: 10,
//                                       behavior: SnackBarBehavior.floating,
//                                       margin: const EdgeInsets.symmetric(
//                                           horizontal: 20, vertical: 10),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(20),
//                                         side: const BorderSide(
//                                           color: Color(0xFFBA68C8),
//                                           width: 1,
//                                         ),
//                                       ),
//                                       duration: Duration(seconds: 3),
//                                     ),
//                                   );
//                                 },
//                                 child: const Text(
//                                   "Continue",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//                 style: OutlinedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 55),
//                   side: const BorderSide(color: AppColor.lightblue, width: 2),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   backgroundColor: Colors.white,
//                 ),
//                 child: const Text(
//                   'Set Location',
//                   style: TextStyle(
//                     color: AppColor.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
