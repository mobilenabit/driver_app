import 'package:driver_app/core/api_client.dart';
import 'package:driver_app/models/news.dart';
import 'package:driver_app/models/news_id.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsScreen extends StatefulWidget {
  final int id;
  const NewsScreen({
    super.key,
    required this.id,
  });

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late List<News> _newsData = [];
  late List<NewsId> _newsDataId = [];
  Future<List<NewsId>>? _newsIdBuilder;

  @override
  void initState() {
    super.initState();
    _newsIdBuilder = fetchNewsIdData(widget.id);
  }

  Future<List<NewsId>> fetchNewsIdData(int id) async {
    try {
      final response = await apiClient.getNewsById(id);

      if (response['success']) {
        dynamic jsonData = response['data'];

        if (jsonData is List) {
          List<NewsId> newsList = [];

          for (var jsonItem in jsonData) {
            newsList.add(NewsId.fromJson(jsonItem));
          }

          return newsList;
        } else {
          return [NewsId.fromJson(jsonData)];
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load NewsData');
    }
  }

  @override
  Widget build(BuildContext context) {
    var color = const Color.fromRGBO(99, 96, 255, 1);
    return FutureBuilder<List<NewsId>>(
      future: _newsIdBuilder,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          _newsDataId = snapshot.data!;
          var newsData = _newsDataId[0];

          return Scaffold(
              backgroundColor: color,
              appBar: AppBar(
                backgroundColor: color,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                title: Text(
                  newsData.title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              body: Container(
                width: MediaQuery.sizeOf(context).width * 1,
                height: MediaQuery.sizeOf(context).height * 1,
                padding: const EdgeInsets.only(
                  left: 25,
                  top: 25,
                  right: 25,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Text(
                          newsData.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd').format(
                          DateTime.parse(newsData.time),
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(145, 145, 159, 1),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CachedNetworkImage(
                        imageUrl: newsData.imageUrl,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/PetroNET_Logo.png'),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        newsData.content,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
