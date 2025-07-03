import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlist = wishlistProvider.wishlist;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: wishlist.isEmpty
          ? const Center(child: Text('Your wishlist is empty.'))
          : ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final product = wishlist[index];
                return ProductCard(product: product);
              },
            ),
    );
  }
}
