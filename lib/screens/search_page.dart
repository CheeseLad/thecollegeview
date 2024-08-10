import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../providers/article_provider.dart';
import 'article_detail_screen.dart'; // Import the new screen
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Article> _filteredArticles = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    final articleProvider = Provider.of<ArticleProvider>(context, listen: false);

    setState(() {
      _filteredArticles = articleProvider.articles.where((article) {
        final title = article.title.toLowerCase();
        final content = article.content.toLowerCase();
        return title.contains(query) || content.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search articles...',
            border: InputBorder.none,
          ),
        ),
leading: IconButton(
  icon: Icon(Icons.arrow_back),  // You can use Icons.arrow_back for a back arrow icon
  onPressed: () {
    Navigator.of(context).pop();  // Navigate back to the previous screen
  },
),

      ),
      body: ListView.builder(
        itemCount: _filteredArticles.length,
        itemBuilder: (context, index) {
          final article = _filteredArticles[index];

          // String previewText = _extractTextFromHtml(article.content).split(' ').take(35).join(' ') + '...';
                          String formattedDate = '⏰' + DateFormat('MMMM d, y').format(DateTime.parse(article.date));
return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleDetailScreen(article: article, categoryName: 'Search Results'),
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
    );
  }
}

  String _extractTextFromHtml(String htmlContent) {
    RegExp regex = RegExp(r'<p>(.*?)</p>');
    Iterable<Match> matches = regex.allMatches(htmlContent);
    List<String> texts = matches.map((match) => match.group(1) ?? '').toList();
    return texts.join(' ');
  }