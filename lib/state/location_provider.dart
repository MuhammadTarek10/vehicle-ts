import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final locationProvider = StreamProvider((ref) {
  StreamController<Position> controller = StreamController<Position>();
  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );
  Geolocator.getPositionStream(locationSettings: locationSettings)
      .listen((Position? position) {
    if (position != null) {
      controller.add(position);
    }
  });

  ref.onDispose(() {
    controller.close();
  });

  return controller.stream;
});
