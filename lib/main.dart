import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MapSample(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? message;
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? googleMapController;

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;
    CameraPosition _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(position.latitude, position.longitude),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    print("lat: $lat & long $long");
    setState(() {
      message = "lat: $lat & long $long";
    });
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("google map"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(onPressed: getCurrentLocation, child: Text("dafa")),
              GoogleMap(
                mapType: MapType.hybrid,
                myLocationButtonEnabled: true,
                initialCameraPosition: _kGooglePlex,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  googleMapController = controller;
                  getCurrentLocation();
                },
              ),
            ],
          ),
        ));
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> marker = {};
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // final CameraPosition _kLake = const CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //
  //     zoom: 19.151926040649414);
  Future<void> _goToTheLake() async {
    LocationPermission permission = await Geolocator.requestPermission();
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;
    setState(() {
      marker.add(Marker(
        markerId: const MarkerId("id-1"),
        position: LatLng(position.latitude, position.longitude),
      ));
    });
    CameraPosition _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(position.latitude, position.longitude),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    print("lat: $lat & long $long");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.hybrid,
          markers: marker,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            setState(() {});
            _goToTheLake();
          },
        ),
      ),
    );
  }
}
