import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/remote_services.dart';

class ProductController extends GetxController {
  // Observables to track loading state and product data
  var isLoading = true.obs;
  var productList = <Product>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  // Calls the remote service to fetch jewellery data from the API
  void fetchProducts() async {
    try {
      isLoading(true);
      var products = await RemoteServices.fetchProducts();
      if (products != null && products.isNotEmpty) {
        productList.assignAll(products);
      } else {
        Get.snackbar("Error", "Could not fetch products. Please check your connection.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Fetch Error: $e");
    } finally {
      isLoading(false);
    }
  }
}
