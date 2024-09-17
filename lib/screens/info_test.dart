import "package:carousel_slider/carousel_slider.dart";
import "package:driver_app/core/api_client.dart";
import "package:driver_app/models/licensePlate.dart";
import "package:driver_app/models/userData.dart";
import "package:driver_app/screens/news.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import "package:url_launcher/url_launcher.dart";

class InfoTestScreen extends StatefulWidget {
  const InfoTestScreen({super.key});

  @override
  State<InfoTestScreen> createState() => _InfoTestScreenState();
}

class _InfoTestScreenState extends State<InfoTestScreen> {
  DateTime? _lastBack;
  Future<List<UserData>>? _userDataBuilder;
  late List<UserData> _userData = [];
  late String licensePlate;
  List<Articles> articles = [];

  @override
  void initState() {
    super.initState();
    _userDataBuilder = fetchUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final licensePlateModel = context.read<LicensePlateModel>();
      licensePlate = licensePlateModel.licensePlate;
      licensePlateModel.addListener(_updateLicensePlate);
    });
    getWebsiteData();
  }

  @override
  void dispose() {
    context.read<LicensePlateModel>().removeListener(_updateLicensePlate);
    super.dispose();
  }

  void getWebsiteData() async {
    try {
      final url =
          Uri.parse('https://www.petrolimex.com.vn/nd/tin-chuyen-nganh');
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);

      // Get all titles
      final titles =
          html.querySelectorAll('h3').map((element) => element.text).toList();

      // Get time
      final time = html
          .querySelectorAll('div > p > span')
          .map((element) => element.text)
          .toList();

      // Get image URLs
      final images = html
          .querySelectorAll('a > picture > img')
          .map((element) => element.attributes['src'] ?? '')
          .toList();

      // Get urls
      final urls = html
          .querySelectorAll('head > link')
          .map((element) => element.attributes['href'] ?? '')
          .toList();

      print('Count: ${titles.length}');
      print('Count: ${titles}');
      print(urls);

      setState(() {
        articles = List.generate(
          titles.length,
          (index) => Articles(
            titleA: titles[index],
            imageA: images[index + 1],
            time: time[index + 1],
            urls: urls[index],
          ),
        );
      });
    } catch (e) {
      print('Error: $e');
    }
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

  String slugify(String title) {
    // Define Vietnamese character replacements
    final diacriticsMap = {
      'á': 'a',
      'à': 'a',
      'ả': 'a',
      'ã': 'a',
      'ạ': 'a',
      'ă': 'a',
      'ắ': 'a',
      'ằ': 'a',
      'ẳ': 'a',
      'ẵ': 'a',
      'ặ': 'a',
      'â': 'a',
      'ấ': 'a',
      'ầ': 'a',
      'ẩ': 'a',
      'ẫ': 'a',
      'ậ': 'a',
      'é': 'e',
      'è': 'e',
      'ẻ': 'e',
      'ẽ': 'e',
      'ẹ': 'e',
      'ê': 'e',
      'ế': 'e',
      'ề': 'e',
      'ể': 'e',
      'ễ': 'e',
      'ệ': 'e',
      'í': 'i',
      'ì': 'i',
      'ỉ': 'i',
      'ĩ': 'i',
      'ị': 'i',
      'ó': 'o',
      'ò': 'o',
      'ỏ': 'o',
      'õ': 'o',
      'ọ': 'o',
      'ô': 'o',
      'ố': 'o',
      'ồ': 'o',
      'ổ': 'o',
      'ỗ': 'o',
      'ộ': 'o',
      'ơ': 'o',
      'ớ': 'o',
      'ờ': 'o',
      'ở': 'o',
      'ỡ': 'o',
      'ợ': 'o',
      'ú': 'u',
      'ù': 'u',
      'ủ': 'u',
      'ũ': 'u',
      'ụ': 'u',
      'ư': 'u',
      'ứ': 'u',
      'ừ': 'u',
      'ử': 'u',
      'ữ': 'u',
      'ự': 'u',
      'ý': 'y',
      'ỳ': 'y',
      'ỷ': 'y',
      'ỹ': 'y',
      'ỵ': 'y',
      'đ': 'd',
      'Đ': 'd',
    };

    // Normalize diacritics
    String normalizedTitle = title.split('').map((char) {
      return diacriticsMap[char] ?? char;
    }).join('');

    // Convert to lowercase, replace spaces and special characters with hyphens
    normalizedTitle = normalizedTitle.toLowerCase();
    normalizedTitle = normalizedTitle.replaceAll(
        RegExp(r'[^\w\s-]'), ''); // Remove special characters
    normalizedTitle = normalizedTitle.replaceAll(
        RegExp(r'[\s-]+'), '-'); // Replace spaces and multiple hyphens

    return normalizedTitle;
  }

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
                            if (userData.avatar.isNotEmpty)
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(userData.avatar),
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
                                      left: 15,
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
                                      itemCount: articles.length,
                                      itemBuilder: (context, index) {
                                        final article = articles[index];

                                        return GestureDetector(
                                          onTap: () async {
                                            final url = article.urls;

                                            print(url);

                                            // ignore: deprecated_member_use
                                            if (await canLaunch(url)) {
                                              // ignore: deprecated_member_use
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 5,
                                            ),
                                            padding: const EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 5,
                                              bottom: 5,
                                            ),
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
                                                  child: Image.network(
                                                    article.imageA,
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        1,
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.3,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                ),
                                                const SizedBox(width: 15),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        article.titleA,
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
                                                        article.time,
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

class Articles {
  String titleA;
  String imageA;
  String time;
  String urls;

  Articles({
    required this.titleA,
    required this.imageA,
    required this.time,
    required this.urls,
  });
}
