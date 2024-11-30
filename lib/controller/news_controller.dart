import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsController {
  static const String apiKey = '9fb23dc67c1540e093b0c84ab91db799';
  static const String baseUrl = 'https://newsapi.org/v2';

  Future<List<dynamic>> fetchTopHeadlines({String category = 'general'}) async {
    final url = Uri.parse(
        '$baseUrl/top-headlines?country=us&category=$category&apiKey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<dynamic>> searchNews(String query) async {
    final url = Uri.parse('$baseUrl/everything?q=$query&apiKey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}
