import 'package:flutter/material.dart';
import 'package:marketcoop/models/order.dart';
import 'package:marketcoop/widgets/order_item_widget.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Order> _orders = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading orders from Firebase
    await Future.delayed(const Duration(seconds: 1));

    // Mock data for demonstration
    final mockOrders = [
      Order(
        id: '1',
        userId: 'user123',
        items: [],
        totalAmount: 99.99,
        status: OrderStatus.delivered,
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
        shippingAddress: '123 Main St, City, State 12345',
        paymentMethod: 'Credit Card',
        trackingNumber: 'TRK123456789',
      ),
      Order(
        id: '2',
        userId: 'user123',
        items: [],
        totalAmount: 149.99,
        status: OrderStatus.shipped,
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        shippingAddress: '123 Main St, City, State 12345',
        paymentMethod: 'PayPal',
        trackingNumber: 'TRK987654321',
      ),
      Order(
        id: '3',
        userId: 'user123',
        items: [],
        totalAmount: 79.99,
        status: OrderStatus.processing,
        orderDate: DateTime.now().subtract(const Duration(hours: 6)),
        shippingAddress: '123 Main St, City, State 12345',
        paymentMethod: 'Credit Card',
      ),
    ];

    setState(() {
      _orders = mockOrders;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrders,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No orders yet',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start shopping to see your order history',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Start Shopping'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: OrderItemWidget(order: _orders[index]),
                      );
                    },
                  ),
                ),
    );
  }
} 