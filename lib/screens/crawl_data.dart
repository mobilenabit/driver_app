import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class CrwalDataScreen extends StatefulWidget {
  const CrwalDataScreen({super.key});

  @override
  State<CrwalDataScreen> createState() => _CrwalDataScreenState();
}

class _CrwalDataScreenState extends State<CrwalDataScreen> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    getWebsiteData();
  }

  void getWebsiteData() async {
    try {
      final url =
          Uri.parse('https://www.petrolimex.com.vn/ndi/thong-cao-bao-chi');
      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);

      final titles =
          html.querySelectorAll('h3').map((element) => element.text).toList();

      // final urls = html
      //     .querySelectorAll('h2 > a')
      //     .map(
      //         (element) => 'https://www.amazon.com/${element.attributes['href']}')
      //     .toList();

      final image = html
          .querySelectorAll('a > picture > source')
          .map((element) => element.attributes['src'] ?? '')
          .toList();

      print('Count: ${titles.length}');
      print(titles);
      debugPrint(response.body);

      setState(() {
        articles = List.generate(
          titles.length,
          (index) => Article(
            title: titles[index],
            //  url: urls[index],
            // image: image[index],
          ),
        );
      });
      for (final title in titles) {
        debugPrint(title);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(
          15,
        ),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];

          return ListTile(
            // leading: Image.network(
            //   article.image,
            //   width: 50,
            //   fit: BoxFit.fitHeight,
            // ),
            title: Text(
              article.title,
            ),
            // subtitle: Text(
            //   article.url,
            // ),
          );
        },
      ),
    );
  }
}

class Article {
  final String title;
//  final String url;
  // final String image;

  Article({
    required this.title,
//required this.url,
    //   required this.image,
  });
}
