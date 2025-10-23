import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/article_provider.dart';
import 'providers/saved_articles_provider.dart';
import 'screens/articles_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ArticleProvider()),
        ChangeNotifierProvider(create: (context) => SavedArticlesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The College View',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[400],
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            background: Colors.grey[400]!,
          ),
        ),
        home: const ArticlesScreen(categoryName: "All Articles"),
      ),
    );
  }
}
