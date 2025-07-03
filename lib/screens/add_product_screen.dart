import 'package:flutter/material.dart';
import 'package:marketcoop/screens/profile_screen.dart';
import 'package:marketcoop/screens/role_selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:marketcoop/providers/auth_provider.dart';
import 'package:marketcoop/providers/product_provider.dart';
import 'package:marketcoop/models/product.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _stockQuantityController = TextEditingController();
  bool _isAvailable = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    _stockQuantityController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      final user = authProvider.user;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You must be logged in to add a product.')),
        );
        return;
      }
      final product = Product(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        category: _categoryController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        producerId: user.id,
        stockQuantity: int.tryParse(_stockQuantityController.text.trim()) ?? 0,
        isAvailable: _isAvailable,
      );
      await productProvider.addProduct(product);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Description' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Price' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Category' : null,
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              TextFormField(
                controller: _stockQuantityController,
                decoration: InputDecoration(labelText: 'Stock Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Stock Quantity' : null,
              ),
              SwitchListTile(
                title: Text('Available'),
                value: _isAvailable,
                onChanged: (val) => setState(() => _isAvailable = val),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
