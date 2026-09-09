import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../models/tag.dart';
import '../providers/article_provider.dart';
import '../providers/saved_articles_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share_plus/share_plus.dart';
import '../services/wp_api_service.dart';
import '../widgets/network_image_with_fallback.dart';
import 'tag_articles_screen.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;
  final String categoryName;
  final String? featuredMediaUrl;
  final String? authorName;
  final List<String>? tagNames;

  const ArticleDetailScreen({
    super.key,
    required this.article,
    required this.categoryName,
    this.featuredMediaUrl,
    this.authorName,
    this.tagNames,
  });

  Future<String> _resolveAuthorName(BuildContext context) async {
    final cached = authorName;
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    final fetched = await WpApiService.fetchAuthorName(article.link, article.author);
    return fetched;
  }

  Future<String> _resolveFeaturedMediaUrl(BuildContext context) async {
    final cached = featuredMediaUrl;
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    final fetched = await WpApiService.fetchFeaturedMediaUrl(article.featured_media);
    return fetched;
  }

  Future<List<String>> _resolveTagNames(BuildContext context) async {
    final cached = tagNames;
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    final fetched = await WpApiService.fetchTagNames(article.tags);
    return fetched;
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        '⏰ ${DateFormat('MMMM d, y').format(DateTime.parse(article.date))}';
    final savedArticlesProvider = Provider.of<SavedArticlesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(
              icon: Icon(
                savedArticlesProvider.isArticleSaved(article.id)
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                color: savedArticlesProvider.isArticleSaved(article.id)
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                savedArticlesProvider.toggleSaveArticle(article, categoryName);
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(
                article.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(formattedDate,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
                  FutureBuilder<String>(
                    future: _resolveAuthorName(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error');
                      } else {
                         return Text(
                           '👤 ${snapshot.data}',
                           style: TextStyle(
                             fontSize: 16,
                             color: Theme.of(context).colorScheme.onSurfaceVariant,
                           ),
                         );
                      }
                    },
                  ),
                   Text(
                    '📂 $categoryName',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                   ),
                ],
              ),
              // Show tag on a new line if viewing tagged articles
              if (categoryName.startsWith('Tag: ')) ...[
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text('🏷️ '),
                    Text(
                      () {
                        final tagName = categoryName.substring(5);
                        return tagName.isEmpty
                            ? tagName
                            : tagName[0].toUpperCase() + tagName.substring(1);
                      }(),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              // Display featured media if available
              if (article.featured_media > 0)
                FutureBuilder<String>(
                  future: _resolveFeaturedMediaUrl(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: NetworkImageWithFallback(
                          imageUrl: snapshot.data!,
                          fallbackAssetPath: 'assets/logo.png',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              HtmlWidget(
                article.content,
                renderMode: RenderMode.column,
                textStyle: const TextStyle(fontSize: 16),
                customStylesBuilder: (element) {
                  if (element.localName == 'img') {
                    return {
                      'border-radius': '10px',
                    };
                  }
                  return null;
                },
                customWidgetBuilder: (element) {
                  if (element.localName == 'img') {
                    final src = element.attributes['src'];
                    if (src != null && src.isNotEmpty) {
                      return NetworkImageWithFallback(
                        imageUrl: src,
                        fallbackAssetPath: 'assets/logo.png',
                        borderRadius: BorderRadius.circular(10),
                      );
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Display tags if available
              if (article.tags.isNotEmpty) ...[
                FutureBuilder<List<String>>(
                  future: _resolveTagNames(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //const Text(
                            //  'Tags:',
                            //  style: TextStyle(
                            //    fontSize: 16,
                            //    fontWeight: FontWeight.bold,
                            //    color: Colors.grey,
                            //  ),
                            //),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: snapshot.data!.asMap().entries.map((entry) {
                                final index = entry.key;
                                final tagName = entry.value;
                                final tagId = article.tags[index];
                                
                                return GestureDetector(
                                  onTap: () async {
                                    // Create a Tag object for navigation
                                    final tag = Tag(
                                      id: tagId,
                                      name: tagName,
                                      slug: tagName.toLowerCase().replaceAll(' ', '-'),
                                      description: '',
                                      count: 0,
                                    );
                                    
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TagArticlesScreen(tag: tag),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Theme.of(context).colorScheme.primary,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          tagName,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 12,
                                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ] else ...[
                const SizedBox.shrink(),
              ],
              GestureDetector(
                onTap: () {
                  Share.shareUri(Uri.parse(article.link));
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 1.0),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share),
                      SizedBox(width: 8.0),
                      Text(
                        "Share",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _RelatedArticlesSection(
                article: article,
                categoryName: categoryName,
              ),
            ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class _RelatedArticlesSection extends StatefulWidget {
  final Article article;
  final String categoryName;

  const _RelatedArticlesSection({
    required this.article,
    required this.categoryName,
  });

  @override
  State<_RelatedArticlesSection> createState() => _RelatedArticlesSectionState();
}

class _RelatedArticlesSectionState extends State<_RelatedArticlesSection> {
  late final Future<List<Article>> _relatedFuture;

  @override
  void initState() {
    super.initState();
    _relatedFuture = Provider.of<ArticleProvider>(context, listen: false)
        .getRelatedArticles(widget.article);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: _relatedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }
        final related = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Related Articles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            ...related.map((relatedArticle) => _RelatedArticleCard(
              article: relatedArticle,
              categoryName: widget.categoryName,
            )).toList(),
          ],
        );
      },
    );
  }
}

class _RelatedArticleCard extends StatelessWidget {
  final Article article;
  final String categoryName;

  const _RelatedArticleCard({
    required this.article,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        '⏰ ${DateFormat('MMMM d, y').format(DateTime.parse(article.date))}';

    return FutureBuilder<_CardDetails>(
      future: _loadDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 125,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final details =
            snapshot.data ?? _CardDetails(imageUrl: '', authorName: '');

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailScreen(
                  article: article,
                  categoryName: categoryName,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NetworkImageWithFallback(
                    imageUrl: details.imageUrl,
                    fallbackAssetPath: 'assets/logo.png',
                    width: 125,
                    height: 125,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(article.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(formattedDate),
                            const SizedBox(height: 5),
                            SelectableText('👤 ${details.authorName}'),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<_CardDetails> _loadDetails() async {
    final results = await Future.wait([
      WpApiService.fetchFeaturedMediaUrl(article.featured_media),
      WpApiService.fetchAuthorName(article.link, article.author),
    ]);
    return _CardDetails(imageUrl: results[0], authorName: results[1]);
  }
}

class _CardDetails {
  final String imageUrl;
  final String authorName;
  const _CardDetails({required this.imageUrl, required this.authorName});
}
