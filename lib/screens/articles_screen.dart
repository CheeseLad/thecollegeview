import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thecollegeview/screens/search_page.dart';
import '../widgets/cv_navigation_drawer.dart';
import '../widgets/article_list.dart';
import '../providers/saved_articles_provider.dart';

class ArticlesScreen extends StatefulWidget {
  final String categoryName;

  const ArticlesScreen({super.key, required this.categoryName});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SavedArticlesProvider>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      drawer: const CVNavigationDrawer(),
      body: ArticleList(
        categoryName: widget.categoryName,
        articles: [],
      ),
    );
  }
}
