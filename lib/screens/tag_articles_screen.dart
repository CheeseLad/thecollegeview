import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../models/tag.dart';
import '../widgets/article_list.dart';

class TagArticlesScreen extends StatefulWidget {
  final Tag tag;

  const TagArticlesScreen({super.key, required this.tag});

  @override
  State<TagArticlesScreen> createState() => _TagArticlesScreenState();
}

class _TagArticlesScreenState extends State<TagArticlesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ArticleProvider>(context, listen: false).fetchArticlesByTag(widget.tag.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles tagged: ${widget.tag.name}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<ArticleProvider>(context, listen: false).refreshArticles();
        },
        child: Consumer<ArticleProvider>(
          builder: (context, articleProvider, child) {
            if (articleProvider.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (articleProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${articleProvider.error}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        articleProvider.fetchArticlesByTag(widget.tag.id);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (articleProvider.articles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No articles found for tag "${widget.tag.name}"',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ArticleList(
              categoryName: 'Tag: ${widget.tag.name}',
              articles: articleProvider.articles,
            );
          },
        ),
      ),
    );
  }
}
