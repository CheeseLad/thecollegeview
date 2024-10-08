import 'package:flutter/material.dart';
import '../models/article.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  final String categoryName;

  const ArticleDetailScreen(
      {super.key, required this.article, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        '⏰ ${DateFormat('MMMM d, y').format(DateTime.parse(article.date))}';

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(formattedDate),
                  const SizedBox(width: 10),
                  FutureBuilder<String>(
                    future: fetchAuthorName(article.author),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error');
                      } else {
                        return Text('by ${snapshot.data} in $categoryName',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]));
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              HtmlWidget(
                article.content,
                renderMode: RenderMode.column,
                textStyle: const TextStyle(fontSize: 16),
                customStylesBuilder: (element) {
                  if (element.localName == 'img') {
                    return {
                      'border-radius': '10px',
                    };
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Share.share(article.link);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share),
                      SizedBox(width: 8.0),
                      Text(
                        "Share",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
