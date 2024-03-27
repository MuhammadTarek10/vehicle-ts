import 'package:google_maps_flutter/google_maps_flutter.dart';

class Vehicle {
  String? id;
  LatLng? position;
  String? name;
  String? capacity;
  int? speed;

  Vehicle({
    this.id,
    this.position,
    this.name,
    this.capacity,
    this.speed,
  });

  Vehicle.fromMap(String databaseId, Map<dynamic, dynamic> data) {
    id = databaseId;
    position = LatLng(double.parse(data['lat'].toString()),
        double.parse(data['lng'].toString()));
    name = data['name'].toString();
    capacity = data['capacity'].toString();
    speed = data['speed'] != null ? int.parse(data['speed'].toString()) : 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'position': position,
      'name': name,
      'capacity': capacity,
      'speed': speed,
    };
  }

  @override
  String toString() {
    return 'Vehicle{id: $id, position: $position, name: $name, capacity: $capacity, speed: $speed}';
  }
}
