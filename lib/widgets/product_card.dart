import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:marketcoop/models/product.dart';
import 'package:marketcoop/providers/cart_provider.dart';
import 'package:marketcoop/screens/product_detail_screen.dart';
import 'package:marketcoop/providers/wishlist_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: product.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<WishlistProvider>(
                      builder: (context, wishlistProvider, child) {
                        final isInWishlist =
                            wishlistProvider.isInWishlist(product);
                        return IconButton(
                          icon: Icon(
                            isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isInWishlist ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            if (isInWishlist) {
                              wishlistProvider.removeFromWishlist(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Removed from wishlist'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            } else {
                              wishlistProvider.addToWishlist(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to wishlist'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Text(
                      product.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Category
                    Text(
                      product.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),

                    // Price and Add to Cart
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${product.price.toStringAsFixed(2)} MAD',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          Consumer<CartProvider>(
                            builder: (context, cartProvider, child) {
                              final isInCart = cartProvider.isInCart(product.id);
                              return TextButton.icon(
                                onPressed: () {
                                  if (isInCart) {
                                    cartProvider.removeItem(product.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Removed from cart'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  } else {
                                    cartProvider.addItem(product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Added to cart'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(
                                  isInCart
                                      ? Icons.remove_shopping_cart
                                      : Icons.add_shopping_cart,
                                  size: 20,
                                  color: isInCart
                                      ? Colors.red
                                      : Theme.of(context).colorScheme.primary,
                                ),
                                label: Text(isInCart ? 'Remove' : 'Buy'),
                                style: TextButton.styleFrom(
                                  minimumSize: Size(0, 32),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
