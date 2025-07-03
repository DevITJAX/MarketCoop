import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/comment_provider.dart';
import '../providers/review_provider.dart';
import '../models/product.dart';
import '../models/comment.dart';
import '../models/review.dart';
import 'add_product_screen.dart';

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    return Scaffold(
      appBar: AppBar(title: const Text('My Products'), centerTitle: true),
      body: user == null
          ? const Center(child: Text('You must be logged in.'))
          : Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                final myProducts = productProvider.products
                    .where((p) => p.producerId == user.id)
                    .toList();
                if (productProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (myProducts.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: myProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final product = myProducts[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(product.title),
                        subtitle: Text(product.category),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.comment, color: Colors.green),
                              tooltip: 'View Comments',
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(child: CircularProgressIndicator()),
                                );
                                final commentProvider = Provider.of<CommentProvider>(context, listen: false);
                                await commentProvider.fetchComments(product.id);
                                Navigator.of(context).pop(); // Remove loading dialog
                                final comments = commentProvider.getCommentsForProduct(product.id);
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Comments for ${product.title}'),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      child: comments.isEmpty
                                          ? Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.info_outline, color: Colors.grey, size: 40),
                                                SizedBox(height: 8),
                                                Text('No comments yet.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                                              ],
                                            )
                                          : ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: comments.length,
                                              separatorBuilder: (_, __) => const Divider(),
                                              itemBuilder: (context, idx) {
                                                final comment = comments[idx];
                                                return ListTile(
                                                  leading: CircleAvatar(child: Text(comment.userName.isNotEmpty ? comment.userName[0] : '?')),
                                                  title: Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  subtitle: Text(comment.comment),
                                                  trailing: Text(
                                                    '${comment.timestamp.day}/${comment.timestamp.month}/${comment.timestamp.year}',
                                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.star, color: Colors.amber),
                              tooltip: 'View Reviews',
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(child: CircularProgressIndicator()),
                                );
                                final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
                                await reviewProvider.fetchReviews(product.id);
                                Navigator.of(context).pop(); // Remove loading dialog
                                final reviews = reviewProvider.getReviewsForProduct(product.id);
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Reviews for ${product.title}'),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      child: reviews.isEmpty
                                          ? Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.info_outline, color: Colors.grey, size: 40),
                                                SizedBox(height: 8),
                                                Text('No reviews yet.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                                              ],
                                            )
                                          : ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: reviews.length,
                                              separatorBuilder: (_, __) => const Divider(),
                                              itemBuilder: (context, idx) {
                                                final review = reviews[idx];
                                                return ListTile(
                                                  leading: CircleAvatar(child: Text(review.userName.isNotEmpty ? review.userName[0] : '?')),
                                                  title: Row(
                                                    children: [
                                                      Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                      const SizedBox(width: 8),
                                                      Icon(Icons.star, color: Colors.amber, size: 18),
                                                      Text('${review.rating}/10'),
                                                    ],
                                                  ),
                                                  subtitle: review.comment.isNotEmpty ? Text(review.comment) : null,
                                                  trailing: Text(
                                                    '${review.timestamp.day}/${review.timestamp.month}/${review.timestamp.year}',
                                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AddProductScreen(
                                        // Optionally pass product for editing
                                        ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await Provider.of<ProductProvider>(context,
                                        listen: false)
                                    .deleteProduct(product.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Product deleted.')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Product',
      ),
    );
  }
}
