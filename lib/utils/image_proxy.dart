import 'package:http/http.dart' as http;

class ImageProxy {
  static const String _proxyUrl = 'https://images.weserv.nl/?url=';
  
  /// Converts an image URL to use a CORS-friendly proxy
  /// This helps bypass CORS issues when loading images from external domains
  static String getProxiedImageUrl(String originalUrl) {
    if (originalUrl.isEmpty) return originalUrl;
    
    // If the URL is already proxied, return as is
    if (originalUrl.contains('weserv.nl') || originalUrl.contains('cors-anywhere')) {
      return originalUrl;
    }
    
    // Encode the original URL to be safe for the proxy
    final encodedUrl = Uri.encodeComponent(originalUrl);
    return '$_proxyUrl$encodedUrl';
  }
  
  /// Alternative proxy using cors-anywhere (if weserv.nl is not available)
  static String getCorsAnywhereUrl(String originalUrl) {
    if (originalUrl.isEmpty) return originalUrl;
    
    // For development, you can use a local cors-anywhere instance
    // For production, you'd need to deploy your own cors-anywhere server
    const String corsProxy = 'https://cors-anywhere.herokuapp.com/';
    return '$corsProxy$originalUrl';
  }
  
  /// Check if an image URL is accessible (useful for fallback logic)
  static Future<bool> isImageAccessible(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
