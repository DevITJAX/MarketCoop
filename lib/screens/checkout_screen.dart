import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marketcoop/providers/cart_provider.dart';
import 'package:marketcoop/providers/auth_provider.dart';
import 'package:marketcoop/widgets/custom_text_field.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();
  String _selectedPaymentMethod = 'Credit Card';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
      _phoneController.text = user.phoneNumber ?? '';
      _addressController.text = user.address ?? '';
    }
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
    });

    // Simulate order processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.clearCart();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
            return const Center(
              child: Text('Your cart is empty'),
            );
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shipping Information
                        Text(
                          'Shipping Information',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _nameController,
                          labelText: 'Full Name',
                          prefixIcon: Icons.person_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _phoneController,
                          labelText: 'Phone Number',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _addressController,
                          labelText: 'Street Address',
                          prefixIcon: Icons.location_on_outlined,
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: _cityController,
                                labelText: 'City',
                                prefixIcon: Icons.location_city_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your city';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextField(
                                controller: _zipCodeController,
                                labelText: 'ZIP Code',
                                prefixIcon: Icons.pin_drop_outlined,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter ZIP code';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Payment Method
                        Text(
                          'Payment Method',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Card(
                          child: Column(
                            children: [
                              RadioListTile<String>(
                                title: const Text('Credit Card'),
                                subtitle: const Text('Visa, Mastercard, American Express'),
                                value: 'Credit Card',
                                groupValue: _selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPaymentMethod = value!;
                                  });
                                },
                              ),
                              const Divider(height: 1),
                              RadioListTile<String>(
                                title: const Text('PayPal'),
                                subtitle: const Text('Pay with your PayPal account'),
                                value: 'PayPal',
                                groupValue: _selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPaymentMethod = value!;
                                  });
                                },
                              ),
                              const Divider(height: 1),
                              RadioListTile<String>(
                                title: const Text('Cash on Delivery'),
                                subtitle: const Text('Pay when you receive your order'),
                                value: 'Cash on Delivery',
                                groupValue: _selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPaymentMethod = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Order Summary
                        Text(
                          'Order Summary',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                ...cartProvider.items.map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          item.product.title,
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Text(
                                        'x${item.quantity}',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        '\$${item.totalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )),
                                const Divider(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Subtotal:'),
                                    Text('\$${cartProvider.totalAmount.toStringAsFixed(2)}'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Shipping:'),
                                    Text('Free', style: TextStyle(color: Colors.green)),
                                  ],
                                ),
                                const Divider(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total:',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Place Order Button
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _placeOrder,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'Place Order - \$${cartProvider.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 