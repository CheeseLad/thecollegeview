// lib/screens/article_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/article.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    String formattedDate = '⏰' + DateFormat('MMMM d, y').format(DateTime.parse(article.date));

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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(formattedDate),
              SizedBox(height: 10),
              Text(
                article.content,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => _launchURL(article.link),
                child: Text('Read more'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
