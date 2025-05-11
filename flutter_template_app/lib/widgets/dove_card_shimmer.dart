import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DoveCardShimmer extends StatelessWidget {
  const DoveCardShimmer({Key? key}) : super(key: key);

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
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[700]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: isGridLayout ? 140 : 180,
              color: Colors.white,
            ),
            // Title placeholder
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
