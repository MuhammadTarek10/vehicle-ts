import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vehicle_tracking/models/vehicle.dart';

final vehicleProvider = StreamProvider<List<Vehicle?>>((ref) {
  final StreamController<List<Vehicle?>> controller =
      StreamController<List<Vehicle?>>();
  final sub = FirebaseDatabase.instance.ref().onValue.listen((event) {
    final data = event.snapshot.value as Map<dynamic, dynamic>;
    final List<Vehicle?> vehicles = [];
    data.forEach((key, value) {
      vehicles.add(Vehicle.fromMap(key, value));
    });
    controller.add(vehicles);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
