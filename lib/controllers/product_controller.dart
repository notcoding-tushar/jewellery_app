import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';

class ProductController extends GetxController {
  // .obs means "observable". The UI will watch these variables.
  // If they change, the UI will automatically redraw itself!
  var isLoading = true.obs;
  var productList = <Product>[].obs; // An empty list that will hold our products

  // This runs automatically as soon as the controller is created
  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  // The function that talks to the internet
  void fetchProducts() async {
    try {
      // 1. Tell the app we are loading
      isLoading(true);

      // 2. Make the call to the FakeStore API
      var response = await http.get(Uri.parse('https://fakestoreapi.com/products/category/jewelery'));

      // 3. Check if the call was successful (Status code 200 means OK)
      if (response.statusCode == 200) {

        // Translate the raw internet text into a Dart List
        var jsonData = json.decode(response.body) as List;

        // Loop through the list, use our Product blueprint, and save them
        productList.value = jsonData.map((item) => Product.fromJson(item)).toList();
      }
    } catch (e) {
      // In a real app, we'd show an error message here.
      // For now, we'll just print it to the console to keep it simple.
      print("Error fetching products: $e");
    } finally {
      // 4. Tell the app we are done loading, whether it succeeded or failed
      isLoading(false);
    }
  }
}

