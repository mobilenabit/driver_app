import "package:carousel_slider/carousel_slider.dart";
import "package:driver_app/core/api_client.dart";
import "package:driver_app/models/licensePlate.dart";
import "package:driver_app/models/userData.dart";
import "package:driver_app/screens/news.dart";
import "package:flutter/material.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";
import "package:provider/provider.dart";

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  DateTime? _lastBack;
  Future<List<UserData>>? _userDataBuilder;
  late List<UserData> _userData = [];
  late String licensePlate;

  @override
  void initState() {
    super.initState();
    _userDataBuilder = fetchUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final licensePlateModel = context.read<LicensePlateModel>();
      licensePlate = licensePlateModel.licensePlate;
      licensePlateModel.addListener(_updateLicensePlate);
    });
  }

  @override
  void dispose() {
    context.read<LicensePlateModel>().removeListener(_updateLicensePlate);
    super.dispose();
  }

  void _updateLicensePlate() {
    setState(() {
      licensePlate = context.read<LicensePlateModel>().licensePlate;
    });
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

  final List<Info> _items = [
    Info(
      title: "Khai trương cửa hàng xăng dầu liên danh giữa SAIGONTEL và PVOIL",
      time: "04/08/2024",
      image: Image.asset('assets/images/ttxvn-cv6.jpg'),
    ),
    Info(
      title:
          "Về việc Báo cáo Quỹ bình ổn xăng dầu giai đoạn 01/08/2024 đến 31/08/2024",
      time: "14/08/2024",
      image: Image.asset('assets/images/ttxvn2024-1.jpg'),
    ),
    Info(
      title: "PVOIL điều chỉnh giá bán buôn xăng dầu từ 15h30, ngày 20/07/2024",
      time: "14/08/2024",
      image: Image.asset('assets/images/20240827-4.jpg'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      child: FutureBuilder<List<UserData>>(
          future: _userDataBuilder,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              _userData = snapshot.data!;
              var userData = _userData[0];

              return Scaffold(
                backgroundColor: const Color(0xFF6360FF),
                body: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
                        child: Row(
                          children: [
                            if (userData.avatar!.isNotEmpty)
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(userData.avatar ?? ""),
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
                                    userData.name,
                                    style: const TextStyle(
                                      color: Color(0xFFFCFCFF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    licensePlate,
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
                      Expanded(
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
                                      itemCount: _items.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            pushWithoutNavBar(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NewsScreen(
                                                  title: _items[index].title,
                                                  time: _items[index].time,
                                                  image: _items[index].image,
                                                ),
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
                                                  child: _items[index].image,
                                                ),
                                                const SizedBox(width: 15),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        _items[index].title,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        _items[index].time,
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
                                  margin:
                                      const EdgeInsets.fromLTRB(21, 27, 21, 38),
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
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                    ),
                                    items: [1, 2, 3, 4, 5].map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                1,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        NewsScreen(
                                                      title: [
                                                        'Giá dầu thế giới giảm mạnh do lo ngại về nhu cầu',
                                                        'Bản tin Năng lượng Quốc tế 5/9: Đà giảm của giá dầu vẫn chưa dừng lại',
                                                        'OPEC+ gia hạn thỏa thuận cắt giảm sản lượng đến cuối tháng 11/2024',
                                                        'Giá dầu thế giới giảm gần 5% trong phiên 3/9',
                                                        'Bản tin Năng lượng Quốc tế 4/9: Giá dầu thế giới tiếp tục giảm sau cú trượt dốc gần 5%',
                                                      ][i - 1]
                                                          .toString(),
                                                      time: [
                                                        '05/09/2024',
                                                        '05/09/2024',
                                                        '04/09/2024',
                                                        '03/09/2024',
                                                        '02/09/2024',
                                                      ][i - 1]
                                                          .toString(),
                                                      image: Image.asset(
                                                        [
                                                          'assets/images/ttxvn-cv6.jpg',
                                                          'assets/images/20240827-4.jpg',
                                                          'assets/images/ttxvn2024-1.jpg',
                                                          'assets/images/anh-ptt20240724100403.png',
                                                          'assets/images/20210902-1.jpg',
                                                        ][i - 1],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Image.asset(
                                                [
                                                  'assets/images/ttxvn-cv6.jpg',
                                                  'assets/images/20240827-4.jpg',
                                                  'assets/images/ttxvn2024-1.jpg',
                                                  'assets/images/anh-ptt20240724100403.png',
                                                  'assets/images/20210902-1.jpg',
                                                ][i - 1],
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        1,
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        1,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No user data available.'));
            }
          }),
      onWillPop: () async {
        DateTime currenTime = DateTime.now();
        bool backButton = _lastBack == null ||
            currenTime.difference(_lastBack!) > const Duration(seconds: 2);
        if (backButton) {
          _lastBack = currenTime;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bấm lần nữa để thoát ứng dụng.'),
            ),
          );
          return false;
        }
        return true;
      },
    );
  }
}

class Info {
  String title;
  String time;
  Image image;
  Info({
    required this.title,
    required this.time,
    required this.image,
  });
}
