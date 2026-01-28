import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../constence/MyColor.dart';

class MapPage extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapPage({required this.latitude, required this.longitude, super.key});

  @override
  Widget build(BuildContext context) {
    final LatLng location = LatLng(latitude, longitude);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: location, zoom: 15),
            markers: {Marker(markerId: const MarkerId("loc"), position: location, infoWindow: const InfoWindow(title: "موقع الطلب"))},
            zoomControlsEnabled: false,
          ),

          // زر الرجوع العائم
          Positioned(
            top: 50,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () => Get.back(),
              child: Icon(Icons.arrow_back, color: MyColor.primaryBlue),
            ),
          ),

          // بطاقة معلومات في الأسفل
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: MyColor.primaryBlue),
                  const SizedBox(width: 10),
                  const Text("موقع تقديم الخدمة المحدد", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}