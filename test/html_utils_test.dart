import 'package:flutter_test/flutter_test.dart';
import 'package:thecollegeview/utils/html_utils.dart';
import 'package:thecollegeview/models/category.dart';

void main() {
  group('HtmlUtils', () {
    test('decodeHtmlEntities should decode common HTML entities', () {
      // Test basic HTML entities
      expect(HtmlUtils.decodeHtmlEntities('&amp;'), equals('&'));
      expect(HtmlUtils.decodeHtmlEntities('&lt;'), equals('<'));
      expect(HtmlUtils.decodeHtmlEntities('&gt;'), equals('>'));
      expect(HtmlUtils.decodeHtmlEntities('&quot;'), equals('"'));
      expect(HtmlUtils.decodeHtmlEntities('&apos;'), equals("'"));
      expect(HtmlUtils.decodeHtmlEntities('&nbsp;'), equals(' '));
    });

    test('decodeHtmlEntities should decode numeric entities', () {
      // Test numeric HTML entities
      expect(HtmlUtils.decodeHtmlEntities('&#8216;'), equals("'")); // left single quotation mark
      expect(HtmlUtils.decodeHtmlEntities('&#8217;'), equals("'")); // right single quotation mark
      expect(HtmlUtils.decodeHtmlEntities('&#8220;'), equals('"')); // left double quotation mark
      expect(HtmlUtils.decodeHtmlEntities('&#8221;'), equals('"')); // right double quotation mark
      expect(HtmlUtils.decodeHtmlEntities('&#8211;'), equals('–')); // en dash
      expect(HtmlUtils.decodeHtmlEntities('&#8212;'), equals('—')); // em dash
      expect(HtmlUtils.decodeHtmlEntities('&#8230;'), equals('…')); // horizontal ellipsis
    });

    test('decodeHtmlEntities should handle complex strings', () {
      String input = 'This is a test with &amp; symbols and &#8216;quotes&#8217; and &#8220;double quotes&#8221;.';
      String expected = 'This is a test with & symbols and \'quotes\' and "double quotes".';
      expect(HtmlUtils.decodeHtmlEntities(input), equals(expected));
    });

    test('decodeHtmlEntitiesAndStripTags should remove HTML tags and decode entities', () {
      String input = '<p>This is a <strong>test</strong> with &amp; symbols and &#8216;quotes&#8217;.</p>';
      String expected = 'This is a test with & symbols and \'quotes\'.';
      expect(HtmlUtils.decodeHtmlEntitiesAndStripTags(input), equals(expected));
    });

    test('decodeHtmlEntitiesPreserveTags should decode entities but keep HTML structure', () {
      String input = '<p>This is a test with &amp; symbols and &#8216;quotes&#8217;.</p>';
      String expected = '<p>This is a test with & symbols and \'quotes\'.</p>';
      expect(HtmlUtils.decodeHtmlEntitiesPreserveTags(input), equals(expected));
    });

    test('should handle empty strings', () {
      expect(HtmlUtils.decodeHtmlEntities(''), equals(''));
      expect(HtmlUtils.decodeHtmlEntitiesAndStripTags(''), equals(''));
      expect(HtmlUtils.decodeHtmlEntitiesPreserveTags(''), equals(''));
    });

    test('should handle strings without HTML entities', () {
      String input = 'This is a normal string without any HTML entities.';
      expect(HtmlUtils.decodeHtmlEntities(input), equals(input));
      expect(HtmlUtils.decodeHtmlEntitiesAndStripTags(input), equals(input));
      expect(HtmlUtils.decodeHtmlEntitiesPreserveTags(input), equals(input));
    });
  });

  group('Category HTML Entity Decoding', () {
    test('Category.fromJson should decode HTML entities in category names', () {
      final jsonData = {
        'id': 1,
        'name': 'News &amp; Updates',
        'parent': null,
      };

      final category = Category.fromJson(jsonData);
      expect(category.name, equals('News & Updates'));
    });

    test('Category.fromJson should handle complex HTML entities in category names', () {
      final jsonData = {
        'id': 2,
        'name': 'Sports &#8211; College Life',
        'parent': null,
      };

      final category = Category.fromJson(jsonData);
      expect(category.name, equals('Sports – College Life'));
    });

    test('Category.fromJson should handle quotes in category names', () {
      final jsonData = {
        'id': 3,
        'name': '&#8220;Opinion&#8221; &amp; Editorials',
        'parent': null,
      };

      final category = Category.fromJson(jsonData);
      expect(category.name, equals('"Opinion" & Editorials'));
    });

    test('Category.fromJson should handle normal category names without entities', () {
      final jsonData = {
        'id': 4,
        'name': 'Technology',
        'parent': null,
      };

      final category = Category.fromJson(jsonData);
      expect(category.name, equals('Technology'));
    });
  });
}
