import 'package:hive/hive.dart';
import 'article.dart';

class SavedArticle extends HiveObject {
  final int id;
  final String date;
  final String title;
  final String content;
  final String link;
  final int author;
  final int featuredMedia;
  final String categoryName;
  final DateTime savedAt;
  final List<int> tags;
  final String featuredMediaUrl;
  final String authorName;
  final List<String> tagNames;

  SavedArticle({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.link,
    required this.author,
    required this.featuredMedia,
    required this.categoryName,
    required this.savedAt,
    required this.tags,
    this.featuredMediaUrl = '',
    this.authorName = '',
    this.tagNames = const [],
  });

  factory SavedArticle.fromArticle(
    Article article,
    String categoryName, {
    String featuredMediaUrl = '',
    String authorName = '',
    List<String> tagNames = const [],
  }) {
    return SavedArticle(
      id: article.id,
      date: article.date,
      title: article.title,
      content: article.content,
      link: article.link,
      author: article.author,
      featuredMedia: article.featuredMedia,
      categoryName: categoryName,
      savedAt: DateTime.now(),
      tags: article.tags,
      featuredMediaUrl: featuredMediaUrl,
      authorName: authorName,
      tagNames: tagNames,
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
      featuredMedia: featuredMedia,
      tags: tags,
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
      'featuredMedia': featuredMedia,
      'categoryName': categoryName,
      'savedAt': savedAt.toIso8601String(),
      'tags': tags,
      'featuredMediaUrl': featuredMediaUrl,
      'authorName': authorName,
      'tagNames': tagNames,
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
      featuredMedia: map['featuredMedia'],
      categoryName: map['categoryName'],
      savedAt: DateTime.parse(map['savedAt']),
      tags: List<int>.from(map['tags'] ?? []),
      featuredMediaUrl: map['featuredMediaUrl'] ?? '',
      authorName: map['authorName'] ?? '',
      tagNames: List<String>.from(map['tagNames'] ?? []),
    );
  }
}
