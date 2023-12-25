import 'package:google_maps_flutter/google_maps_flutter.dart';

class Vehicle {
  String? id;
  LatLng? position;
  String? name;

  Vehicle({
    this.id,
    this.position,
    this.name,
  });

  Vehicle.fromMap(String databaseId, Map<dynamic, dynamic> data) {
    id = databaseId;
    position = LatLng(double.parse(data['lat'].toString()),
        double.parse(data['lng'].toString()));
    name = data['name'].toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'position': position,
    };
  }

  @override
  String toString() {
    return 'Vehicle{id: $id, position: $position, name: $name}';
  }
}
