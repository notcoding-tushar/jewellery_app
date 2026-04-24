import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../controllers/cart_controller.dart';

class DetailsPage extends StatelessWidget {
  // Get.arguments catches the product data we will pass from the Home Page
  final Product product = Get.arguments;

  // Find the existing cart controller so we don't create a duplicate
  final CartController cartController = Get.find<CartController>();

  // Local state for the increment/decrement counter
  final RxInt quantity = 1.obs;

  DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 1. The Image (Taking up roughly 30% of the screen)
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Image.network(
              product.image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
          ),

          // 2. The Text Details (Expanded so it takes up the remaining middle space)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // Price and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, color: Colors.teal, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(20)),
                        child: Text("⭐ ${product.rating['rate']} (${product.rating['count']} reviews)", style: const TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(product.description, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
                ],
              ),
            ),
          ),

          // 3. The Bottom Bar (Counter and Add to Cart)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Increment / Decrement Counter
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (quantity.value > 1) quantity.value--;
                        },
                      ),
                      Obx(() => Text('${quantity.value}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => quantity.value++,
                      ),
                    ],
                  ),
                ),

                // Add to Cart Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text("Add to Cart", style: TextStyle(fontSize: 16)),
                  onPressed: () {
                    // Send the product AND the chosen quantity to the cart
                    cartController.addToCart(product, quantity: quantity.value);
                    Get.back(); // Automatically go back to the home page after adding
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}