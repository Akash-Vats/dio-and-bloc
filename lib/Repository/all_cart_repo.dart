import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../Services/services.dart';
import '../model/single_cart_model.dart';

class GetAllCarts {
  Future<List<CartModel>?> getAllData() async {
    try {
      var url = "https://dummyjson.com/carts";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print("---print response----${response.body}");

      if (response.statusCode == 200) {
        // Decode the response body
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Extract the list of carts
        List<dynamic> cartsList = data['carts'];

        // Convert the list into List<Carts>
        return cartsList
            .map((e) => CartModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        print('Failed to get carts: ${response.statusCode}');
        return null;
      }
    } catch (e, s) {
      print('Exception: $e\nStack trace: $s');
      return null;
    }
  }

  Future<CartModel> fetchCart(int id) async {
    final response =
        await http.get(Uri.parse("https://dummyjson.com/carts/$id"));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return CartModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load cart data');
    }
  }

  Future<void> patchCart(int cartId, Map<String, dynamic> data) async {
    const String baseUrl = 'https://dummyjson.com/carts';
    final url = '$baseUrl/$cartId';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Cart updated successfully');
      } else {
        print('Failed to update cart: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating cart: $e');
    }
  }

  Future<void> deleteCart(int cartId) async {
    print("---- cart id----${cartId}");
    final String baseUrl = 'https://dummyjson.com/carts';
    final url = '$baseUrl/$cartId';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      print("---url---$url");
      if (response.statusCode == 200) {
        print("----response dele---${response.body.toString()}");
        print('Cart deleted successfully');
      } else {
        throw Exception('Failed to delete cart');
      }
    } catch (e) {
      throw Exception('Error deleting cart: $e');
    }
  }

  Future<void> updateCart(int cartId, Map<String, dynamic> updatedCart) async {
    final response = await http.put(
      Uri.parse('https://dummyjson.com/carts/$cartId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedCart),
    );

    if (response.statusCode != 200) {
      updatedCart = jsonDecode(response.body);
    }
    throw Exception('Failed to update cart');
  }
}



class GetDio {
  final Dio dio;

  GetDio() : dio = Dio()..interceptors.add(GetDataInterceptor());

  Future<Response?> getAllProducts() async {
    try {
      var url = "https://dummyjson.com/products";

      final response = await dio.get(url);

      print("---print response----${response.data}");

      if (response.statusCode == 200) {
        print("User Data: ${response.data}");
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }

      return response;
    } catch (e, s) {
      print('Exception: $e\nStack trace: $s');
      return null;
    }
  }

  Future<Response?> detailData(int id) async {
    try {
      var url = "https://dummyjson.com/products/$id";

      final response = await dio.get(url);

      print("---print response details----${response.data}");

      if (response.statusCode == 200) {
        print("User details data: ${response.data}");
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }

      return response;
    } catch (e, s) {
      print('Exception: $e\nStack trace: $s');
      return null;
    }
  }

  Future<Response?> getAll({required int page, required int limit}) async {
    try {
      final String url =
          "https://dummyjson.com/products?skip=$page&limit=$limit";

      final response = await dio.get(url);

      // Print the response data for debugging
      print("---print response----${response.data}");

      if (response.statusCode == 200) {
        print("User Data: ${response.data}");
        return response;
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        return null;
      }
    } catch (e, s) {
      print('Exception: $e\nStack trace: $s');
      return null;
    }
  }

  /// correct
  /* Future<Response?> getAll({required int limit}) async {
    try {
      // Adjust the URL to include the limit parameter
      var url = "https://dummyjson.com/products?limit=$limit";

      // Make the GET request
      final response = await dio.get(url);

      // Print the response data for debugging
      print("---print response----${response.data}");

      // Check the status code and handle response accordingly
      if (response.statusCode == 200) {
        print("User Data: ${response.data}");
        return response; // Return the response if successful
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        return null; // Return null in case of failure
      }
    } catch (e, s) {
      print('Exception: $e\nStack trace: $s');
      return null; // Return null in case of an exception
    }
  }*/
}
