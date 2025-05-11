import 'package:flutter/material.dart';
import '../models/dove_article.dart';
import '../services/rss_service.dart';
import '../widgets/dove_card.dart';
import '../widgets/dove_card_shimmer.dart';

class Tab1Screen extends StatefulWidget {
  const Tab1Screen({Key? key}) : super(key: key);

  @override
  State<Tab1Screen> createState() => _Tab1ScreenState();
}

class _Tab1ScreenState extends State<Tab1Screen> {
  final RssService _rssService = RssService();
  late Future<List<DoveArticle>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = _rssService.fetchDoveArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _articlesFuture = _rssService.fetchDoveArticles();
          });
        },
        child: FutureBuilder<List<DoveArticle>>(
          future: _articlesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingList();
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error.toString());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyWidget();
            } else {
              return _buildArticlesList(snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingList() {
    // Determine the number of columns based on screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Use 2 columns for tablet/desktop (width > 600)
    final crossAxisCount = screenWidth > 600 ? 2 : 1;

    return GridView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 24, left: 8, right: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: screenWidth > 600 ? 1.0 : 1.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: crossAxisCount * 3, // Show more shimmer items for grid
      itemBuilder: (context, index) => const DoveCardShimmer(),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Dove Trail',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pull down to refresh and try again',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _articlesFuture = _rssService.fetchDoveArticles();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'No Dove Trail Articles Found',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh and try again',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesList(List<DoveArticle> articles) {
    // Determine the number of columns based on screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Use 2 columns for tablet/desktop (width > 600)
    final crossAxisCount = screenWidth > 600 ? 2 : 1;

    return GridView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 24, left: 8, right: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: screenWidth > 600
            ? 1.0
            : 1.2, // Adjust aspect ratio for different layouts
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return DoveCard(article: articles[index]);
      },
    );
  }
}
