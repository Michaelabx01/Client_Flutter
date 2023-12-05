import 'dart:convert';

class Products {
  List<Product>? products;

  Products({this.products});

  factory Products.fromMap(jsonArray) {
    final List<dynamic> dataList = jsonDecode(jsonArray);

    final products_temp = <Product>[];

    for (var element in dataList) {
      products_temp.add(Product.fromJson(element));
    }

    return Products(
      products: products_temp,
    );
  }
}

class FindProduct {
  bool? state;
  String? response;
  Product? product;

  FindProduct({
    this.state,
    this.response,
    this.product,
  });

  factory FindProduct.fromJson(Map<String, dynamic> json) {
    if (json["state"]) {
      return FindProduct(
        state: json["state"],
        response: null,
        product: Product.fromJson(json["response"]),
      );
    } else {
      return FindProduct(
        state: json["state"],
        response: json["response"],
        product: null,
      );
    }
  }
}

class Product {
  int? id;
  String? nombre;
  String? comentario;
  int? cantidad;
  double? precio;
  int? idCategoria;
  bool? active;
  String? barcode;
  int? stock_min;
  String? imagen_url;
  String? categoria;
  int? id_user;

  Product({
    this.id,
    this.nombre,
    this.comentario,
    this.cantidad,
    this.precio,
    this.idCategoria,
    this.active,
    this.barcode,
    this.stock_min,
    this.imagen_url,
    this.categoria,
    this.id_user,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      nombre: json["nombre"],
      comentario: json["comentario"],
      cantidad: json["cantidad"],
      precio: json["precio"].toDouble(),
      idCategoria: json["id_categoria"],
      active: json["active"] == 0 ? false : true,
      barcode: json["barcode"],
      stock_min: json["stock_min"],
      imagen_url: json["imagen_url"],
      categoria: json["categoria"],
      id_user: json["id_user"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "nombre": nombre,
        "comentario": comentario,
        "cantidad": cantidad,
        "precio": precio,
        "id_categoria": idCategoria,
        "active": active,
        "barcode": barcode,
        "stock_min": stock_min,
        "imagen_url": imagen_url,
        "categoria": categoria,
        "id_user": id_user,
      };
}

class Categorias {
  List<Categoria>? categorias;

  Categorias({this.categorias});

  factory Categorias.fromMap(jsonArray) {
    final List<dynamic> dataList = jsonArray["content"];

    final categorias_temp = <Categoria>[];

    for (var element in dataList) {
      categorias_temp.add(Categoria.fromJson(element));
    }

    return Categorias(
      categorias: categorias_temp,
    );
  }
}

class Categoria {
  int? id;
  String? nombre;
  String? comentario;
  int? active;
  Categoria({
    this.id,
    this.nombre,
    this.comentario,
    this.active,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        id: json["id"],
        nombre: json["nombre"],
        comentario: json["comentario"],
        active: json["active"],
      );
}
