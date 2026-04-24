import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'auth_controller.dart';

class CartController extends GetxController {
  // Observables for cart items and historical sales data
  var cartItems = <Product, int>{}.obs;
  var salesData = <String, int>{}.obs;

  late Razorpay _razorpay;

  @override
  void onInit() {
    super.onInit();
    loadSalesData();
    _razorpay = Razorpay();
    
    // Initialize Razorpay event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay.clear(); // Clean up Razorpay instance on controller disposal
    super.onClose();
  }

  // Handle successful payment: trigger app checkout logic
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    checkout();
    Get.snackbar("Payment Successful", "Order ID: ${response.paymentId}",
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Failed", "Error: ${response.message}",
        backgroundColor: Colors.redAccent, colorText: Colors.white);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("External Wallet", "Wallet: ${response.walletName}");
  }

  // Configures and opens the Razorpay checkout gateway
  void openCheckout() {
    final AuthController auth = Get.find<AuthController>();

    var options = {
      'key': 'rzp_test_ShTMaCnnaGmkmL', // Razorpay API Key
      'amount': (total * 100).toInt(), // Amount in paise
      'name': 'CodeNicely Jewellery',
      'description': 'Jewellery Purchase',
      'prefill': {
        'contact': '9876543210',
        'email': auth.userEmail.value.isNotEmpty ? auth.userEmail.value : 'customer@example.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Error: $e');
    }
  }

  // Add product to cart or increment quantity if already exists
  void addToCart(Product product, {int quantity = 1}) {
    if (cartItems.containsKey(product)) {
      cartItems[product] = cartItems[product]! + quantity;
    } else {
      cartItems[product] = quantity;
    }
    Get.snackbar("Item Added", "$quantity x ${product.title} added to cart", 
        snackPosition: SnackPosition.BOTTOM);
  }

  // Getters for calculated price fields
  double get subtotal => cartItems.entries.fold(0, (sum, item) => sum + (item.key.price * item.value));
  double get taxes => subtotal * 0.18;
  double get total => subtotal + taxes;

  // Persists successful sales to local storage and clears the cart
  Future<void> checkout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    cartItems.forEach((product, qty) {
      int currentSales = prefs.getInt(product.title) ?? 0;
      prefs.setInt(product.title, currentSales + qty);
    });

    cartItems.clear();
    await loadSalesData(); // Refresh analytics graph

    Get.defaultDialog(title: "Success", middleText: "Order placed successfully!");
  }

  // Loads sales data from SharedPreferences for the analytics chart (limited to 4 items)
  Future<void> loadSalesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    salesData.clear();

    int count = 0;
    for (String key in prefs.getKeys()) {
      if (count >= 4) break; 
      salesData[key] = prefs.getInt(key) ?? 0;
      count++;
    }
  }
}
