import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:driver_app/screens/gas_station.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: constant_identifier_names
const MAPBOX_ACCESS_TOKEN =
    'sk.eyJ1IjoiZHVuZzEyMyIsImEiOiJjbHpxc252eWMwd2ZwMm1zM2p6a3MyaDI0In0.VVgBTGJ0X1qSPwZwZuxmZg';

class MapScreen2 extends StatefulWidget {
  const MapScreen2({super.key});

  @override
  State<MapScreen2> createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen2> {
  LatLng? myPosition;
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionStreamSubscription;
  GasMap? selectedGasStation;
  List<LatLng> routePoints = [];

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  // User Location
  Future<void> _startLocationUpdates() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Start listening for location updates.
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        myPosition = LatLng(position.latitude, position.longitude);
      });
    });
  }

  // Marker data
  final _markerData = [
    {
      'location': const LatLng(20.9658224, 105.791458),
      'name': 'CHXD Số 1 Hà Đông',
      'startTime': DateTime(2024, 8, 27, 7, 0),
      'endTime': DateTime(2024, 8, 27, 24, 0),
      'distance': 700.0,
    },
    {
      'location': const LatLng(20.966063, 105.793304),
      'name': 'CHXD Số 2 Hà Đông',
      'startTime': DateTime(2024, 8, 27, 7, 0),
      'endTime': DateTime(2024, 8, 27, 24, 0),
      'distance': 600.0,
    },
    {
      'location': const LatLng(20.964440, 105.792574),
      'name': 'CHXD Số 3 Hà Đông',
      'startTime': DateTime(2024, 8, 27, 7, 0),
      'endTime': DateTime(2024, 8, 27, 24, 0),
      'distance': 80.0,
    },
    {
      'location': const LatLng(20.965903, 105.7909057),
      'name': 'CHXD Số 4 Hà Đông',
      'startTime': DateTime(2024, 8, 27, 7, 0),
      'endTime': DateTime(2024, 8, 27, 24, 0),
      'distance': 170.0,
    },
  ];

  // Show route
  Future<void> _fetchRoute(LatLng start, LatLng end) async {
    final url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson&access_token=$MAPBOX_ACCESS_TOKEN';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coordinates = data['routes'][0]['geometry']['coordinates'];
      setState(() {
        routePoints = coordinates
            .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
            .toList();
      });
    } else {
      throw Exception('Failed to fetch route');
    }
  }

  void _showMarkerInfo(
    String name,
    DateTime startTime,
    DateTime endTime,
    double distance,
    LatLng location,
  ) async {
    if (myPosition != null) {
      //await _fetchRoute(myPosition!, location); // Fetch the route

      _mapController.move(
        location,
        16,
      );
    }

    showModalBottomSheet(
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: 15,
            right: 15,
          ),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/images/Card.png',
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.clock,
                            size: 12,
                            color: Color.fromRGBO(255, 129, 129, 1),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(189, 189, 189, 1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.map_pin,
                            size: 12,
                            color: Color.fromRGBO(255, 129, 129, 1),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${distance.toStringAsFixed(1)} m',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(189, 189, 189, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  final url =
                      'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
                  // ignore: deprecated_member_use
                  if (await canLaunch(url)) {
                    // ignore: deprecated_member_use
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.4,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(99, 96, 255, 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/road.svg'),
                      const SizedBox(width: 10),
                      const Text(
                        'Đường đi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var color = const Color.fromRGBO(99, 96, 255, 1);
    return Scaffold(
      body: myPosition == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: myPosition!,
                    initialZoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                      additionalOptions: const {
                        'accessToken': MAPBOX_ACCESS_TOKEN,
                        'id': 'mapbox/outdoors-v12',
                      },
                    ),
                    MarkerLayer(
                      markers: _markerData.map((marker) {
                        return Marker(
                          point: marker['location'] as LatLng,
                          width: 20,
                          height: 20,
                          child: GestureDetector(
                            onTap: () {
                              final name =
                                  marker['name'] as String? ?? 'Unknown';
                              final startTime =
                                  marker['startTime'] as DateTime? ??
                                      DateTime.now();
                              final endTime = marker['endTime'] as DateTime? ??
                                  DateTime.now();
                              final distance =
                                  marker['distance'] as double? ?? 0.0;
                              final location = marker['location'] as LatLng;

                              _showMarkerInfo(
                                name,
                                startTime,
                                endTime,
                                distance,
                                location,
                              );
                            },
                            child: SvgPicture.asset(
                              'assets/icons/gas.svg',
                              // ignore: deprecated_member_use
                              color: color,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (routePoints.isNotEmpty) // Add the route
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: routePoints,
                            strokeWidth: 4.0,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    CurrentLocationLayer(
                      // ignore: deprecated_member_use
                      turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
                      style: const LocationMarkerStyle(
                        marker: DefaultLocationMarker(),
                        markerSize: Size(20, 20),
                        markerDirection: MarkerDirection.heading,
                      ),
                    ),
                  ],
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
                          onPressed: () {
                            if (myPosition != null) {
                              _mapController.move(myPosition!, 16);
                            }
                          },
                          child: Icon(
                            LucideIcons.locate,
                            color: color,
                            size: 25,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Xem danh sách',
                                style: TextStyle(
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            final selectedGas = await Navigator.push<GasMap>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GasStationScreen(
                                  gasStations: _markerData.map((marker) {
                                    return GasMap(
                                      name: marker['name'] as String,
                                      address: 'Đ.Cầu Bươu',
                                      distance:
                                          '${(marker['distance'] as double).toStringAsFixed(1)} m',
                                    );
                                  }).toList(),
                                ),
                              ),
                            );

                            if (selectedGas != null) {
                              setState(() {
                                selectedGasStation = selectedGas;
                              });

                              // Find the corresponding marker data
                              final selectedMarker = _markerData.firstWhere(
                                (marker) => marker['name'] == selectedGas.name,
                              );

                              final name = selectedMarker['name'] as String;
                              final startTime =
                                  selectedMarker['startTime'] as DateTime;
                              final endTime =
                                  selectedMarker['endTime'] as DateTime;
                              final distance =
                                  selectedMarker['distance'] as double;
                              final location =
                                  selectedMarker['location'] as LatLng;

                              // Show the marker info for the selected gas station
                              _showMarkerInfo(
                                  name, startTime, endTime, distance, location);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
