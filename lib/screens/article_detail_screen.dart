// lib/screens/article_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/article.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share_plus/share_plus.dart'; // Import the share_plus package

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
              HtmlWidget(article.content,
                renderMode: RenderMode.column,
                textStyle: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
GestureDetector(
  onTap: () {
    Share.share(article.link);
  },
  child: Container(
    width: double.infinity, // Stretches across the screen horizontally
    padding: EdgeInsets.symmetric(vertical: 16.0), // Vertical padding for spacing
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black, width: 1.0), // Square border
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.share), // Share icon
        SizedBox(width: 8.0), // Space between icon and text
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

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
