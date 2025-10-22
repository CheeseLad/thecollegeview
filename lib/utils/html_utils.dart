import 'package:html/parser.dart' as html_parser;

/// Utility class for HTML-related operations
class HtmlUtils {
  /// Decodes HTML entities in a string
  /// 
  /// This function handles both named entities (like &amp;, &lt;, &gt;) 
  /// and numeric entities (like &#8216;, &#8217;, &#8220;, &#8221;)
  /// 
  /// Examples:
  /// - "&amp;" becomes "&"
  /// - "&#8216;" becomes "'" (left single quotation mark)
  /// - "&#8217;" becomes "'" (right single quotation mark)
  /// - "&#8220;" becomes """ (left double quotation mark)
  /// - "&#8221;" becomes """ (right double quotation mark)
  /// - "&lt;" becomes "<"
  /// - "&gt;" becomes ">"
  /// - "&quot;" becomes "\""
  /// - "&apos;" becomes "'"
  /// - "&nbsp;" becomes " " (non-breaking space)
  static String decodeHtmlEntities(String htmlString) {
    if (htmlString.isEmpty) return htmlString;
    
    // Parse the HTML string and extract the text content
    // This automatically decodes all HTML entities
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? htmlString;
  }
  
  /// Decodes HTML entities and strips HTML tags
  /// 
  /// This is useful when you want plain text without any HTML formatting
  static String decodeHtmlEntitiesAndStripTags(String htmlString) {
    if (htmlString.isEmpty) return htmlString;
    
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? htmlString;
  }
  
  /// Decodes HTML entities but preserves HTML structure
  /// 
  /// This is useful when you want to keep HTML formatting but decode entities
  static String decodeHtmlEntitiesPreserveTags(String htmlString) {
    if (htmlString.isEmpty) return htmlString;
    
    // Replace common HTML entities manually to preserve HTML structure
    String decoded = htmlString
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&#8216;', "'") // left single quotation mark
        .replaceAll('&#8217;', "'") // right single quotation mark
        .replaceAll('&#8218;', "'") // single low-9 quotation mark
        .replaceAll('&#8219;', "'") // single high-reversed-9 quotation mark
        .replaceAll('&#8220;', '"') // left double quotation mark
        .replaceAll('&#8221;', '"') // right double quotation mark
        .replaceAll('&#8222;', '"') // double low-9 quotation mark
        .replaceAll('&#8223;', '"') // double high-reversed-9 quotation mark
        .replaceAll('&#8211;', '–') // en dash
        .replaceAll('&#8212;', '—') // em dash
        .replaceAll('&#8230;', '…') // horizontal ellipsis
        .replaceAll('&#8242;', "'") // prime
        .replaceAll('&#8243;', '"') // double prime
        .replaceAll('&#8364;', '€') // euro sign
        .replaceAll('&#8482;', '™') // trademark sign
        .replaceAll('&#169;', '©') // copyright sign
        .replaceAll('&#174;', '®') // registered sign
        .replaceAll('&#176;', '°') // degree sign
        .replaceAll('&#177;', '±') // plus-minus sign
        .replaceAll('&#215;', '×') // multiplication sign
        .replaceAll('&#247;', '÷'); // division sign
    
    return decoded;
  }
}
