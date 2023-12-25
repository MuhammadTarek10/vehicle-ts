import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vehicle_tracking/models/vehicle.dart';

class MapHelper {
  static Marker convertToMarker(Vehicle vehicle, Uint8List? icon) {
    return Marker(
      markerId: MarkerId(vehicle.id!),
      position: vehicle.position!,
      infoWindow: InfoWindow(title: vehicle.name),
      icon: icon != null
          ? BitmapDescriptor.fromBytes(icon)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
  }
}
