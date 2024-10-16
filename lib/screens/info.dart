import "package:cached_network_image/cached_network_image.dart";
import "package:carousel_slider/carousel_slider.dart";
import "package:driver_app/core/api_client.dart";
import "package:driver_app/core/secure_store.dart";
import "package:driver_app/models/driver.dart";
import "package:driver_app/models/license_plate.dart";
import "package:driver_app/models/map_destinations.dart";
import "package:driver_app/models/news.dart";
import "package:driver_app/models/user_data.dart";
import "package:driver_app/screens/news.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";
import "package:provider/provider.dart";

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late String licensePlate;
  late List<News> _newsData = [];
  Future<List<News>>? _newsBuilder;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userData = context.watch<UserDataModel>().value;
    if (userData != null) {
      secureStorage.writeSecureData(
          "last_logged_in_user_name", userData["displayName"]);
      secureStorage.writeSecureData(
          "last_logged_in_user_avatar", userData["avatar"]);
      secureStorage.writeSecureData(
          "last_logged_in_user_phone_number", userData["phoneNumber"]);
    }
  }

  @override
  void initState() {
    final userData = context.read<UserDataModel>().value;
    print(context.read<DriverModel>().value?["driverName"]);
    super.initState();

    _newsBuilder = fetchNewsData();
  }

  @override
  void dispose() {
    context.read<LicensePlateModel>().removeListener(_updateLicensePlate);
    super.dispose();
  }

  void _updateLicensePlate() {
    setState(() {});
  }

  Future<List<News>> fetchNewsData() async {
    try {
      final response = await apiClient.getNews();

      if (response['success']) {
        List<dynamic> jsonData = response['data'];
        List<News> newsList = [];

        for (var jsonItem in jsonData) {
          newsList.add(News.fromJson(jsonItem));
        }

        setState(() {
          _newsData = newsList;
        });
        return _newsData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load NewsData');
    }
  }

  // Future<Map<String, dynamic>> getDriverData() async {
  //   final userData = context.read<UserDataModel>().value;
  //   try {
  //     final response = await apiClient.getDriver(userData?["userId"]);
  //     print(response);
  //     if (response["success"]) {
  //       return response["data"][0];
  //     } else {
  //       throw Exception("Failed to load driver data");
  //     }
  //   } catch (e) {
  //     print(e);
  //     throw Exception("Failed to load driver data");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer4<UserDataModel, LicensePlateModel, MapDestinationModel,
        DriverModel>(
      builder:
          (context, userData, licensePlate, mapDestinations, driver, child) =>
              Scaffold(
        backgroundColor: const Color(0xFF6360FF),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
                child: Row(
                  children: [
                    if (userData.value?["avatar"] != null &&
                        userData.value?["avatar"].isNotEmpty)
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(userData.value?["avatar"]),
                          ),
                        ),
                      )
                    else
                      const Icon(
                        Icons.account_circle,
                        size: 55,
                        color: Colors.white,
                      ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.value?["driverName"] ?? "",
                            style: const TextStyle(
                              color: Color(0xFFFCFCFF),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // FutureBuilder(
                          //     future: getDriverData(),
                          //     builder: (context, snapshot) {
                          //       if (snapshot.connectionState ==
                          //           ConnectionState.waiting) {
                          //         return const Center(
                          //             child: CircularProgressIndicator());
                          //       } else if (snapshot.hasError) {
                          //         return Center(
                          //             child: Text('Error: ${snapshot.error}'));
                          //       } else if (snapshot.hasData) {
                          //         return Text(
                          //           snapshot.data?["driverName"] ?? "",
                          //           style: const TextStyle(
                          //             color: Color(0xFFFCFCFF),
                          //             fontSize: 14,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         );
                          //       } else {
                          //         return const Center(
                          //             child: Text('No user data available.'));
                          //       }
                          //     }),
                          Text(
                            licensePlate.licensePlate ?? '',
                            style: const TextStyle(
                              color: Color(0xFFFCFCFF),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<News>>(
                future: _newsBuilder,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    _newsData = snapshot.data!;

                    return Expanded(
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.sizeOf(context).height * 0.15,
                            ),
                            width: MediaQuery.sizeOf(context).width * 1,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(241, 241, 250, 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: 140,
                                    bottom: 15,
                                    left: 26,
                                  ),
                                  child: Text(
                                    'Bản tin',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _newsData.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      var newsData = _newsData[index];
                                      return GestureDetector(
                                        onTap: () {
                                          pushWithoutNavBar(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NewsScreen(
                                                  id: _newsData[index].id),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 26,
                                            vertical: 10,
                                          ),
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.3,
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.1,
                                                child: CachedNetworkImage(
                                                  imageUrl: newsData.imageUrl,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Image.asset(
                                                          'assets/images/PetroNET_Logo.png'),
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      newsData.title,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(
                                                        DateTime.parse(
                                                            newsData.time),
                                                      ),
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromRGBO(
                                                            145, 145, 159, 1),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(21, 27, 21, 38),
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  enableInfiniteScroll: true,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 3),
                                ),
                                items: _newsData
                                    .where((news) => news.isHot == true)
                                    .map(
                                  (news) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          child: InkWell(
                                            onTap: () {
                                              pushWithoutNavBar(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewsScreen(id: news.id),
                                                ),
                                              );
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: news.imageUrl,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                'assets/images/PetroNET_Logo.png',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text('No user data available.'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
