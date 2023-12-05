import 'dart:convert';
import 'package:client_flutter_crud_node/src/dto/requestDTO/Compra.dart';
import 'package:http/http.dart' as http;

import '../dto/responseDTO/product.dart';
import '../dto/responseDTO/UiResponse.dart';
import 'config_host.dart';

class ProductService {
  final String _apiHost = AppData().hostNodeServer;
  static const String _routePath_getAllCategory = "/getAllCategories";
  static const String _routePath_getAllProducts = "/getAllProducts";
  static const String _routePath_findProductBy = "/findProductBy";
  static const String _routePath_disableProductBy = "/disableProductBy";
  static const String _routePath_productoAddOrEdit = "/productoAddOrEdit";
  static const String _routePath_compraAdd = "/compraAdd";

  ProductService();

  Future<List<Product>?> getAllProducts(String id_categoria, int active) async {
    try {
      var headers = {
        'accept': 'text/plain',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'id_categoria': id_categoria,
        'active': active,
      });

      final response = await http.post(
          Uri.https(_apiHost, _routePath_getAllProducts),
          headers: headers,
          body: body);
      print("API" + response.statusCode.toString());
      if (response.statusCode == 200) {
        return Products.fromMap(response.body).products;
      }
    } catch (e) {
      print("ERROR $_routePath_getAllProducts: $e");
      return null;
    }
  }

  Future<FindProduct?> findProductBy(
      String? id, String? barcode, String? id_user) async {
    try {
      var headers = {
        'accept': 'text/plain',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'id': id,
        'barcode': barcode,
        'id_user': id_user,
      });

      final response = await http.post(
          Uri.https(_apiHost, _routePath_findProductBy),
          headers: headers,
          body: body);

      print("API" + response.statusCode.toString());
      if (response.statusCode == 200) {
        return FindProduct.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print("ERROR $_routePath_findProductBy: $e");
      return null;
    }
  }

  Future<List<Categoria>?> getAllCategories(int id) async {
    try {
      var headers = {
        'accept': 'text/plain',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'id_user_responsable': id,
      });
      final response = await http.post(
          Uri.https(_apiHost, _routePath_getAllCategory),
          headers: headers,
          body: body);
      print("API" + response.statusCode.toString());
      if (response.statusCode == 200) {
        return Categorias.fromMap(jsonDecode(response.body)).categorias;
      }
    } catch (e) {
      print("ERROR $_routePath_getAllCategory: $e");
      return null;
    }
    return null;
  }

  Future<UiResponseSimple?> registerOrEditProduct(Product product) async {
    try {
      var headers = {
        'accept': 'text/plain',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode(product);

      final response = await http.post(
        Uri.https(_apiHost, _routePath_productoAddOrEdit),
        headers: headers,
        body: body,
      );
      print("API" + response.statusCode.toString());
      if (response.statusCode == 200) {
        return UiResponseSimple.fromMap(jsonDecode(response.body));
      }
    } catch (e) {
      print("ERROR $_routePath_productoAddOrEdit: $e");
      return null;
    }
    return null;
  }

  Future<UiResponseSimple?> registerCompra(Compra compra) async {
    try {
      var headers = {
        'accept': 'text/plain',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode(compra);

      final response = await http.post(
        Uri.https(_apiHost, _routePath_compraAdd),
        headers: headers,
        body: body,
      );
      print("API" + response.statusCode.toString());
      if (response.statusCode == 200) {
        return UiResponseSimple.fromMap(jsonDecode(response.body));
      }
    } catch (e) {
      print("ERROR $_routePath_compraAdd: $e");
      return null;
    }
    return null;
  }
}
