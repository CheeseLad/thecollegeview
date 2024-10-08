import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/article_provider.dart';
import '../models/article.dart';
import '../screens/article_detail_screen.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

class ArticleList extends StatelessWidget {
  final String categoryName;

  const ArticleList(
      {super.key, required this.categoryName, required List<Article> articles});

  @override
  Widget build(BuildContext context) {
    final articleProvider = Provider.of<ArticleProvider>(context);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: articleProvider.articles.length,
            itemBuilder: (context, index) {
              Article article = articleProvider.articles[index];
              String previewText =
                  '${_extractTextFromHtml(article.content).split(' ').take(35).join(' ')}...';
              String formattedDate =
                  '⏰ ${DateFormat('MMMM d, y').format(DateTime.parse(article.date))}';

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(
                        article: article, categoryName: categoryName),
                  ),
                ),
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String>(
                          future: fetchFeaturedMedia(article.featured_media),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(56),
                                  child: Image.network(
                                    '${snapshot.data}',
                                    width: 125,
                                    height: 125,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(article.title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(formattedDate),
                                  const SizedBox(height: 5),
                                  FutureBuilder<String>(
                                    future: fetchAuthorName(article.author),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return const Text('Error');
                                      } else {
                                        return Text('👤 ${snapshot.data}');
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 32),
                onPressed: articleProvider.currentPage > 1
                    ? () => articleProvider.previousPage()
                    : null,
              ),
              Text(
                'Page ${articleProvider.currentPage} of ${articleProvider.totalPages}',
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 32),
                onPressed:
                    articleProvider.currentPage < articleProvider.totalPages
                        ? () => articleProvider.nextPage()
                        : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _extractTextFromHtml(String htmlContent) {
    RegExp regex = RegExp(r'<p>(.*?)</p>');
    Iterable<Match> matches = regex.allMatches(htmlContent);
    List<String> texts = matches.map((match) => match.group(1) ?? '').toList();
    return texts.join(' ');
  }

  Future<String> fetchAuthorName(int authorId) async {
    final response = await http.get(
        Uri.parse('https://thecollegeview.ie/wp-json/wp/v2/users/$authorId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['name'];
    } else {
      throw Exception('Failed to load author');
    }
  }

  Future<String> fetchFeaturedMedia(int mediaId) async {
    final response = await http.get(
        Uri.parse('https://thecollegeview.ie/wp-json/wp/v2/media/$mediaId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['source_url'];
    } else {
      return 'assets/assets/article_placeholder.png';
    }
  }
}
