import 'package:driver_app/screens/gas_station.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
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
  LatLng? myPosition = const LatLng(20.9658224, 105.791458);
  final MapController _mapController = MapController();

  // Marker data with name and address
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

  void _showMarkerInfo(
    String name,
    DateTime startTime,
    DateTime endTime,
    double distance,
    LatLng location,
  ) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
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
          ? const Center(child: CircularProgressIndicator())
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
                        'id': 'mapbox/streets-v12',
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
                          onPressed: () {},
                          child: Icon(
                            LucideIcons.locate_fixed,
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
                          onPressed: () {
                            pushWithoutNavBar(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GasStationScreen(),
                              ),
                            );
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
