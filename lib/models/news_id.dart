class NewsId {
  final String title;
  final String imageUrl;
  final String time;
  final String content;

  NewsId({
    required this.title,
    required this.imageUrl,
    required this.time,
    required this.content,
  });

  factory NewsId.fromJson(Map<String, dynamic> json) => NewsId(
        title: json['title'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        time: json['publishedDate'] ?? '',
        content: json['bodyHtml'] ?? '',
      );
}
