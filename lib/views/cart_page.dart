import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.find();

  CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      // Automatically updates UI when cart items change
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(child: Text("Your cart is empty!"));
        }

        return Column(
          children: [
            // List of cart items with quantity and subtotal per item
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  var product = cartController.cartItems.keys.toList()[index];
                  var quantity = cartController.cartItems[product]!;

                  return ListTile(
                    leading: Image.network(product.image, width: 50),
                    title: Text(product.title, maxLines: 1),
                    subtitle: Text('Qty: $quantity  |  \$${(product.price * quantity).toStringAsFixed(2)}'),
                  );
                },
              ),
            ),

            // Checkout Panel with price breakdown
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Subtotal:", style: TextStyle(fontSize: 16)),
                      Text("\$${cartController.subtotal.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Tax (18%):", style: TextStyle(fontSize: 16)),
                      Text("\$${cartController.taxes.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("\$${cartController.total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                      onPressed: () {
                        cartController.openCheckout(); // Launch Razorpay Payment Gateway
                      },
                      child: const Text("Proceed to Checkout"),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
