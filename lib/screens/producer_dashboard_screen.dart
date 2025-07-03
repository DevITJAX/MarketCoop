import 'package:flutter/material.dart';
import 'my_products_screen.dart';
import 'add_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../providers/review_provider.dart';
import '../providers/comment_provider.dart';
import '../models/review.dart';
import '../models/comment.dart';

class ProducerDashboardScreen extends StatelessWidget {
  const ProducerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Producer Dashboard'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.list),
                  label: const Text('View My Products'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MyProductsScreen()),
                    );
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AddProductScreen()),
                    );
                  },
                ),
                const SizedBox(height: 32),
                // New section: Reviews & Comments summary for this producer
                _ProducerReviewsAndCommentsSummary(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget to show all reviews and comments for the producer's products
class _ProducerReviewsAndCommentsSummary extends StatefulWidget {
  @override
  State<_ProducerReviewsAndCommentsSummary> createState() => _ProducerReviewsAndCommentsSummaryState();
}

class _ProducerReviewsAndCommentsSummaryState extends State<_ProducerReviewsAndCommentsSummary> {
  bool _loading = false;
  String? _error;
  List<Review> _allReviews = [];
  List<Comment> _allComments = [];
  double _averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  Future<void> _fetchData() async {
    setState(() { _loading = true; _error = null; });
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
      final commentProvider = Provider.of<CommentProvider>(context, listen: false);
      final user = authProvider.user;
      if (user == null) throw Exception('Not logged in');
      // Ensure products are loaded
      if (productProvider.products.isEmpty) await productProvider.loadProducts();
      final myProducts = productProvider.products.where((p) => p.producerId == user.id).toList();
      final productIds = myProducts.map((p) => p.id).toList();
      await reviewProvider.fetchReviewsForProducts(productIds);
      await commentProvider.fetchCommentsForProducts(productIds);
      final reviews = reviewProvider.getReviewsForProducts(productIds);
      final comments = commentProvider.getCommentsForProducts(productIds);
      double avg = 0.0;
      if (reviews.isNotEmpty) {
        avg = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
      }
      setState(() {
        _allReviews = reviews;
        _allComments = comments;
        _averageRating = avg;
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Text('Error: \\$_error', style: const TextStyle(color: Colors.red));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your Products\' Reviews & Comments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber),
            Text(' Average Rating: \\${_averageRating.toStringAsFixed(2)}'),
            const SizedBox(width: 16),
            Icon(Icons.rate_review, color: Colors.blueGrey),
            Text(' Reviews: \\${_allReviews.length}'),
            const SizedBox(width: 16),
            Icon(Icons.comment, color: Colors.green),
            Text(' Comments: \\${_allComments.length}'),
          ],
        ),
        const SizedBox(height: 16),
        if (_allReviews.isNotEmpty) ...[
          const Text('Recent Reviews:', style: TextStyle(fontWeight: FontWeight.bold)),
          ..._allReviews.take(3).map((review) => ListTile(
                leading: CircleAvatar(child: Text(review.userName.isNotEmpty ? review.userName[0] : '?')),
                title: Row(
                  children: [
                    Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    Text('\\${review.rating}/10'),
                  ],
                ),
                subtitle: review.comment.isNotEmpty ? Text(review.comment) : null,
                trailing: Text(
                  '${review.timestamp.day}/${review.timestamp.month}/${review.timestamp.year}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              )),
        ],
        if (_allComments.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text('Recent Comments:', style: TextStyle(fontWeight: FontWeight.bold)),
          ..._allComments.take(3).map((comment) => ListTile(
                leading: CircleAvatar(child: Text(comment.userName.isNotEmpty ? comment.userName[0] : '?')),
                title: Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(comment.comment),
                trailing: Text(
                  '${comment.timestamp.day}/${comment.timestamp.month}/${comment.timestamp.year}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              )),
        ],
        if (_allReviews.isEmpty && _allComments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('No reviews or comments yet.', style: TextStyle(color: Colors.grey)),
          ),
        const SizedBox(height: 8),
        TextButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh'),
          onPressed: _fetchData,
        ),
      ],
    );
  }
}
