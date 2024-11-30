import 'package:flutter/material.dart';
import 'package:news/provider/news_provider.dart';
import 'package:news/model/news_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch all categories when the screen loads
    Provider.of<NewsProvider>(context, listen: false).fetchAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CategorySelector(), // Optional category selector
          Expanded(
            child: NewsList(), // Display aggregated news articles
          ),
        ],
      ),
    );
  }
}

class CategorySelector extends StatelessWidget {
  final List<String> categories = [
    //'general',
    'business',
    'sports',
    'technology'
  ];

  CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Provider.of<NewsProvider>(context, listen: false)
                  .fetchHeadlines(category);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(label: Text(category)),
            ),
          );
        },
      ),
    );
  }
}

class NewsList extends StatelessWidget {
  const NewsList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewsProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.articles.isEmpty) {
      return const Center(child: Text('No articles found.'));
    }

    return ListView.builder(
      itemCount: provider.articles.length,
      itemBuilder: (context, index) {
        final article = provider.articles[index];
        return ListTile(
          leading: article.imageUrl.isNotEmpty
              ? Image.network(article.imageUrl, width: 50, fit: BoxFit.cover)
              : null,
          title: Text(article.title),
          subtitle: Text(article.description),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailPage(article: article),
              ),
            );
          },
        );
      },
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final News article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: Column(
        children: [
          if (article.imageUrl.isNotEmpty) Image.network(article.imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(article.description),
          ),
          ElevatedButton(
            onPressed: () async {
              final url = article.url; // The URL of the article
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                // Show an error message if the URL cannot be launched
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch the article')),
                );
              }
            },
            child: const Text('Read More'),
          ),
        ],
      ),
    );
  }
}
