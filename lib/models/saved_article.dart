import 'package:hive/hive.dart';
import 'article.dart';

// part 'saved_article.g.dart'; // Uncomment after running build_runner

class SavedArticle extends HiveObject {
  final int id;
  final String date;
  final String title;
  final String content;
  final String link;
  final int author;
  final int featured_media;
  final String categoryName;
  final DateTime savedAt;

  SavedArticle({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.link,
    required this.author,
    required this.featured_media,
    required this.categoryName,
    required this.savedAt,
  });

  factory SavedArticle.fromArticle(Article article, String categoryName) {
    return SavedArticle(
      id: article.id,
      date: article.date,
      title: article.title,
      content: article.content,
      link: article.link,
      author: article.author,
      featured_media: article.featured_media,
      categoryName: categoryName,
      savedAt: DateTime.now(),
    );
  }

  Article toArticle() {
    return Article(
      id: id,
      date: date,
      title: title,
      content: content,
      link: link,
      author: author,
      featured_media: featured_media,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'title': title,
      'content': content,
      'link': link,
      'author': author,
      'featured_media': featured_media,
      'categoryName': categoryName,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory SavedArticle.fromMap(Map map) {
    return SavedArticle(
      id: map['id'],
      date: map['date'],
      title: map['title'],
      content: map['content'],
      link: map['link'],
      author: map['author'],
      featured_media: map['featured_media'],
      categoryName: map['categoryName'],
      savedAt: DateTime.parse(map['savedAt']),
    );
  }
}
