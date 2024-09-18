import 'package:driver_app/core/api_client.dart';
import 'package:driver_app/models/userData.dart';
import 'package:driver_app/screens/qr_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  Future<List<UserData>>? _userDataBuilder;
  late List<UserData> _userData = [];

  @override
  void initState() {
    super.initState();
    _userDataBuilder = fetchUserData();
  }

  Future<List<UserData>> fetchUserData() async {
    try {
      final response = await apiClient.getUserData();

      if (response['success']) {
        UserData data = UserData.fromJson(response['data']);

        setState(() {
          _userData = [data];
        });
        return _userData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load UserData');
    }
  }

  @override
  Widget build(BuildContext context) {
    var color = const Color.fromRGBO(99, 96, 255, 1);
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: color,
        title: const Text(
          'QR của tôi',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: FutureBuilder<List<UserData>>(
          future: _userDataBuilder,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              _userData = snapshot.data!;
              var userData = _userData[0];

              return Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/images/xangdau-page-title-mb 1.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 350,
                    width: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          userData.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Row(
                            children: List.generate(
                              150 ~/ 5,
                              (index) => Expanded(
                                child: Container(
                                  color: index % 2 == 0
                                      ? Colors.transparent
                                      : const Color.fromRGBO(179, 179, 179, 1),
                                  height: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Icon(
                          LucideIcons.qr_code,
                          size: 200,
                        ),
                        TextButton(
                          onPressed: () {
                            pushScreenWithoutNavBar(
                              context,
                              const QrResultScreen(),
                            );
                          },
                          child: Text(
                            'Debug',
                            style: TextStyle(
                              fontSize: 15,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No user data available.'));
            }
          }),
    );
  }
}
