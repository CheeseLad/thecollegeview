import 'dart:convert';

import 'package:http/http.dart' as http;
import '../config/app_urls.dart';
import '../utils/html_utils.dart';
import 'cache_service.dart';

class WpApiService {
  static const String _authorInfoEndpoint = '${AppUrls.apiBase}/get-subheading';

  static final CacheService _cache = CacheService();

  static Future<http.Response> get(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    final cached = _cache.getCached(uri);
    if (cached != null) {
      return cached;
    }

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      await _cache.setCached(uri, response);
    }
    return response;
  }

  static Future<String> fetchAuthorInfo(
    String articleUrl,
    int authorId,
  ) async {
    try {
      final response = await get(
        Uri.parse(_authorInfoEndpoint).replace(
          queryParameters: {'url': articleUrl},
        ),
      );

      if (response.statusCode == 200) {
        final body = response.body.trim();

        if (body.isNotEmpty) {
          try {
            final decoded = jsonDecode(body);

            if (decoded is Map<String, dynamic>) {
              final subheading = decoded['subheading'];

              if (subheading is String && subheading.trim().isNotEmpty) {
                return subheading.trim();
              }
            }
          } catch (_) {
            return body;
          }

          return body;
        }
      }
    } catch (_) {
      // Ignore errors and throw below.
    }

    throw Exception('Failed to load author subheading');
  }

  static Future<String> fetchAuthorName(
    String articleUrl,
    int authorId,
  ) async {
    try {
      final authorName = await fetchAuthorInfo(articleUrl, authorId);
      return HtmlUtils.decodeHtmlEntities(authorName);
    } catch (_) {
      return '';
    }
  }

  static Future<String> fetchFeaturedMediaUrl(int mediaId) async {
    if (mediaId <= 0) return '';
    try {
      final response = await get(
        Uri.parse('${AppUrls.apiBase}/wp-json/wp/v2/media/$mediaId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['source_url'] ?? '';
      }
      return '';
    } catch (_) {
      return '';
    }
  }

  static Future<List<String>> fetchTagNames(List<int> tagIds) async {
    if (tagIds.isEmpty) return [];
    try {
      final url =
          '${AppUrls.apiBase}/wp-json/wp/v2/tags?include=${tagIds.join(',')}';
      final response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data
            .map((item) => HtmlUtils.decodeHtmlEntities(item['name']))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
