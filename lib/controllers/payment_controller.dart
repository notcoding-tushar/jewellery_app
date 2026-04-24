import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'cart_controller.dart';

class PaymentController extends GetxController {
  late Razorpay _razorpay;
  final CartController cartController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    // Setting up the listeners for different outcomes
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout(double amount) {
    var options = {
      'key': 'rzp_test_ShTMaCnnaGmkmL', // PASTE YOUR KEY ID HERE
      'amount': (amount * 100).toInt(), // Razorpay expects amount in paise (100 paise = 1 Rupee)
      'name': 'Nice Jewellery',
      'description': 'Purchase of Jewellery Items',
      'prefill': {
        'contact': '9876543210',
        'email': 'tushar@example.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error opening Razorpay: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    cartController.cartItems.clear(); // Clear cart after successful payment
    Get.snackbar("Success", "Payment ID: ${response.paymentId}", snackPosition: SnackPosition.BOTTOM);
    Get.offAllNamed('/home'); // Send them back to home
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Failed", "Code: ${response.code} | ${response.message}", snackPosition: SnackPosition.BOTTOM);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("External Wallet", "Wallet: ${response.walletName}", snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    _razorpay.clear(); // Always clean up listeners
    super.onClose();
  }
}