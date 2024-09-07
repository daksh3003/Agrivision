import 'package:flutter/material.dart';
import 'package:agriplant/data/newcartdetails.dart'; // Assuming this is the path

class ProductDetailPage extends StatelessWidget {
  final NewCartDetails product; // Change the type to NewCartDetails

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.image),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "\$${product.price.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 20),
            const Text("Product details will go here"),
          ],
        ),
      ),
    );
  }
}
