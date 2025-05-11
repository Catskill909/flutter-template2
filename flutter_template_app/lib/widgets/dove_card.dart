import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/dove_article.dart';
import '../screens/webview_screen.dart';

class DoveCard extends StatelessWidget {
  final DoveArticle article;

  const DoveCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if we're in a grid layout (tablet/desktop)
    final isGridLayout = MediaQuery.of(context).size.width > 600;

    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: isGridLayout ? 4 : 16, vertical: isGridLayout ? 4 : 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _launchUrl(context, article.link),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Force landscape aspect ratio for the entire card content
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  // Image
                  Positioned.fill(
                    child: Image.network(
                      article.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[800]!,
                          highlightColor: Colors.grey[700]!,
                          child: Container(
                            color: Colors.black,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('Error loading image: $error');
                        return Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.white70, size: 40),
                          ),
                        );
                      },
                    ),
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(204),
                          ],
                          stops: const [0.3, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isGridLayout ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.white70, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              article.town,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.brush,
                                color: Colors.white70, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                article.artist,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchUrl(BuildContext context, String url) {
    if (url.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: url,
          title: article.title,
        ),
      ),
    );
  }
}
