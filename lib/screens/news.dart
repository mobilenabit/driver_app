import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  final String title;
  final String time;
  final Image image;
  const NewsScreen(
      {super.key,
      required this.title,
      required this.time,
      required this.image});

  @override
  Widget build(BuildContext context) {
    var color = const Color.fromRGBO(99, 96, 255, 1);
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
          title,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
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
                padding: EdgeInsets.only(
                  bottom: 10,
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(145, 145, 159, 1),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              image,
              SizedBox(
                height: 25,
              ),
              Text(
                  'Phasellus vestibulum lorem sed risus ultricies tristique nulla aliquet. Vel quam elementum pulvinar etiamnim lobortis scelerisque. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur....'),
            ],
          ),
        ),
      ),
    );
  }
}
