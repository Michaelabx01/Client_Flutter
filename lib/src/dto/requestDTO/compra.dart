class Compra {
  String comentario;
  int id_user_responsable;
  String productos_concat;
  int cantidad_productos;

  Compra({
    required this.comentario,
    required this.id_user_responsable,
    required this.productos_concat,
    required this.cantidad_productos,
  });

  Map<String, dynamic> toJson() => {
        "comentario": comentario,
        "id_user_responsable": id_user_responsable,
        "productos_concat": productos_concat,
        "cantidad_productos": cantidad_productos,
      };
}
