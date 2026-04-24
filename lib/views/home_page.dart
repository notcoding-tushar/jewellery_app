import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import 'cart_page.dart';
import 'details_page.dart';
import '../models/product_model.dart';

class HomePage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CodeNicely Jewellery'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          // Reactive Shopping Cart Icon with Badge
          Obx(() => Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Badge(
              label: Text(cartController.cartItems.length.toString()),
              isLabelVisible: cartController.cartItems.isNotEmpty,
              child: IconButton(
                icon: const Icon(Icons.shopping_bag),
                onPressed: () => Get.to(() => CartPage()),
              ),
            ),
          ))
        ],
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Sales Analytics Chart
              if (cartController.salesData.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("Sales Analytics", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                  ),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text('Item ${value.toInt() + 1}', style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: cartController.salesData.entries.map((entry) {
                        int index = cartController.salesData.keys.toList().indexOf(entry.key);
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                                toY: entry.value.toDouble(),
                                color: Colors.teal,
                                width: 20,
                                borderRadius: BorderRadius.circular(4)
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ] else ...[
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: Text("No sales data available yet.", style: TextStyle(color: Colors.grey))),
                ),
              ],

              // Section 2: Horizontal Featured List
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("Top Picks", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productController.productList.length > 3 ? 3 : productController.productList.length,
                  itemBuilder: (context, index) {
                    var product = productController.productList[index];
                    return _buildProductCard(product, true);
                  },
                ),
              ),

              // Section 3: Vertical Catalog List
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text("All Jewellery", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: productController.productList.length,
                itemBuilder: (context, index) {
                  var product = productController.productList[index];
                  return _buildProductCard(product, false);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  // Reusable component for displaying product information in cards
  Widget _buildProductCard(Product product, bool isHorizontal) {
    return GestureDetector(
      onTap: () => Get.to(() => DetailsPage(), arguments: product),
      child: Container(
        width: isHorizontal ? 250 : double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Card(
          elevation: 3,
          child: ListTile(
            leading: Image.network(product.image, width: 50, height: 50, fit: BoxFit.contain, 
                errorBuilder: (c, e, s) => const Icon(Icons.image)),
            title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: const Icon(Icons.add_shopping_cart, color: Colors.teal),
              onPressed: () => cartController.addToCart(product),
            ),
          ),
        ),
      ),
    );
  }
}
