import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/article_provider.dart';
import 'screens/articles_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArticleProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The College View',
        home: ArticlesScreen(categoryName: "All Articles"),
      ),
    );
  }
}
