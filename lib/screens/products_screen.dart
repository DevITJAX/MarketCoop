import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marketcoop/providers/product_provider.dart';
import 'package:marketcoop/widgets/product_card.dart';
import 'package:marketcoop/widgets/category_chip.dart';
import 'package:marketcoop/screens/role_selection_screen.dart';
import 'package:marketcoop/screens/profile_screen.dart';
import 'package:marketcoop/providers/auth_provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Products',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          Provider.of<ProductProvider>(context, listen: false)
                              .searchProducts('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                Provider.of<ProductProvider>(context, listen: false)
                    .searchProducts(value);
              },
            ),
          ),

          // Categories Filter
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              return SizedBox(
                height: 50,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: productProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = productProvider.categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CategoryChip(
                        label: category,
                        isSelected:
                            productProvider.selectedCategory == category,
                        onTap: () {
                          productProvider.filterByCategory(category);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Products Grid
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (productProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Products',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          productProvider.error!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            productProvider.loadProducts();
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final products = productProvider.filteredProducts;

                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: products[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Products'),
        content: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Category'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: productProvider.categories.map((category) {
                    return ChoiceChip(
                      label: Text(category),
                      selected: productProvider.selectedCategory == category,
                      onSelected: (selected) {
                        if (selected) {
                          productProvider.filterByCategory(category);
                        }
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
