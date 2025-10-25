import '../utils/html_utils.dart';

class Tag {
  final int id;
  final String name;
  final String slug;
  final String description;
  final int count;

  Tag({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.count,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: HtmlUtils.decodeHtmlEntities(json['name']),
      slug: json['slug'],
      description: HtmlUtils.decodeHtmlEntities(json['description']),
      count: json['count'],
    );
  }
}
