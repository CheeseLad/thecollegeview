// lib/screens/articles_screen.dart

import 'package:flutter/material.dart';
import 'package:thecollegeview/screens/search_page.dart';
import '../widgets/cv_navigation_drawer.dart';
import '../widgets/article_list.dart';

class ArticlesScreen extends StatelessWidget {
  final String categoryName;

  const ArticlesScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The College View: $categoryName'),
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
      body: ArticleList(categoryName: categoryName, articles: [],),
    );
  }
}
