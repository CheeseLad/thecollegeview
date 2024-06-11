// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import 'package:intl/intl.dart'; // Import the intl package
import 'providers/article_provider.dart';
import 'models/article.dart';
import 'screens/article_detail_screen.dart'; // Import the new screen
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArticleProvider(),
      child: MaterialApp(
        home: ArticlesScreen(),
      ),
    );
  }
}

class ArticlesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articleProvider = Provider.of<ArticleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Website Name'), // Website name to the left
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/logo.png', // Path to your logo image
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Website Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('All Articles'),
              onTap: () {
                articleProvider.selectCategory(null);
                Navigator.pop(context); // Close the drawer
              },
            ),
            ...articleProvider.categories.map((category) {
              return ListTile(
                title: Text(category.name),
                onTap: () {
                  articleProvider.selectCategory(category.id);
                  Navigator.pop(context); // Close the drawer
                },
              );
            }).toList(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.facebook, size: 30),
                SizedBox(width: 10),
                FaIcon(FontAwesomeIcons.twitter, size: 30),
                SizedBox(width: 10),
                FaIcon(FontAwesomeIcons.instagram, size: 30),
                SizedBox(width: 10),
                FaIcon(FontAwesomeIcons.linkedin, size: 30),
                SizedBox(width: 10),
                FaIcon(FontAwesomeIcons.youtube, size: 30),
              ],
            ),
          ],
        ),
      ),
      body: articleProvider.loading
          ? Center(child: CircularProgressIndicator())
          : articleProvider.error != null
              ? Center(child: Text('Error: ${articleProvider.error}'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: articleProvider.articles.length,
                        itemBuilder: (context, index) {
                          Article article = articleProvider.articles[index];
                          String previewText = article.content.split(' ').take(30).join(' ') + '...';
                          String formattedDate = '⏰' + DateFormat('MMMM d, y').format(DateTime.parse(article.date));

                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleDetailScreen(article: article),
                              ),
                            ),
                            child: Card(
                              margin: EdgeInsets.all(10),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(article.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    Text(formattedDate),
                                    SizedBox(height: 10),
                                    Text(previewText),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: articleProvider.currentPage > 1 ? () => articleProvider.previousPage() : null,
                          child: Text('Previous'),
                        ),
                        Text('Page ${articleProvider.currentPage} of ${articleProvider.totalPages}'),
                        TextButton(
                          onPressed: articleProvider.currentPage < articleProvider.totalPages ? () => articleProvider.nextPage() : null,
                          child: Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
