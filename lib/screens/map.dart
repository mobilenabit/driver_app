import 'dart:async';
import 'dart:typed_data';

import 'package:driver_app/screens/gas_station.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapboxMapController mapController;
  String selectedStyle = MapboxStyles.SATELLITE;
  final LatLng _initialCameraPosition = const LatLng(20.9658224, 105.791458);
  final List<Symbol> _symbols = [];

  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List> loadMarkerImage(String assetPath) async {
    final ByteData byteData = await rootBundle.load(assetPath);
    return byteData.buffer.asUint8List();
  }

  void _onMapCreated(MapboxMapController controller) async {
    mapController = controller;

    await _addMarkers();
    _highlightSelectedMarker();

    mapController.onSymbolTapped.add(_onMarkerTapped);

    mapController.onSymbolTapped.add(_onMarkerTapped);
  }

  Future<void> _addMarkers() async {
    // Load marker images
    final Uint8List markerImage1 =
        await loadMarkerImage("assets/images/Avater.png");
    final Uint8List markerImage2 =
        await loadMarkerImage("assets/images/ava.jpg");
    final Uint8List markerImage3 =
        await loadMarkerImage("assets/images/ava.jpg");

    // Add the marker images to the map
    mapController.addImage('marker1', markerImage1);
    mapController.addImage('marker2', markerImage2);
    mapController.addImage('marker3', markerImage3);

    // Add the first marker
    _symbols.add(
      await mapController.addSymbol(
        const SymbolOptions(
          iconSize: 0.3,
          iconImage: 'marker1',
          geometry: LatLng(9.939545, 108.458877),
          iconAnchor: 'bottom',
        ),
      ),
    );

    // Add the second marker
    _symbols.add(
      await mapController.addSymbol(
        const SymbolOptions(
          iconSize: 0.3,
          iconImage: 'marker2',
          geometry: LatLng(2.939555, 108.458887),
          iconAnchor: 'bottom',
        ),
      ),
    );

    // Add the third marker
    _symbols.add(
      await mapController.addSymbol(
        const SymbolOptions(
          iconSize: 0.03,
          iconImage: 'marker3',
          geometry: LatLng(11.939525, 108.458887),
          iconAnchor: 'bottom',
        ),
      ),
    );
  }

  void _onStyleLoadedCallback() async {
    await _addMarkers();
  }

  void _highlightSelectedMarker() {
    // Reset all markers to their default state
    for (int i = 0; i < _symbols.length; i++) {
      mapController.updateSymbol(
        _symbols[i],
        SymbolOptions(
          iconSize: 0.3,
          iconImage: 'marker${i + 1}',
        ),
      );
    }
  }

  void _onMarkerTapped(Symbol symbol) {
    int index = _symbols.indexOf(symbol);

    String name;
    switch (index) {
      case 0:
        name = "First Marker";
        break;
      case 1:
        name = "Second Marker";
        break;
      case 2:
        name = "Third Marker";
        break;
      default:
        name = "Unknown Marker";
        break;
    }

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Marker Name: $name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Location: ${symbol.options.geometry?.latitude}, ${symbol.options.geometry?.longitude}",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _goToCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        // Handle the case when the user has permanently denied location permissions
        print(
            "Location permissions are permanently denied. We cannot request permissions.");
        return;
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high);

      // Update the camera position to the current location
      mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude,
              position.longitude),
        ),
      );
    } catch (e) {
      // Handle exceptions (e.g., if location services are disabled)
      print("Could not get the current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var color = const Color.fromRGBO(99, 96, 255, 1);
    return Scaffold(
      body: Stack(
        children: [
          MapboxMap(
            styleString: selectedStyle,
            rotateGesturesEnabled: true,
            trackCameraPosition: true,
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoadedCallback,
            //minMaxZoomPreference: const MinMaxZoomPreference(10, 20),
            initialCameraPosition: CameraPosition(
              target: _initialCameraPosition,
              zoom: 15,
              //bearing: 16,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.layers_outlined,
                      size: 25,
                      color: color,
                    ),
                    onPressed: () {
                      setState(() {
                        if (selectedStyle == MapboxStyles.SATELLITE) {
                          selectedStyle = MapboxStyles.MAPBOX_STREETS;
                        } else {
                          selectedStyle = MapboxStyles.SATELLITE;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    child: Icon(
                      LucideIcons.locate,
                      size: 25,
                      color: color,
                    ),
                    onPressed: _goToCurrentLocation,
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.list,
                          size: 25,
                          color: color,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Xem danh sách',
                          style: TextStyle(
                            color: color,
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      pushWithoutNavBar(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GasStationScreen()));
                    },
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
