import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marketcoop/providers/product_provider.dart';
import 'package:marketcoop/providers/auth_provider.dart';
import 'package:marketcoop/providers/order_provider.dart';
import 'package:marketcoop/widgets/product_card.dart';
import 'package:marketcoop/widgets/category_chip.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id;
      if (userId != null) {
        Provider.of<OrderProvider>(context, listen: false).fetchOrdersForUser(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MarketCoop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<ProductProvider>(context, listen: false).loadProducts();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  final user = authProvider.user;
                  final userName = user?.displayName ?? 'User';
                  final userEmail = user?.email ?? '';
                  final userPhone = user?.phoneNumber ?? '';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Email: $userEmail'),
                      Text('Phone: $userPhone'),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // Orders Section
              Text(
                'Your Orders',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Consumer<OrderProvider>(
                builder: (context, orderProvider, child) {
                  if (orderProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (orderProvider.orders.isEmpty) {
                    return const Text('No orders yet.');
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orderProvider.orders.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final order = orderProvider.orders[index];
                      return ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text('Order #${order.id.substring(0, 6)}'),
                        subtitle: Text('Date: ' + DateFormat('yMMMd').format(order.orderDate)),
                        trailing: Text('${order.totalAmount.toStringAsFixed(2)}'),
                        onTap: () {
                          // Optionally show order details
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // Categories Section
              Text(
                'Categories',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  return SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productProvider.categories.length,
                      itemBuilder: (context, index) {
                        final category = productProvider.categories[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CategoryChip(
                            label: category,
                            isSelected: productProvider.selectedCategory == category,
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
              const SizedBox(height: 24),

              // Featured Products Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Products',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to products screen
                      DefaultTabController.of(context).animateTo(1);
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Products Grid
              Consumer<ProductProvider>(
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
                            'Failed to load products',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            productProvider.error!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              productProvider.loadProducts();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final products = productProvider.filteredProducts.take(6).toList();
                  
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
                            'No products available',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Check back later for new products',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
            ],
          ),
        ),
      ),
    );
  }
} 