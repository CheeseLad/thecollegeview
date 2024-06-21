// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import 'package:intl/intl.dart'; // Import the intl package
import 'providers/article_provider.dart';
import 'screens/search_page.dart';
import 'models/article.dart';
import 'screens/article_detail_screen.dart'; // Import the new screen
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

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
        title: Text('The College View'), // Website name to the left
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
      Center( // Center the image
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
                },
              );
            }).toList(),
            SizedBox(height: 20),
            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    InkWell(
  onTap: () {
    _launchURL('https://facebook.com/thecollegeview');
  },
  child: Padding(
    padding: EdgeInsets.all(10.0), // Add padding around the icon
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
                          //String previewText = article.content.split(' ').take(30).join(' ') + '...';
                          String previewText = _extractTextFromHtml(article.content).split(' ').take(35).join(' ') + '...';
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
                                    //Text(previewText),
                                    HtmlWidget(article.content.split(' ').take(35).join(' ') + '...',
                                    renderMode: RenderMode.column,
                                    textStyle: TextStyle(fontSize: 16),
                                    customStylesBuilder: (element) {
                                      if (element.classes.contains('wp-block-image')) {
                                        return {'display': 'none'};
                                      }
                                      return null;
                                    },
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

  String _extractTextFromHtml(String htmlContent) {
    RegExp regex = RegExp(r'<p>(.*?)</p>');
    Iterable<Match> matches = regex.allMatches(htmlContent);
    List<String> texts = matches.map((match) => match.group(1) ?? '').toList();
    return texts.join(' ');
  }

    void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
