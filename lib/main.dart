import 'dart:ui' as ui;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vehicle_tracking/state/vehicle_provider.dart';
import 'package:vehicle_tracking/utils/helpers/location_helper.dart';
import 'package:vehicle_tracking/utils/helpers/map_helper.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late GoogleMapController mapController;
  Map<String, Marker> allMarkers = {};
  final LatLng _center = const LatLng(31.205753, 29.924526);
  Uint8List? icon;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getCurrentLocation() async {
    final position = await LocationHelper.getCurrentLocation();
    print("Position: $position");
    setState(() {
      allMarkers['current'] = Marker(
        markerId: const MarkerId('current'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
    });
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 140.0,
        ),
      ),
    );
  }

  Future<void> _initIcon() async {
    icon = await getBytesFromAsset('assets/images/car.png', 234);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    _initIcon();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          return GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 140.0,
            ),
            markers: ref.watch(vehicleProvider).when(
                  data: (vehicles) {
                    for (var element in vehicles) {
                      allMarkers[element!.id!] =
                          MapHelper.convertToMarker(element, icon);
                    }
                    return allMarkers.values.toSet();
                  },
                  loading: () => allMarkers.values.toSet(),
                  error: (err, stack) => allMarkers.values.toSet(),
                ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: 'Get Current Location',
        child: const Icon(Icons.location_searching),
      ),
    );
  }
}
