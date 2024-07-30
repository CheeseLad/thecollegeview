// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:thecollegeview/providers/page_provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import 'package:intl/intl.dart'; // Import the intl package
import 'providers/article_provider.dart';
import 'screens/search_page.dart';
import 'models/article.dart';
import 'screens/article_detail_screen.dart'; // Import the new screen
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArticleProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The College View',
        home: ArticlesScreen(categoryName: "All Articles"),
      ),
    );
  }
}

class ArticlesScreen extends StatelessWidget {

  final String categoryName;

  ArticlesScreen({required this.categoryName});
  @override
  Widget build(BuildContext context) {
    final articleProvider = Provider.of<ArticleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('The College View: $categoryName'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              //decoration: BoxDecoration(
              //color: Colors.white, // Change the color of the drawer header
              //),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    // Center the image
                    child: Image.asset(
                      'assets/logo.png', // Path to your logo image
                      height: 135, // Adjust the height of the image
                      width: 300, // Adjust the width of the image
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ArticlesScreen(categoryName: category.name)),
                  );
                },
              );
            }).toList(),
            //ListTile(
            //  title: Text('About'),
            //  onTap: () {
            //    ContentPage(slug: 'about');
            //    Navigator.pop(context); // Close the drawer
            //  },
            //),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _launchURL('https://facebook.com/thecollegeview');
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.all(10.0), // Add padding around the icon
                    child: FaIcon(FontAwesomeIcons.facebook, size: 30),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    _launchURL('https://twitter.com/thecollegeview');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FaIcon(FontAwesomeIcons.xTwitter, size: 30),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    _launchURL('https://instagram.com/thecollegeview');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FaIcon(FontAwesomeIcons.instagram, size: 30),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    _launchURL('https://youtube.com/thecollegeview');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FaIcon(FontAwesomeIcons.youtube, size: 30),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    _launchURL('https://thecollegeview.ie');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FaIcon(FontAwesomeIcons.globe, size: 30),
                  ),
                ),
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
      //String previewText =
      //    _extractTextFromHtml(article.content).split(' ').take(35).join(' ') +
      //    '...';
      String formattedDate = '⏰' +
          DateFormat('MMMM d, y').format(DateTime.parse(article.date));


      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article, categoryName: categoryName),
          ),
        ),
        child: Card(
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

FutureBuilder<String>(
                                future: fetchFeaturedMedia(article.featured_media),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return ClipRRect(
  borderRadius: BorderRadius.circular(8), // Image border
  child: SizedBox.fromSize(
    size: Size.fromRadius(56), // Image radius
    child: Image.network(
      '${snapshot.data}',
      width: 125,
      height: 125, 
    fit: BoxFit.cover),
  ),
);
                                  }
                                },
                              ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(article.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                          Row(
                            children: [
                              Text(formattedDate),
                              SizedBox(width: 10),
                              FutureBuilder<String>(
                                future: fetchAuthorName(article.author),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error');
                                  } else {
                                    return Text('by ${snapshot.data}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]));
                                  }
                                },
                              ),
                            ],
                          ),
                      SizedBox(height: 10),
                      /*HtmlWidget(
                        previewText,
                        renderMode: RenderMode.column,
                        textStyle: TextStyle(fontSize: 16),
                        customStylesBuilder: (element) {
                          if (element.classes.contains('wp-block-image')) {
                            return {'display': 'none'};
                          }
                          return null;
                        },
                      ),*/
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: articleProvider.currentPage > 1
                              ? () => articleProvider.previousPage()
                              : null,
                          child: Text('Previous'),
                        ),
                        Text(
                            'Page ${articleProvider.currentPage} of ${articleProvider.totalPages}'),
                        TextButton(
                          onPressed: articleProvider.currentPage <
                                  articleProvider.totalPages
                              ? () => articleProvider.nextPage()
                              : null,
                          child: Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }

  String _extractTextFromHtml(String htmlContent) {
    RegExp regex = RegExp(r'<p>(.*?)</p>');
    Iterable<Match> matches = regex.allMatches(htmlContent);
    List<String> texts = matches.map((match) => match.group(1) ?? '').toList();
    return texts.join(' ');
  }

  String _extractFirstImageUrl(String htmlContent) {
    dom.Document document = html_parser.parse(htmlContent);
    dom.Element? imgElement = document.querySelector('img');
    return imgElement?.attributes['src'] ?? 'assets/article_placeholder.png';
  }

  Future<String> fetchAuthorName(int authorId) async {
  final response = await http.get(Uri.parse('https://thecollegeview.ie/wp-json/wp/v2/users/$authorId'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['name'];
  } else {
    throw Exception('Failed to load author');
  }
  }

  Future<String> fetchFeaturedMedia(int mediaId) async {
  final response = await http.get(Uri.parse('https://thecollegeview.ie/wp-json/wp/v2/media/$mediaId'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['source_url'];
  } else {
    return 'assets/article_placeholder.png';
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
