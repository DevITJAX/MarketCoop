import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:marketcoop/models/product.dart';
import 'package:marketcoop/providers/cart_provider.dart';
import 'package:marketcoop/providers/review_provider.dart';
import 'package:marketcoop/models/review.dart';
import 'package:marketcoop/providers/auth_provider.dart';
import 'package:marketcoop/providers/comment_provider.dart';
import 'package:marketcoop/models/comment.dart';
import 'package:marketcoop/providers/product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  int _reviewScore = 10;
  final _reviewController = TextEditingController();
  final _commentController = TextEditingController();
  bool _isSubmittingReview = false;
  bool _isSubmittingComment = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ReviewProvider>(context, listen: false)
          .listenToReviews(widget.product.id);
      Provider.of<CommentProvider>(context, listen: false)
          .listenToComments(widget.product.id);
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final commentProvider = Provider.of<CommentProvider>(context);
    final reviews = reviewProvider.getReviewsForProduct(widget.product.id);
    final averageScore = reviewProvider.getAverageScore(widget.product.id);
    final userId = authProvider.user?.id ?? '';
    final hasReviewed = reviews.any((r) => r.userId == userId);
    final comments = commentProvider.getCommentsForProduct(widget.product.id);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text(widget.product.title)),
            if (averageScore > 0)
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 22),
                  const SizedBox(width: 2),
                  Text(
                    averageScore.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text('/10'),
                ],
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // TODO: Implement wishlist
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to wishlist'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
                child: widget.product.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: widget.product.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title
                  Text(
                    widget.product.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Category
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.product.category,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Row(
                    children: [
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const Spacer(),
                      if (widget.product.stockQuantity > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'In Stock (${widget.product.stockQuantity})',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Out of Stock',
                            style: TextStyle(
                              color: Colors.red[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Quantity Selector
                  if (widget.product.stockQuantity > 0) ...[
                    Text(
                      'Quantity',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _quantity > 1
                              ? () {
                                  setState(() {
                                    _quantity--;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.remove),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            '$_quantity',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        IconButton(
                          onPressed: _quantity < widget.product.stockQuantity
                              ? () {
                                  setState(() {
                                    _quantity++;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Total: \$${(widget.product.price * _quantity).toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Add to Cart Button
                  Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      final isInCart = cartProvider.isInCart(widget.product.id);
                      final isAvailable = widget.product.stockQuantity > 0;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isAvailable
                              ? () {
                                  if (isInCart) {
                                    cartProvider.removeItem(widget.product.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Removed from cart'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  } else {
                                    cartProvider.addItem(widget.product,
                                        quantity: _quantity);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Added to cart'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                }
                              : null, // disables button if not available
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: isInCart
                                ? Colors.red
                                : Theme.of(context).colorScheme.primary,
                          ),
                          child: Text(
                            isInCart ? 'Remove from Cart' : 'Add to Cart',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),

                  // --- REVIEWS SECTION ---
                  const SizedBox(height: 32),
                  Text(
                    'Reviews',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (reviews.isEmpty) const Text('No reviews yet.'),
                  if (reviews.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return ListTile(
                          leading: CircleAvatar(
                              child: Text(review.userName.isNotEmpty
                                  ? review.userName[0]
                                  : '?')),
                          title: Row(
                            children: [
                              Text(review.userName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              Text('${review.rating}/10'),
                            ],
                          ),
                          subtitle: review.comment.isNotEmpty
                              ? Text(review.comment)
                              : null,
                          trailing: Text(
                            '${review.timestamp.day}/${review.timestamp.month}/${review.timestamp.year}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                  if (!hasReviewed && userId.isNotEmpty)
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add your review',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text('Score:'),
                                const SizedBox(width: 8),
                                DropdownButton<int>(
                                  value: _reviewScore,
                                  items: List.generate(10, (i) => i + 1)
                                      .map((score) => DropdownMenuItem(
                                            value: score,
                                            child: Text('$score'),
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        _reviewScore = val;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _reviewController,
                              decoration: const InputDecoration(
                                labelText: 'Comment (optional)',
                                border: OutlineInputBorder(),
                              ),
                              minLines: 1,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSubmittingReview
                                    ? null
                                    : () async {
                                        setState(() {
                                          _isSubmittingReview = true;
                                        });
                                        final user = authProvider.user;
                                        if (user == null) return;
                                        final review = Review(
                                          id: '',
                                          productId: widget.product.id,
                                          userId: user.id,
                                          userName:
                                              user.displayName ?? user.email,
                                          rating: _reviewScore,
                                          comment:
                                              _reviewController.text.trim(),
                                          timestamp: DateTime.now(),
                                        );
                                        await reviewProvider.addReview(review);
                                        setState(() {
                                          _isSubmittingReview = false;
                                          _reviewScore = 10;
                                          _reviewController.clear();
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Review submitted!'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                child: _isSubmittingReview
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : const Text('Submit Review'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // --- END REVIEWS SECTION ---

                  // --- COMMENTS SECTION ---
                  const SizedBox(height: 32),
                  Text(
                    'Comments',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (comments.isEmpty) const Text('No comments yet.'),
                  if (comments.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final comment = comments[index];
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
                  const SizedBox(height: 16),
                  if (userId.isNotEmpty)
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add a comment', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _commentController,
                              decoration: const InputDecoration(
                                labelText: 'Your comment',
                                border: OutlineInputBorder(),
                              ),
                              minLines: 1,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSubmittingComment
                                    ? null
                                    : () async {
                                        setState(() {
                                          _isSubmittingComment = true;
                                        });
                                        final user = authProvider.user;
                                        if (user == null) return;
                                        final comment = Comment(
                                          id: '',
                                          productId: widget.product.id,
                                          userId: user.id,
                                          userName: user.displayName ?? user.email,
                                          comment: _commentController.text.trim(),
                                          timestamp: DateTime.now(),
                                        );
                                        await commentProvider.addComment(comment);
                                        setState(() {
                                          _isSubmittingComment = false;
                                          _commentController.clear();
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Comment added!'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                child: _isSubmittingComment
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Text('Submit Comment'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // --- END COMMENTS SECTION ---
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
