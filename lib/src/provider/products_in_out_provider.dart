// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:client_flutter_crud_node/src/apis/product_service.dart';
import 'package:client_flutter_crud_node/src/dto/requestDTO/Compra.dart';
import 'package:client_flutter_crud_node/src/dto/requestDTO/product_selected.dart';
import 'package:flutter/material.dart';

class ProductsInOutProvider extends ChangeNotifier {
  //IS LOADING
  bool _isActiveModal = false;
  bool get isActiveModal => _isActiveModal;
  set isActiveModal(value) {
    _isActiveModal = value;
    notifyListeners();
  } //IS LOADING

  Map<int, ProductSelected> bucketProductSelected = {};

  void cleanShoppingCart() {
    bucketProductSelected = {};
  }

  int putProductInBucket(ProductSelected productSelected) {
    if (bucketProductSelected[productSelected.id] == null) {
      bucketProductSelected[productSelected.id!] = productSelected;
      notifyListeners();
      return 1; //todo bien
    } else {
      bucketProductSelected[productSelected.id!] = productSelected;
      notifyListeners();
      return 2; //ya existia, se actualizo
    }
  }

  bool quitProductInBucket(ProductSelected productSelected) {
    if (bucketProductSelected[productSelected.id] == null) {
      return false; //no existe el producto
    } else {
      bucketProductSelected.remove(productSelected.id!);
      notifyListeners();
      return true; //se borro con exito
    }
  }

  Future<List<Object>> sendCompraSerial() async {
    if (bucketProductSelected.isNotEmpty) {
      String productsSerial = "";

      int pos = 0;
      for (var key in bucketProductSelected.keys) {
        pos++;
        int id = bucketProductSelected[key]!.id!;
        String nombre = bucketProductSelected[key]!.nombre!;
        int cantidad = bucketProductSelected[key]!.cantidadSelected!;
        double precio = bucketProductSelected[key]!.precioCompra!;

        if (cantidad < 1 || precio < 1) {
          return [
            3,
            "El producto $id: $nombre " +
                "\n no tiene cantidad agregada, ni precio agregado"
          ];
        }

        double precioPorProducto = precio / cantidad;
        if (bucketProductSelected.length == 1) {
          productsSerial = "$id|$cantidad|$precioPorProducto";
        } else if (bucketProductSelected.length == pos) {
          productsSerial += "$id|$cantidad|$precioPorProducto";
        } else {
          productsSerial += "$id|$cantidad|$precioPorProducto@";
        }
      }

      var compra = Compra(
        comentario: "Compra test",
        id_user_responsable: 16,
        productos_concat: productsSerial,
        cantidad_productos: pos,
      );

      var resEndPoint = ProductService().registerCompra(compra);

      String rptaServer = "";
      int valueRpta = 1;
      await resEndPoint.then((value) {
        if (value != null) {
          rptaServer = "${value.response}";
          valueRpta = 1;
        } else {
          valueRpta = 4;
          rptaServer = "Fallo Compra, Contactar al Administrador!";
        }
      });

      return [valueRpta, rptaServer];
    } else {
      return [2, "No hay productos!"];
    }
  }
}
