import 'package:flutter/material.dart';
import 'package:news/controller/news_controller.dart';
import 'package:news/model/news_model.dart';

class NewsProvider with ChangeNotifier {
  final NewsController newsApiService = NewsController();

  List<News> articleList = [];
  bool loading = false;

  // Public getters
  List<News> get articles => articleList;
  bool get isLoading => loading;

  /// Fetch news headlines for a specific category
  Future<void> fetchHeadlines(String category) async {
    loading = true;
    notifyListeners();

    try {
      final results =
          await newsApiService.fetchTopHeadlines(category: category);
      articleList = results.map((json) => News.fromJson(json)).toList();
    } catch (error) {
      articleList = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Fetch news from all categories and combine them
  Future<void> fetchAllCategories() async {
    loading = true;
    notifyListeners();

    List<News> allArticles = [];
    final categories = ['general', 'business', 'sports', 'technology'];

    try {
      for (String category in categories) {
        final results =
            await newsApiService.fetchTopHeadlines(category: category);
        final categoryArticles =
            results.map((json) => News.fromJson(json)).toList();
        allArticles.addAll(categoryArticles);
      }
      articleList = allArticles;
    } catch (error) {
      articleList = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
