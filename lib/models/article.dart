// models/article.dart
class Article {
  final int id;
  final String date;
  final String title;
  final String content;
  final String link;

  Article({required this.id, required this.date, required this.title, required this.content, required this.link});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      date: json['date'],
      title: json['title']['rendered'],
      content: json['content']['rendered'],
      link: json['link'],
    );
  }
}

