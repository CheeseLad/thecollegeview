import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import '../models/category.dart';

class ArticleProvider with ChangeNotifier {
  List<Article> _articles = [];
  List<Category> _categories = [];
  bool _loading = false;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;
  int? _selectedCategory;

  List<Article> get articles => _articles;
  List<Category> get categories => _categories;
  bool get loading => _loading;
  String? get error => _error;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int? get selectedCategory => _selectedCategory;

  ArticleProvider() {
    fetchCategories();
    fetchArticles();
  }

  Future<void> fetchCategories() async {
    const url =
        'https://thecollegeview.ie/wp-json/wp/v2/categories?include=4,7,5,687,6,220,68,9890,90,6880';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<Category> loadedCategories = (json.decode(response.body) as List)
            .map((data) => Category.fromJson(data))
            .toList();
        _categories = loadedCategories;
        notifyListeners();
      } else {
        _error = 'Failed to load categories';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchStickyArticles() async {
    const url =
        'https://thecollegeview.ie/wp-json/wp/v2/posts?sticky=true&_fields=id,date,title,content,link,author,featured_media';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<Article> loadedArticles = (json.decode(response.body) as List)
            .map((data) => Article.fromJson(data))
            .toList();
        _articles = loadedArticles;
        _error = null;
      } else {
        _error = 'Failed to load sticky articles';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchArticles() async {
    _loading = true;
    notifyListeners();

    final categoryFilter =
        _selectedCategory != null ? '&categories=$_selectedCategory' : '';
    final url =
        'https://thecollegeview.ie/wp-json/wp/v2/posts/?page=$_currentPage&per_page=10$categoryFilter&_fields=id,date,title,content,link,author,featured_media';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<Article> loadedArticles = (json.decode(response.body) as List)
            .map((data) => Article.fromJson(data))
            .toList();
        _articles = loadedArticles;
        _totalPages = int.parse(response.headers['x-wp-totalpages']!);
        _error = null;
      } else {
        _error = 'Failed to load articles';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> searchArticles(String searchQuery) async {
    final url =
        'https://thecollegeview.ie/wp-json/wp/v2/posts?search=$searchQuery';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _articles = data.map((json) => Article.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (error) {
      print('Error searching articles: $error');
    }
  }

  void nextPage() {
    if (_currentPage < _totalPages) {
      _currentPage++;
      fetchArticles();
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      fetchArticles();
    }
  }

  void selectCategory(int? categoryId) {
    _selectedCategory = categoryId;
    _currentPage = 1;
    fetchArticles();
  }
}
