class ProductSelected {
  int? id;
  String? imagenUrl;
  String? nombre;
  int? cantidadSelected;
  set cantidadSelectedSet(int cantidad) {
    cantidadSelected = cantidad;
  }

  double? precioCompra;
  set precioCompraSet(double precio) {
    precioCompra = precio;
  }

  ProductSelected({
    this.id,
    this.imagenUrl,
    this.nombre,
    this.cantidadSelected = 0,
    this.precioCompra,
  });
}
