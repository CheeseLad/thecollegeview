import '../utils/html_utils.dart';

class Article {
  final int id;
  final String date;
  final String title;
  final String content;
  final String link;
  final int author;
  final int featured_media;
  final List<int> tags;

  Article(
      {required this.id,
      required this.date,
      required this.title,
      required this.content,
      required this.link,
      required this.author,
      required this.featured_media,
      required this.tags});

  factory Article.fromJson(Map<String, dynamic> json) {
    List<int> tags = [];
    if (json['tags'] != null) {
      tags = List<int>.from(json['tags']);
    }

    return Article(
      id: json['id'],
      date: json['date'],
      title: HtmlUtils.decodeHtmlEntities(json['title']['rendered']),
      content:
          HtmlUtils.decodeHtmlEntitiesPreserveTags(json['content']['rendered']),
      link: json['link'],
      author: json['author'],
      featured_media: json['featured_media'],
      tags: tags,
    );
  }
}
