import "package:carousel_slider/carousel_slider.dart";
import "package:driver_app/screens/news.dart";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";
import "package:provider/provider.dart";
import "../../core/user_data.dart";

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

List<Info> _items = [
  Info(
    title: "Khai trương cửa hàng xăng dầu liên danh giữa SAIGONTEL và PVOIL",
    time: "04/08/2024",
    image: Image.asset('assets/images/Card.png'),
  ),
  Info(
    title:
        "Về việc Báo cáo Quỹ bình ổn xăng dầu giai đoạn 01/08/2024 đến 31/08/2024",
    time: "14/08/2024",
    image: Image.asset('assets/images/Card.png'),
  ),
  Info(
    title: "PVOIL điều chỉnh giá bán buôn xăng dầu từ 15h30, ngày 20/07/2024",
    time: "14/08/2024",
    image: Image.asset('assets/images/Card.png'),
  ),
];

class _InfoScreenState extends State<InfoScreen> {
  DateTime? _lastBack;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Consumer<UserDataModel>(
        builder: (context, userData, child) => Scaffold(
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
                              image:
                                  NetworkImage(userData.value?["avatar"] ?? ""),
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
                              userData.value?["displayName"] ?? "Tạ Ngọc Anh",
                              style: const TextStyle(
                                color: Color(0xFFFCFCFF),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userData.value?["id"] != null
                                  ? NumberFormat("###")
                                      .format(userData.value?["id"])
                                  : "ID",
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
                                          builder: (context) => NewsScreen(
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: _items[index].image,
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _items[index].title,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                              items: [1, 2, 3, 4, 5].map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width:
                                          MediaQuery.sizeOf(context).width * 1,
                                      decoration: BoxDecoration(
                                          color: [
                                        Colors.amber,
                                        Colors.blue,
                                        Colors.green,
                                        Colors.purple,
                                        Colors.red,
                                      ][i - 1]),
                                      child: Image.asset(
                                        'assets/images/Card.png',
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                1,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                1,
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
        ),
      ),
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
