import 'package:driver_app/core/api_client.dart';
import 'package:driver_app/models/license_plate.dart';
import 'package:driver_app/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

class LicensePlateScreen extends StatefulWidget {
  const LicensePlateScreen({super.key});

  @override
  State<LicensePlateScreen> createState() => _LicensePlateScreenState();
}

class _LicensePlateScreenState extends State<LicensePlateScreen> {
  final TextEditingController _searchController = TextEditingController();
  String filter = "";
  Future<Map<String, dynamic>>? licensePlates;
  LicensePlateModel? licensePlateModel;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    final userData = context.read<UserDataModel>().value;

    licensePlates = apiClient.getVehicles(userData?["id"]).onError(
      (error, stackTrace) {
        throw Exception("Failed to load license plates");
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    licensePlateModel = context.read<LicensePlateModel>();

    var color = const Color.fromRGBO(99, 96, 255, 1);
    return Consumer<UserDataModel>(
      builder: (context, userData, child) => Scaffold(
        backgroundColor: color,
        appBar: AppBar(
          backgroundColor: color,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Đổi xe',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              // Search
              Container(
                margin: const EdgeInsets.only(
                  top: 25,
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(226, 226, 226, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      filter = value;
                    });
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(145, 145, 159, 1),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              // List gas station
              Expanded(
                child: FutureBuilder(
                  future: licensePlates,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container();
                    }
                    return ListView.builder(
                      itemCount: snapshot.data?["data"].length,
                      itemBuilder: (context, index) {
                        final plate = snapshot.data?["data"][index];
                        print(plate);
                        var vehicleCode =
                            plate["vehicle"]["vehicleCode"].toString();
                        return vehicleCode.contains(filter)
                            ? Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 15.0,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    licensePlateModel?.setLicensePlate(plate);
                                    Navigator.pop(context, vehicleCode);
                                  },
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          vehicleCode,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        LucideIcons.chevron_right,
                                        color: Color.fromRGBO(145, 145, 159, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : null;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
