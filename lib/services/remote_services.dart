import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class RemoteServices {
  static var client = http.Client();

  // Fetches jewellery specifically from the FakeStore API
  static Future<List<Product>?> fetchProducts() async {
    try {
      var response = await client.get(
          Uri.parse('https://fakestoreapi.com/products/category/jewelery')
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var jsonString = response.body;
        return productFromJson(jsonString);
      } else {
        return null;
      }
    } catch (e) {
      print("API Connection Error: $e");
      return null;
    }
  }
}