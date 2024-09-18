class News {
  final String title;
  final String imageUrl;
  final String time;
  final bool isHot;
  final int id;

  News({
    required this.title,
    required this.imageUrl,
    required this.time,
    required this.isHot,
    required this.id,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
        title: json['title'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        time: json['publishedDate'] ?? '',
        isHot: json['isHot'] ?? false,
        id: json['id'] ?? '',
      );
}
