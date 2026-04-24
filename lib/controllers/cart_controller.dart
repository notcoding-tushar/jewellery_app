import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class CartController extends GetxController {
  var cartItems = <Product, int>{}.obs;

  // NEW: A map to hold our historical sales data for the graph
  var salesData = <String, int>{}.obs;

  // NEW: Load the graph data as soon as the app starts
  @override
  void onInit() {
    loadSalesData();
    super.onInit();
  }

  void addToCart(Product product, {int quantity = 1}) {
    if (cartItems.containsKey(product)) {
      cartItems[product] = cartItems[product]! + quantity;
    } else {
      cartItems[product] = quantity;
    }
    Get.snackbar("Item Added", "$quantity x ${product.title} added to cart", snackPosition: SnackPosition.BOTTOM);
  }

  double get subtotal => cartItems.entries.fold(0, (sum, item) => sum + (item.key.price * item.value));
  double get taxes => subtotal * 0.18;
  double get total => subtotal + taxes;

  Future<void> checkout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the sales to local storage
    cartItems.forEach((product, qty) {
      int currentSales = prefs.getInt(product.title) ?? 0;
      prefs.setInt(product.title, currentSales + qty);
    });

    cartItems.clear();

    // NEW: Refresh the graph data after a successful checkout!
    await loadSalesData();

    Get.defaultDialog(title: "Success", middleText: "Payment simulated successfully! Order placed.");
  }

  // NEW: Function to read local storage and prep the chart data (Max 4 products as required)
  Future<void> loadSalesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    salesData.clear();

    int count = 0;
    for (String key in prefs.getKeys()) {
      if (count >= 4) break; // Limit to 4 products for the graph
      salesData[key] = prefs.getInt(key) ?? 0;
      count++;
    }
  }
}