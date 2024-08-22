class Article {
  final int id;
  final String date;
  final String title;
  final String content;
  final String link;
  final int author;
  final int featured_media;

  Article(
      {required this.id,
      required this.date,
      required this.title,
      required this.content,
      required this.link,
      required this.author,
      required this.featured_media});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      date: json['date'],
      title: json['title']['rendered'],
      content: json['content']['rendered'],
      link: json['link'],
      author: json['author'],
      featured_media: json['featured_media'],
    );
  }
}
